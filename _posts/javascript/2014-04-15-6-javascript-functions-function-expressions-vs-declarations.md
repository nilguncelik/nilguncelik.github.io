---
title: Javascript Functions - Function Expressions vs Declarations
author: NC
category: javascript
public: true
---

#### Function (Definition) Expressions


```js
function(x) { return x + 1; }
```

- Creates a new function object.
- Does not declare any variable, creates only the function object.
- It can be used for:
	- Assignment: `var x = function(x) { return x+1; }`
	- Invocation: `func(function(x) { return x+1; });`


#### Naming Function (Definition) Expressions


- When we write
```js
var repeat = (str) => str + str
```

- We don't name the function as `repeat` for the same reason that `var answer = 42` doesn’t name the number `42`. It binds an anonymous function to a name in an environment, but the function itself remains anonymous.

- To name a function expressions, we insert a variable between the function keyword and parameters:

```js

// bindingName is hoisted to the top of function or global scope and
// its value is `undefined` until it is initialized with the following function definition expression.

var bindingName = function actualName () {
  //... actualName is only defined here and can be used for recursion.
  //... bindingName is also defined here but it can be overridden later in code or even be shadowed in this function, therefore it is not reliable.
};

bindingName
  //=> [Function: actualName]

actualName
  //=> ReferenceError: actualName is not defined

bindingName.name
	//=> actualName   // actualName is assigned to name property of bindingName.
```

- There is no named form of arrow functions.

- It is strongly advised to always name your function expressions i.e. do not use anonymous functions for 3 reasons:
    - The name provides a way to refer to yourself.
        - e.g. for recursion or unbinding from an event handler.
     - The name shows up in debug stack traces instead of the name `anonymous function`.
     - The name self documents the code.
- Even when you are assigning a function to a property of an object, you should name the function expression.
#### Function Declaration (Statement)

- Function declaration statements are a lot like function definitions. They differ in that with function declarations the statement always starts with `function` keyword.

```js
function someName(x) {
	//...
}

// this behaves like

var someName = function someName(x) {
	//...
}
```

- It creates a new function object.
- Then declares the function name as a variable and assigns the newly created function object to it.
- Both the function name and the function body are hoisted.
	- All functions in a script or all nested functions in a function are declared before any other code is run. They are visible throughout the script or function.
	- This means that you can invoke a Javascript function before you declare it.

```js
(function () {
  return fizzbuzz();

  const fizzbuzz = function fizzbuzz () {
    return "Fizz" + "Buzz";
  }
})()
//=> undefined is not a function (evaluating 'fizzbuzz()')


(function () {
  return fizzbuzz();

  function fizzbuzz () {
    return "Fizz" + "Buzz";
  }
})()
  //=> 'FizzBuzz'
```

- It creates variables that cannot be deleted. But they are not read-only and their value can be overwritten.

- It can appear in global code, or within other functions, but it cannot appear inside of loops, conditionals (if blocks), or try/catch/finally or with statements. They also cannot exist inside of any expression. Otherwise javascript raises an error.

- It does not need to be followed with a semicolon.

**References**

- [JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
- [JavaScript Allongé, the "Six" Edition](https://leanpub.com/javascriptallongesix/read)
- <http://www.bryanbraun.com/2014/11/27/every-possible-way-to-define-a-javascript-function>
- TR - <http://kangax.github.io/nfe/>
