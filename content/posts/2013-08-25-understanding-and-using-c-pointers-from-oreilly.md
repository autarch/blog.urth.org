---
title: Understanding and Using C Pointers from O’Reilly
author: Dave Rolsky
type: post
date: 2013-08-25T20:48:25+00:00
url: /2013/08/25/understanding-and-using-c-pointers-from-oreilly/
featured_image: /files/2013/08/c-pointers.gif
---
For many years now I've flirted with the idea of finally learning C programming. I'd make attempts which usually consisted of re-reading the Kernighan and Ritchie book _The C Programming Language_, trying to hack on some C code, and then giving up in frustration. I really have no idea why that book is so widely lauded. It teaches the basic syntax of C, but does almost nothing to teach you the core concepts. It basically assumes that you understand the underlying memory model of the system and how C exposes it. That may have been fine in 1978 but for anyone who's coming to C from something like Perl or Java, as opposed to assembly, it's wildly unhelpful.

For years I'd wanted to find a book that would clearly explain pointers and memory management, but nothing seemed to exist. Recently at my day job I was trying to refactor some bits of a C library we created for reading a binary data format (that we also created). As usual, I struggled with my poor C knowledge. I have a free Safari subscription from days as an O'Reilly author so I figured I'd take a look at the C books.

I saw [_Understanding and Using C Pointers_][1] and hoped against hope that this was the book I'd been waiting ten years or so for. It was. This is a book length examination of C pointers, arrays, memory management, structs, and all that stuff that the K&R book glosses over in a few pages. It even has pretty pictures that help make sense of pointers and their relationship to arrays, the stack, the heap, and so on.

I truly and deeply ♥ this book. If you've had the same struggles I've had with this aspect of C, I can't recommend it strongly enough.

After reading it, I can actually debug a segfault with knowledge as opposed to my previous strategy of flailing at it until it goes away. That's the most powerful endorsement I can think of.

 [1]: http://shop.oreilly.com/product/0636920028000.do

## Comments

**Caleb Cushing, on 2013-08-25 17:34, said:**  
Adding this to my wishlist... I did like Programming Principles and Practices with C++ by Bjarne Stroustrup, that book helped me understand references, and esp why use a reference over passing a value and when (never made sense because in the academic examples most books give, it just doesn't actually matter). Pointers still eluded however.

**bennymack, on 2013-08-26 14:09, said:**  
Purchased.