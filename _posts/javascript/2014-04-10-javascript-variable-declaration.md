---
title: Javascript Variable Declaration
author: NC
category: javascript
public: true
---


- If you read the value of an undeclared variable; Javascript generates an error.
- If you assign a value to an undeclared variable;
	- In ES5 strict mode, Javascript generates an error.
	- In non-strict mode, Javascript creates that variable as a property of the global object, and it works much like (but not exactly the same as) a properly declared global variable.


- Initializing multiple variable in a one liner:
```js
var a = b = 0;
// works similar to:
b = 0;
var a = b;
// not similar to:
var a = 0, b = 0;
```


### Comma operator

- It evaluates each of its operands (from left to right) and returns the value of the last operand.

```js
var i = a += 2, a + b;
```

- It is commonly used with a for loop that has multiple loop variables.
- Js minifiers use it to minify the code.



### Single var pattern

```js
function myfunction() {
    var  a = 1,
        b = 'Hello',
        c = { name: 'Jake', age: 64 },
        d = new Date(),
        e;
}

// is equal to

function myfunction() {
    var a = 1;
    var b = 'Hello';
    var c = { name: 'John', age: 64 };
    var d = new Date();
    var e;
}
```

- There are arguments for and against this pattern. Some of them are as follows:
    - If using single var pattern, put each variable and its comments on its own line.
    - If you forget a comma while using single var pattern, the next variable will be defined globally.
        - You can put a defensive comma before each line instead of putting commas at the end of the lines.
    - Multi-line expressions are not readable with single var pattern.
    - Long comments are also not readable with single var pattern.
    - Single var pattern is used by Js minifiers to minify the code. So you dont need to do it yourself.
    - No matter which one you are using declare all your variables at the top of your function to avoid logical errors that can be introduced by variable hoisting.

- Another path you can take is to use single var pattern for variable declarations, and multi var pattern for variable definitions:
```js
var foo, bar, baz;
var abc = 1;
var def = 2;
```


**References**

[JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
