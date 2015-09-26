---
title: Javascript Functions - The Arguments object
author: NC
category: javascript
public: true
---

- Within the body of a function, the identifier `arguments` refers to the Arguments object for that invocation.


- It can be used to write functions that can operate on any number of arguments or to directly refer to unnamed argument values.


- `f(a,b,c)`
	- In non-strict mode, `arguments[0]` and `a` are like two different names for the same variable.
	- In strict mode, `arguments[0]` and `a` could refer initially to the same value, but a change to one would have no effect on the other.


- In non-strict mode, `arguments` is just an identifier.
	- In strict mode, it is a reserved word. Functions cannot use arguments as a parameter name or as a local variable name. They cannot assign values to `arguments`.


- It is an array-like object. i.e. Although it looks like an array, it isn’t an array: It’s more like an object that happens to bind some values to properties with names that look like integers starting with zero.
	- You can use `Array.prototype.slice.call` to convert arguments object into an true Array: `Array.prototype.slice.call(arguments)`


- The Arguments object also defines 2 properties : `callee` and `caller`
	- `callee` property refers to the currently running function. It allows unnamed functions to call themselves recursively.
	- `caller` is a nonstandard property that refers to the function that called this one. It gives access to the call stack.
	- In ES5 strict mode, these properties raise a **TypeError** if you try to read or write them.

**References**

- [JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
