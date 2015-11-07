---
title: Javascript String Type
author: NC
category: javascript
public: true
---

- Javascript strings are sequences of unsigned 16-bit values.

#### Surrogate Pairs

- The most commonly used Unicode characters have **codepoints** that fit in 16 bits and can be represented by a single **element** of a string.
- Unicode characters whose codepoints do not fit in 16 bits are encoded following the rules of **surrogate pairs**.
- A Javascript string of length 2 (two 16-bit values) might represent only a single **Unicode character**:

```js
var p = "π";   // π is 1 character with 16-bit codepoint 0x03c0
var e = "e";   // e is 1 character with 17-bit codepoint 0x1d452
p.length       // => 1: p consists of 1 16-bit element
e.length       // => 2: UTF-16 encoding of e is 2 16-bit values: "\ud835\udc52"
```

- The various string-manipulation methods defined by Javascript operate on 16-bit values, not on characters. They do not treat surrogate pairs specially, perform no normalization of the string, and do not even ensure that a string is well-formed UTF-16.

```js
var s = "hello, world"
s.length       // the number of 16-bit values it contains
```

- In ES5, string declarations can span more than one line:

```js
"one\
long\
line"
```

#### String properties and methods:
```js
length
charAt( index )
substring( first index [, last index])    // returns new string (Strings are immutable)
slice( first index [, last index])        // returns new string (Strings are immutable)
indexOf( text )
lastIndexOf( text )
split( text )                             // returns new string array
replace( text1 , text2  )                 // returns new string (Strings are immutable)
toUpperCase()                             // returns new string (Strings are immutable)
charCodeAt
compareLocale
concat
localeCompare
match
search
toLocaleUpperCase
toLocaleLowerCase
toLowerCase
toString
trim
valueOf
```


**References**
[JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
