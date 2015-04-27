---
title: Javascript Global Object
author: NC
category: javascript
public: true
---


- When the Javascript interpreter starts (or whenever a web browser loads a new page), it creates a new global object and gives it an initial set of properties that define:
	- global properties like `undefined`, `Infinity`, and `NaN`.
	- global functions like `isNaN()`, `parseInt()`, and `eval()`.
	- constructor functions like `Date()`, `RegExp()`, `String()`, `Object()`, and `Array()`.
	- global objects like `Math` and `JSON`.
- It also holds program-defined globals as well. If your code declares a global variable, that variable is a property of the global object.
- In Javascript code, that is not part of any function, you can use `this` keyword to refer to the global object:

```js
// Define a global variable to refer to the global object
var global = this;
```

- In client-side Javascript, the "window" object serves as the global object. This global "window" object has a self-referential `window` property that can be used instead of `this` to refer to the global object.

**References**

[JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
