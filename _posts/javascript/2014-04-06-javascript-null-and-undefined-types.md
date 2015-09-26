---
title: Javascript null and undefined Types
author: NC
category: javascript
public: true
---

### null
- `null` indicates the absence of a value.
- Using the `typeof` operator on `null` returns the string `"object"`, indicating that `null` can be thought of as a special object value that indicates "no object". ( I find this somewhat confusing as `null` is not an object type itself but rather a primitive (value) type.)
- In practice, `null` is typically regarded as the sole member of its own type, and it can be used to indicate "no value" for numbers and strings as well as objects.
- You might consider `null` to represent program-level, normal, or expected absence of value.


### undefined
- The undefined value represents a deeper kind of absence. It is:
	- the value of variables that have not been initialized.
	- the value of an object property or array element that does not exist.
	- the value returned by functions that have no return value.
	- the value of function parameters for which no argument is supplied.
- `undefined` is a predefined global variable (not a language keyword like `null`) that is initialized to the `undefined` value.
- If you apply the `typeof` operator to the `undefined` value, it returns “undefined”, indicating that this value is the sole member of a special type.
- You might consider `undefined` to represent a system-level, unexpected, or error-like absence of value.


---


- `null` and `undefined` both indicate an absence of value and can often be used interchangeably.
- The equality operator `==` considers them to be equal. (Use `===` to distinguish them.)
- Using `.` or `[]` to access a property or method of these values causes a **TypeError**.
- If you need to assign one of these values to a variable or property or pass one of these values to a function, `null` is almost always the right choice.

---

### Overriding `undefined`

- One of the unexpected behaviors of Javascript is that you can override the value of `undefined` **inside a function** (but not in the global scope):
```js
var undefined = 2; // 2
console.log(undefined == 2); // true
```
- That is one of the reasons why some libraries use the following syntax to avoid this problem within the library itself:
```js
(function(window, undefined) {
  ...
  // we are sure undefined is `undefined`.
  ...
})(window); // do not pass a second parameter so that `undefined` is passed as the second argument.
```


### void operator

- Another way to make sure to get the right `undefined` value is to use the `void` operator.
```js
void expression
```

- It evaluates the given expression and then returns `undefined`.
- When a browser follows a `javascript: URI`, it evaluates the code in the URI and then replaces the contents of the page with the returned value, unless the returned value is `undefined`. The `void` operator can be used to return `undefined`:
```js
<a href="javascript:void(0);">
  Click here to do nothing
</a>
```
	- Note, however, that the javascript: pseudo protocol is discouraged over other alternatives, such as unobtrusive event handlers.

- It can also be used to force the function keyword to be treated as an expression instead of a declaration in IIFEs:
```js
void function iife() {
	var bar = function () {};
	var baz = function () {};
	var foo = function () {
		bar();
		baz();
	};
	var biz = function () {};

	foo();
	biz();
}();
```

**References**

[JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
<https://developer.mozilla.org/tr/docs/Web/JavaScript/Reference/Operators/void>
