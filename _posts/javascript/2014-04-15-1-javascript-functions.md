---
title: Javascript Functions
author: NC
category: javascript
public: true
---

- Functions represent computations to be performed.

```js
function(x) { return x + 1; }
(x) => x + 1
(x) => { return x + 1; }
```

- An example of applying functions to arguments (i.e. function invocation):

```js
fn_expr(arguments)  // fn_expr is an expression that when evaluated, produces a function.
(function(x) { return x + 1; })(1);
((x) => x + 1)(1);
```

- Invoking Functions

Javascript functions can be invoked in 4 ways which can differ in their handling of **arguments**, **invocation context (this)**, and **return value**.

1- As functions
- Invocation context is either the global object (ES3 and non-strict ES5) or `undefined` (strict mode);

2- As methods
- If the function is the property of an object or an element of an array - then it is a method invocation.
- Invocation context is the object on which the method is invoked.

3- As constructors
- if a constructor has no parameters, you can omit the pair of empty parentheses.
- It creates a new, empty object that inherits from the prototype property of the constructor.
- They do not normally use the return keyword and return implicitly when they reach the end of their body.
- In this case, the new object is the value of the invocation expression.
- If a constructor explicitly used the return statement to return an object,
	- then that object becomes the value of the invocation expression.
	- If the constructor uses return with no value, or if it returns a primitive value,
		- that return value is ignored and the new object is used as the value of the invocation.

4- Indirectly through their call or apply methods.
- Since functions are objects they can have methods it-selves.
- These methods allow you to explicitly specify the invocation context.



**References**

- [JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
- [JavaScript Allongé, the "Six" Edition](https://leanpub.com/javascriptallongesix/read)
