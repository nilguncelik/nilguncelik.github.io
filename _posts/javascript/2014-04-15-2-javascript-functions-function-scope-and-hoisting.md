---
title: Javascript Functions - Function Scope and Hoisting
author: NC
category: javascript
public: true
---


- **Function scope** means that any variable which is defined within a function is visible within that entire function.
- This is different from **block scope**, in which a variable scope is limited by the block a variable is declared in.
- Variables declared outside of a function are global variables and are visible everywhere in a Javascript program.

- In JavaScript, variables declared inside a function have function scope and are visible everywhere inside that function including any functions nested within that function.
- This effect is accomplished by **variable hoisting**:
	- All variable declarations in a function (*but not any associated assignments*) are hoisted to the top of the function.
	- This causes variables to be visible even before they are declared.

```js
// Function Scope
function test(o) {
	var i = 0;                         // i is defined throughout the body of the function
	if (typeof o == "object") {
		var j = 0;                     // j is defined throughout the body of the function, not just block
		for(var k = 0; k < 10; k++)    // k is defined throughout the body of the function, not just loop
			console.log(k);            // print numbers 0 through 9
		}
		console.log(k);                // k is still defined: prints 10
	}
	console.log(j);                    // j is defined, but may not be initialized
}

//Hoisting
var scope = "global";
function f() {
	console.log(scope);      // Prints "undefined", not "global"
	var scope = "local";     // Variable initialized here, but defined everywhere
	console.log(scope);      // Prints "local"
}
```

- The `var` statement gets split into two parts:
    - The declaration part gets hoisted to the top of the function initializing with undefined.
    - The initialization part turns into an ordinary statement.

- Since Javascript does not have block scope, some programmers make a point of declaring all their variables at the top of the function, rather than trying to declare them closer to the point at which they are used. This technique makes their source code accurately reflect the true scope of the variables. This style also suggested by Douglas Crockford.
- There is one exception to function scope :
	- The identifiers associated with a catch clause has block scope - they are only defined within the catch block.

- The `let`/`const`/`class` statements in ES6 have block scopes. Their declerations are hoisted to the top but is not initialized with `undefined`. Therefore it is an error if you try to use them before the point they are declared.


**References**

- [JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
