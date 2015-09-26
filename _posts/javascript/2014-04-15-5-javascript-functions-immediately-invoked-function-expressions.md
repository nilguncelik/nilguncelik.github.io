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

- Note that the wrapping curly braces around function definition is not mandatory. If you are not using arrow functions, you can also immediately invoke a function without wrapping it in curly braces, but it makes your code hard to read:
```js
var sum = function add(num1, num2){
  return num1 + num2;
}(1, 2);
console.log(sum)
	//=> 3
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
