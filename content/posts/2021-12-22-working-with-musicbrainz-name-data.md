---
title: Working with MusicBrainz Name Data
author: Dave Rolsky
type: post
date: 2021-12-22T23:18:15-06:00
url: /2021/12/22/working-with-musicbrainz-name-data
---

Since leaving my job last October I've been working on various personal
projects for fun and learning. One of those is a music player[^1] written
entirely in [Rust](https://www.rust-lang.org/), including a web-based frontend
using [Seed](https://seed-rs.org/), which is an Elm-like frontend framework in
Rust. I'd like to write some other posts about that as well, but today let's
talk about artist names, specifically how these are represented in the
[MusicBrainz](https://musicbrainz.org/) data.

I have a _lot_ of Japanese music[^2], and one of the main reasons I don't like
any of the music players I've tried so far[^3] is their handling of non-Latin
script names and titles. More specifically, most players only allow one name
(plus a sortable name if you're lucky). I find this annoying because what I'd
really like to see in many cases is a Latin transcription or English
translation instead of the original. For reference, a transcription is a
phonetic representation of a name.

I prefer to see a transcribed name like
["Ryokushaka"](https://www.ryokushaka.com/) instead of "緑黄色社会". I also
prefer the transcription over the translation, "Green Yellow Society". But
it's nice to be able to _see_ the Japanese name as well, especially if I'm
trying to search the web for information about the artist or search YouTube
for videos.

So what I really want is a tool that can handle multiple canonical values for
each name or title, specifically the name according to the artist as well as
optional transcribed and translated names for non-Latin names. And each of
those canonical names also needs a sortable version (at least for artists), so
"The Beatles" sorts as "B", not "T".

In order to accomplish this, I need to get more data than my MP3 files
have. The best data source I've found is the MusicBrainz project, which is a
fantastic open source/open data project for collecting information about all
recorded music, or in their words, "MusicBrainz is an open music encyclopedia
that collects music metadata and makes it available to the public." It's a lot
like Wikipedia in that anyone can make an account and contribute edits. It's
also a lot like Wikipedia in that the quality and correctness of entries
varies wildly.

MusicBrainz (MB) allows for artists, releases (albums), and tracks to have
many different names/titles. I will focus on artists for now, since artists
have the most complex name data. An artist has a primary name, an optional
sortable name, and zero or more aliases. Each alias has a name, an optional
sortable name, an optional locale, a boolean indicating whether its the
primary alias for a locale, and a type. Artists may also appear with different
names in artist credits, either of their own albums or others, like
compilation albums or as guest artists on someone else's album.

The possible alias types are "Artist name", "Legal name", and "Search
hint". An "Artist name" is another version of the name they perform under. A
"Legal name" alias is used to record the name for people who perform under an
alias, like Madonna or Lady Gaga. I'm just filtering these out, since they're
not interesting for my purposes. A "Search hint" can be a common misspelling
of their name, a fan nickname, or anything else that helps the search engine
be smarter.

To make things a little more complex, MB has a policy of having the primary
sortable name _always_ be in Latin script, even if the primary name is
not.

Let's use [Kenichi Asai](http://www.sexystones.com/)[^4] as an example. For
reference, his personal name (aka "first name") is "Kenichi" and his family
name (aka "last name") is "Asai". In English we'd typically write "Kenichi
Asai", but you might also see "Asai Kenichi", because Japanese usage always
put the family name first. Sometimes you'll also see "ASAI Kenichi" to denote
that "Asai" is the family name.

Here are all of his names in the MB data:

| **Name** | **Sortable name** | **Locale** | **Alias type** |
| -------- | ----------------- | ---------- | -------------- |
| **Primary name** |
| 浅井健一 | Asai, Kenichi |
| As I noted, MB has a policy of always using a Latin script sortable name for primary names. |
| **Aliases** |
| Kenichi Asai | Asai, Kenichi | en (primary) | Artist name |
| 浅井健一 | あさいけんいち | ja (primary) | Artist name |
| The sortable name here is the Kanji (Chinese characters) written entirely in Hiragana[^5] in order to make the pronunciation clear. This is how 
| 浅井&nbsp;健一 | あさい&nbsp;けんいち | ja | Artist name |
| This one differs from the previous one by having a space between the family and personal names, which is not how Japanese is typically written. |
| Asai Ken'ichi	| | | Search hint |
| An alternate Latin transcription of his personal name. There are many different Romanization systems for Japanese. |
| Benzie | ベンジー |  | Artist name |
| A nickname of his, which as far as I can tell is not used for any music credits, so this should probably be a Search hint instead |
| **Artist credits** |
| Asai Kenichi |
| Kenichi Asai |
| Santana feat. Kenichi Asai |
| 浅井健一 |

Wow, that's a lot names! But we can see that there's a number of duplicates.

So the question is how to take that list and boil it down to the following elements:

* The "real" name, by which I mean the name the artist typically uses in their home locale.
* A sortable version of that real name if it differs from the real name.
* A transcribed name if the real name is not in Latin script.
* A translated name if the real name is not in Latin script _and_ the real
  name is not a personal name. In other words, it doesn't make sense to
  "translate" 浅井健一 (Kenichi Asai), which is a personal name. But it _does_
  make sense to translate a band name, for example translating 緑黄色社会 into
  "Green Yellow Society".

The answer, of course, is to use a whole bunch of heuristics, because this is
impossible to get 100% right, especially since the source data can be
incorrect and incomplete. There's not a lot of consistency in how people end
up inputting non-Latin names, and I'm pretty sure the artist credit of "Asai
Kenichi" is just wrong and the correct credit is either "浅井健一" or "Kenichi
Asai".

So here's the algorithm I have so far ...

First, we need a way to figure out if a name is in Latin script or not. A name
is Latin (for my purposes) if it matches this regex:
`\A[\p{Latin}&\P{L}]+\z`. The `\p{Latin}` matches any Unicode character marked
as being part of the Latin script[^6]. This includes ASCII letters, but also
things like "ą", "Ň", etc. The `\P{L}` matches any character that is not a
letter, including numbers, emoji, etc. These two matches are combined together
into a single character set. This is a pretty good heuristic and will get it
right for pretty much anything that an English reader can pronounce (or
reasonably mangle), including names like "Björk" or "Sigur Rós", while not
matching things we can't pronounce, like "緑黄色社会" or "Чайковский"
(Tchaikovsky).

The only place this goes wrong is names that include non-Latin characters for
emoticons like "(┛◉Д◉)┛彡┻━┻". While it does include a Cyrillic character,
"Д", and a Chinese radical, "彡", it is not in a foreign language and doesn't
need to be transcribed or translated (though it's also completely
unpronounceable). Looking at the MB data, this _is_ a thing. There's an artist
named "（´・д・）ﾉ" in the database. I'm not sure how you'd pronounce
this. Treating this as non-Latin is fine. If the artist has an alternate alias
that's speakable, then it'd be good to have that, and if they don't, that's
okay.

I start by pulling all the possible names from the MB data and categorizing
them into three types:

* The Primary name, which is the name attached to the artist record, as
  opposed to aliases.
* Aliases which aren't search hints. Names used in artist credits are also put
  in this category.
* Search hints.

I have a special case for the fact that MB uses Latin script sortable names
for non-Latin names. In some cases the only instance of a Latin name is as the
primary sortable name. In that case, I add that sortable name to my list of
names as an alias. To make things trickier, this sortable name may be
something like "Asai, Kenichi", so I transform it back to "Kenichi Asai" if it
contains ", " (a comma followed by a space)[^7].

Once I have all these names I have to figure out the best primary name and
sortable name, transcribed name and sortable name, and translated name and
sortable name. Of these, only the primary name is required. Everything else is
optional.

I should only have one primary name. If this name is Latin, I use that along
with the corresponding primary sortable name. If the primary name is _not_
Latin but its sortable name _is_ Latin, then I use the name but not the
sortable name.

It's very important to take the primary name as given by the MB
data. Originally I tried preferring non-Latin names, but that doesn't work at
all. There are lots of Japanese bands whose canonical names are in English,
like [the pillows](http://pillows.jp/) and [The Back
Horn](https://www.thebackhorn.com/). While these bands do have Japanese
aliases, their correct name is in English. There's also even weirder cases
like a band named [moools](https://www.moools.com/), which is not exactly in
English but is still always written in Latin script.

If the primary name is not Latin, then I look at the remaining names to try to
figure out whether there are transcribed and/or translated names that can be
used.

To do that I first filter out all the names that match the primary name and
sortable name, as well as any names not in Latin script. Then I go through
whatever's left and split each name into words. For each word, I look up the
word in a dictionary (right now a copy of `/usr/share/dict/words`) and count
how many words in the name are in our dictionary[^8].

If there's only one name, then if it contains any known words it's a
translation, otherwise it's a transcription.

If we have multiple possible names to choose from, I use the known word counts
to (attempt to) distinguish a transcription from a translation. A name with
more known words from the dictionary is more likely to be a translation. So if
we have many possibilities, the one with the most known words is a
translation, and everything else is a transcription. This part of the
algorithm works well for band names.

As an illustration of how this works, let's take one of my favorite bands, [東
京事変](https://www.tokyojihen.com/). Their name translates to "Tokyo
Incidents", and the transcription is "Tokyo Jihen". Because "Tokyo" and
"Incidents" are both in the word list, the algorithm picks "Tokyo Incidents"
as the translation, with two known words, and "Tokyo Jihen" as the
transcription, with just one known word.

This works less well for person names, since in that case I really don't want
to pick a translated name at all. There will be cases where a person's name
transcription ends up containing an english word, a Chinese name that
transcribes as "Hui Ping". A future revision will probably want to look at
whether it's dealing with a person or entity.

This gives me a list of possible transcriptions and translations, each of
which is a name plus an optional sortable name. To pick the best one from
each, I sort each list. If the name came from an alias for the `en` locale, I
prefer that. If multiple names came from that locale, I tiebreak by looking at
whether one was marked as the primary alias for that locale. If _that_ doesn't
work, I prefer names that also have sortable names. And if there are still
ties, I sort by string length and then just sort the names, in order to ensure
that the algorithm picks the same name every time given the same inputs.

Everything that isn't picked is stored as a search hint, so I don't have to
remember the name the system chose for an artist.

Phew, that's a lot!

I really enjoy working on this sort of problem, where we have messy data and
have to find a best path through to get the results we want.

But I originally started working on this (weeks ago) to do a quick version of
the data importer so I could whip up a quick backend so I could get back to
where I started, which was the frontend. I had put the frontend on hold
because I felt like I needed more real data to work with in order to make more
progress on the frontend. Now my importer is capable of importing my entire
music collection, so it's time to whip up that backend and get back to the UI
work.

[^1]: I will probably release the code for this at some point but for now it's
    in a private repo.
[^2]: The topic of how and why there's so much amazing Japanese music as
    compared to non-Japanese music is an interesting one that I'm only sort of
    qualified to write about. Maybe I'll get into this in a future blog post.
[^3]: I currently use Rhythmbox on my computer and YouTube Music on my
    phone. Both could be better.
[^4]: He's a fantastic guitarist and songwriter. Here's [a video for one of
    his songs](https://youtu.be/5lWvh9Wh9nE). Also, as an aside, the drummer
    has a right handed drum kit but is playing the hi-hat with his left hand,
    which is really weird to see.
[^5]: Hiragana is one of two Japanese syllabaries (like an alphabet but the
    components are syllables, not letters). It is used for Japanese words and
    Katakana, the other syllabary, is used for foreign words. In Japanese,
    word(s) are often sorted by their pronunciation rather than some more
    abstract system based on the properties of the kanji used to write the
    word(s)[^9].
[^6]: Thank dog that Unicode characters have so much metadata! Without this
    I'm not sure how I'd test if a name is Latin or not.
[^7]: I should probably _not_ do this if there are two commas to handle band
    names that are lists, like if "Earth, Wind & Fire" used an Oxford comma,
    which they don't. But the perfect is the enemy of the good, and I want to
    get a good enough version going so I can work on other things.
[^8]: If a word contains a hypen I will also split that up and check the
    subparts to see if they're words. This would handle something like
    "Green-Yellow", which isn't a word, but is clearly made of words.
[^9]: Sorting based on abstract properties is exactly how Chinese is sorted,
    since Chinese doesn't really have a syllabary (except it does, but people
    don't use the syllabaries for day to day stuff very much, unlike in
    Japan).
