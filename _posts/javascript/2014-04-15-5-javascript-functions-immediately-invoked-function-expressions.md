---
title: Javascript Functions - IIFEs
author: NC
category: javascript
public: true
---

#### Immediately Invoked Function Expressions


- Assume you want to create a Javascript module and that module has a function named 'isNumber'.
- You would not want to create this function in the global environment as that would conflict with other definitions by the programs that import it:
```js
{
	isNumber: [Function],
	.
	.
	. // other variables in global environment shared with others
}
```
- The solution is to put the code into a function and then invoke the function. This way, variables that would have been global become local to the function.

```js
(() => {

  // ... lots of JavaScript ...

})();
```
- This inserts a new empty environment in between the global environment and your own functions:
```js
{
	isNumber: [Function],
	'..': {'..': global environment}
}
```

- This technique can be used to
	- Protect against polluting the global environment
	- Simultaneously allow public access to methods while retaining privacy for variables defined within the function.
	- Avoid variable hoisting from within blocks

#### Parenthesis

- Wrapping your IIFE's in parenthesis is mandatory for some cases where it causes ambiguity for the JavaScript parser.

- But it is still a good idea to use the parenthesis for better code readability. The parens typically indicate that the function expression will be immediately invoked, and the variable will contain the result of the function, not the function itself. This can save someone reading your code the trouble of having to scroll down to the bottom of what might be a very long function expression to see if it has been invoked or not.

```js
// Either of the following two patterns can be used to immediately invoke
// a function expression

(function(){ /* code */ }()); // Crockford recommends this one
(function(){ /* code */ })(); // But this one works just as well
```

Because the point of the parens or coercing operators is

- It is mandatory to use parens to disambiguate between function expressions and function declarations. If you are to specify a name for the IIFE function you should use parens to prevent the parser throwing a SyntaxError. This is due to the following rules:
    - Parens placed after an expression indicate that the expression is a function to be invoked.
    - Parens placed after a statement are separate from the preceding statement. They are a grouping operator used as a means to control precedence of evaluation.
- Therefore if you create a statement by specifying a name for the IIFE function, the parens will be interpreted as grouping operator; causing a SyntaxError:
```js
// While this function declaration is now syntactically valid, it's still
// a statement, and the following set of parens is invalid because the
// grouping operator needs to contain an expression.

function foo(){ /* code */ }(); // SyntaxError: Unexpected token )

// Now, if you put an expression in the parens, no exception is thrown...
// but the function isn't executed either, because this:

function foo(){ /* code */ }( 1 );

// Is really just equivalent to this, a function declaration followed by a
// completely unrelated expression:

function foo(){ /* code */ }

( 1 );
```

- The parens can be omitted when the parser already expects an expression ( although not recommended ):

```js
var i = function(){ return 10; }();
true && function(){ /* code */ }();
0, function(){ /* code */ }();
```

#### Namespaces

```js
(function (myNamespace) {

	//Private Variable
	var helloWorldMessage = "Hello Javascript";

	//Private Function
	var sayHi = function () {

	  console.log(helloWorldMessage);

	};

	//Public Function
	myNamespace.helloWorld = function () {

	  //call our private method
	  //Prints "Hello Javascript" to the console
	  sayHi();
	};

} (myNamespace = window.myNamespace || {}));
```

**References**

- [JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
- [JavaScript Allongé, the "Six" Edition](https://leanpub.com/javascriptallongesix/read)
- <http://benalman.com/news/2010/11/immediately-invoked-function-expression/>
