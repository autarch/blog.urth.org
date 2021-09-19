---
title: Down the Golang nil Rabbit Hole
author: Dave Rolsky
type: post
date: 2021-03-27T14:36:28-05:00
url: /2021/03/27/down-the-golang-nil-rabbit-hole
discuss:
    - site: "/r/golang"
      uri: "https://www.reddit.com/r/golang/comments/mem9he/down_the_golang_nil_rabbit_hole/"
    - site: "/r/programming"
      uri: "https://www.reddit.com/r/programming/comments/mem9kp/down_the_golang_nil_rabbit_hole/"
---

_Edit 2021-03-30_: Jeremy Mikkola [wrote about some closely related
topics](http://jeremymikkola.com/posts/2017_03_29_know_your_nil.html) back in
2017.

_Edit 2021-03-31_: Chris Siebenmann [wrote a response to this
post](https://utcc.utoronto.ca/~cks/space/blog/programming/GoNilIsTypedSortOf)
that explains exactly how interface values that are `nil` are typed. It's more
complicated than I thought!

I'm not sure I have another Rust & Postgres blog post in me right now, so
let's learn something about Go instead.

Recently I decided I wanted to add a `--unique` flag to
[omegasort](https://github.com/houseabsolute/omegasort). Wait, what's
omegasort?

It's a text file sorting tool that supports lots of different sorting
methods. For example, in addition a standard text sort, it can sort numbered
lines, date-prefixed lines, paths (including Windows paths with and without
drive letters), IP addresses, and IP networks. It also supports Unicode
locales, reverse sorting, and locale-aware case insensitive sorting.

I use it together with [precious](https://github.com/houseabsolute/precious)
to sort things like `.gitignore` files, spellchecker allowlists, and things of
that nature.

I realized that I really wanted a `--unique` flag for all of this. While I
could just pipe its output to `uniq` on a *nix system, this doesn't work so
well on Windows. Plus with tools like precious it's easier if I can use one
binary for a given task. If I want to pipe things I have to put that in a
shell script that precious calls.

But my rabbit hole experience didn't happen with omegasort directly. Instead,
it happened when I tried to add some integration tests.

While writing those integration tests, I was using
[`github.com/houseabsolute/detest`](https://github.com/houseabsolute/detest). This
is a Golang package I created that offers a test assertion interface inspired
by [`Test2-Suite`](https://metacpan.org/release/Test2-Suite) in Perl.

For reference, here's a `Test2-Suite` example:

```perl
use Test2::Suite;

object Subtest => sub {
    call name      => 'TestsFor::Basic';
    call pass      => T();
    call subevents => array {
        object Plan => sub {
            call max   => 4;
            call trace => object {
                call package => 'Test::Class::Moose::Role::Executor';
                call subname => 'Test::Class::Moose::Util::context_do';
            };
        };
    ...
}
```

I think this is pretty self-explanatory, except for `T()`, which means "true".

And here's something like that in Go with `detest`:

```go
import (
	"testing"
	"github.com/houseabsolute/detest/pkg/detest"
)

func TestSomething(t *testing.T) {
	d := detest.New(t)
	d.Is(
		someStruct,
		d.Struct(func(st *detest.StructTester) {
			st.Field("size", 43)
			st.Field("Name", "Douglas")
			d.Map(func(mt *detest.MapTester) {
				mt.Key("foo", d.Slice(func(st *detest.SliceTester) {
					st.Idx(0, d.Map(func(mt *detest.MapTester) {
						mt.Key("bar", d.Slice(func(st *detest.SliceTester) {
							st.Idx(1, "buz")
							st.Idx(2, "not quux")
						}))
					}))
					st.Idx(1, d.Map(func(mt *detest.MapTester) {
						mt.Key("nosuchkey", d.Slice(func(st *detest.SliceTester) {
							st.Idx(1, "buz")
							st.Idx(2, "not quux")
						}))
					}))
				}))
			})
		}),
	)
}
```

It's not as nice as the Perl version because it gets quite verbose, but this
was the closest I could come. Go's type system, combined with a lack of
syntactic flexibility, means a whole lot of func calls, braces, and parens.

Under the hood, this is implemented with a metric fork ton of runtime
reflection using the stdlib's [`reflect`
package](https://pkg.go.dev/reflect). I don't love this, but absent generics,
there's no other way to implement this sort of API except with code
generation. And that codegen would have to be fed by a sort-of-Go language
that was translated to real Go, which seems like a terrible idea.

## Getting to the Darn Point

So while I was writing those omegasort integration tests using detest, I
managed to find a whole lot of bugs in detest.

But the title says `nil` and I haven't mentioned those yet.

So here's a fun fact, Go has multiple "types" of `nil`. Specifically, there
are both typed and untyped `nil` variables. This surprised me at first, but it
makes sense when you think about it.

Let's take this code[^1]:

```go
package main

import (
	"fmt"
	"reflect"
)

func main() {
	v1 := reflect.ValueOf(nil)
	var uninit []int
	v2 := reflect.ValueOf(uninit)
	logValue("nil", v1)
	logValue("[]int", v2)
	fmt.Printf("[]int == nil? %v\n", uninit == nil)
}

func logValue(what string, v reflect.Value) {
	fmt.Printf("%s is valid? %v\n", what, v.IsValid())
	if v.IsValid() {
		fmt.Printf("%s is nil? %v\n", what, v.IsNil())
		fmt.Printf("%s type = %v\n", what, v.Type())
	}
}
```

This prints out the following:

```
nil is valid? false
[]int is valid? true
[]int is nil? true
[]int type = []int
[]int == nil? true
```

So a bare `nil` and a variable that has a type but no value are equal, but if
you try to get a `reflect.Value` for `nil`, it's not valid. If you try to call
other methods like `v.IsNil()` or `v.Type()` on an invalid[^4] `reflect.Value`,
you will get a panic.

I encountered this when trying to test that an `error` returned by a func call
was `nil`.

This led to a flurry of [`detest`
releases](https://github.com/houseabsolute/detest/releases) as I realized how
many parts of the `detest` code this impacted. In most places where it uses
`reflect`, I have to guard against a bare `nil` being passed in.

But wait, it gets even more confusing. Sometimes the Go compiler will turn an
untyped `nil` into a typed `nil`. Here's an example[^2]:

```go
package main

import (
	"fmt"
	"reflect"
)

func main() {
	takesSlice("nil", nil)
	var uninit []int
	takesSlice("[]int", uninit)
}

func takesSlice(what string, s []int) {
	logValue(what, reflect.ValueOf(s))
}

func logValue(what string, v reflect.Value) {
	fmt.Printf("%s is valid? %v\n", what, v.IsValid())
	if v.IsValid() {
		fmt.Printf("%s is nil? %v\n", what, v.IsNil())
		fmt.Printf("%s type = %v\n", what, v.Type())
	}
}
```

And when we run it we get this:

```
nil is valid? true
nil is nil? true
nil type = []int
[]int is valid? true
[]int is nil? true
[]int type = []int
```

So when I pass a bare `nil` to `takesSlice`, it gets typed as whatever type
the function's signature says it should be.

But wait, it gets even more confusing yet again! Sometimes the Go compiler
**won't** turn an untyped `nil` into a typed `nil`. Here's an example[^3]:

```go
package main

import (
	"fmt"
	"reflect"
)

func main() {
	takesError("nil", nil)
	var uninit error
	takesError("error", uninit)
}

func takesError(what string, e error) {
	logValue(what, reflect.ValueOf(e))
}

func logValue(what string, v reflect.Value) {
	fmt.Printf("%s is valid? %v\n", what, v.IsValid())
	if v.IsValid() {
		fmt.Printf("%s is nil? %v\n", what, v.IsNil())
		fmt.Printf("%s type = %v\n", what, v.Type())
	}
}
```

If the type of the argument in the function signature is any type of
interface, including `interface{}`, then the underlying value is still untyped
and not valid. This ... sort of makes sense? I think the way this works is
that anything typed as an interface also has a _real_ underlying type. So an
`error` can be an `errors.errorString` or an `exec.ExitError` or a
`mypackage.DogError`. But if we pass a bare `nil` or an uninitialized
variable, there's no underlying type.

This came up with detest when I wanted to test that I _didn't_ get an error
from a call.


```go
err := doThing()
d.Is(err, nil, "no error from doing a thing")
```

Under the hood, the signature for `d.Is()` uses `interface{}` for the two
arguments being compared. So bare `nil` as the second argument will _never_ be
valid. And the first argument might be valid or it might not be. If
`doThing()`'s return type is just `error` and it returns a `nil`, then the
value in `err` has no type.

All of this led to a fair bit more code in the `detest` guts to handle
this. For example, just because two variables don't have the same type doesn't
mean they're not equal (from Go's perspective). A bare `nil` and an
uninitialized slice are equal when compared with `==`, which is what `d.Is()`
emulates using `reflect`.

So there's quite a few cases around one or both arguments being invalid that
need handling. And there are MANY other methods with the same issues to
consider, including things like `d.Map()` and `d.Struct()`, all of which
should handle an invalid value properly.

## What Does This Look Like in Other Languages?

Well, I don't know _that_ many other languages. In Perl this isn't really a
thing, because it has a pretty minimal type system. Perl's `undef` can be
coerced to lots of things, although under
[strict](https://perldoc.perl.org/strict) trying to use an `undef` in certain
ways is an error, like writing this:

```perl
my $x;
say @{$x};
```

This will blow up with `Can't use an undefined value as an ARRAY reference
...` at line 2.

Rust (at least safe Rust[^6]) doesn't have any notion of `nil` or undefined
values. Instead, you have the
[`Option<T>`](https://doc.rust-lang.org/std/option/enum.Option.html) type,
which always has a type. For example[^5]:

```rust
pub fn main() {
    let a: Option<String> = None;
    let b: Option<i32> = None;
    println!("a == b? {}", a == b);
}
```

This just won't compile. While both `a` and `b` are `None`, they're not the
_same type_ of `None` so you can't just compare them with `==`. The compiler
says:

```
error[E0308]: mismatched types
 --> src/main.rs:4:33
  |
4 |     println!("a == b? {}", a == b);
  |                                 ^ expected struct `String`, found `i32`
  |
  = note: expected enum `Option<String>`
             found enum `Option<i32>`
```

By the way, aren't these Rust compiler errors nice? The only other language
I've seen with this type of extremely detailed compiler errors is
[Raku](https://raku.org/).

## In Summary

It's tempting to pick on Go and complain about it. I certainly do that a lot
at work. But to be fair, this really isn't an issue for most Go code. It's
only because I'm trying to do weird stuff with `reflect` that I'm learning
about this internal weirdness. In day to day Go code, the compiler's handling
of various types of `nil` "just works" the way you'd expect it to. And being
able to use a bare `nil` is quite handy.

But I still prefer how Rust does it, using a parameterized `Option<T>`
type. That way I can easily check if something is `None` without any special
cases. Everything is using the same type system, though that type system is
much more complex than Go's.


[^4]: Note that an "invalid" value in the context of `reflect` is not invalid
    in the context of a Go program. You can use an invalid value everywhere
    you can use the corresponding valid but uninitialized `nil` value.

[^1]: [https://play.golang.org/p/Xo5hXUIw01U](https://play.golang.org/p/Xo5hXUIw01U)

[^2]: [https://play.golang.org/p/HKQBiFCNINk](https://play.golang.org/p/HKQBiFCNINk)

[^3]: [https://play.golang.org/p/NMsi05CH8r3](https://play.golang.org/p/NMsi05CH8r3)

[^5]: [https://play.rust-lang.org/?version=stable&mode=debug&edition=2018&gist=677599a2ff660f57b51a31219f428312](https://play.rust-lang.org/?version=stable&mode=debug&edition=2018&gist=677599a2ff660f57b51a31219f428312)

[^6]: I know very little about unsafe Rust which is why I'm hedging.
