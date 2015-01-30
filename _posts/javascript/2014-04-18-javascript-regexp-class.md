---
title: Javascript RegExp Class
author: NC
category: javascript
public: true
---

- Text between a pair of slashes constitutes a regular expression literal.
- ```/^HTML/```
	- Match the letters H T M L at the start of a string.
- ```/[1-9][0-9]*/```
	- Match a non-zero digit, followed by any number of digits.
- ```/\bjavascript\b/i```
	- Match "javascript" as a word, case-insensitive.
- ```var text = "testing: 1, 2, 3";```
	- ```var pattern = /\d+/g```
		- Matches all instances of one or more digits.
	- ```text.search(pattern)```
		- ```9``` position of first match.
	- ```text.match(pattern)```
		- ```["1", "2", "3"]``` array of all matches.
	- ```text.replace(pattern, "#");```
		- ```"testing: #, #, #"```
	- ```text.split(/\D+/);```
		- ```["","1","2","3"]``` split on non-digits
	- ```pattern.test(text)```
		- ```true```  a match exists

**References**

[JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
