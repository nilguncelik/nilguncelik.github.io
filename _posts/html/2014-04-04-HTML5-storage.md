---
title: HTML5 Storage
author: NC
category: html
public: true
---

1. Web storage (widely compatible and simple)
	- Simply provides a key-value mapping.
	- Present implementations only support string-to-string mappings, so you need to serialize and de-serialize other data structures or binary data. You can do so using JSON.stringify() and JSON.parse().
	- 5MB Max.
	- localStorage and sessionStorage implements Storage interface.
2. WebSQL Database (Not maintained any more)
	- not maintained, IE, Firefox does not support.
	- Gives you all the power - and effort - of a structured SQL relational database.
3. IndexedDB ( not widely compatible )
	- Like Web Storage, it's a straightforward key-value mapping, but it supports indexes like those of relational databases, so searching objects matching a particular field is fast; you don't have to manually iterate through every object in the store.



**References**

- TR - <http://www.html5rocks.com/en/features/storage>
- TR - <http://www.html5rocks.com/en/tutorials/webdatabase/websql-indexeddb/>
- TR - <http://codular.com/localstorage>
