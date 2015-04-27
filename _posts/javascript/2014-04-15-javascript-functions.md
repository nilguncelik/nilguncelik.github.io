---
title: Javascript Functions
author: NC
category: javascript
public: true
---


#### Function Definition Expression
```js
function(x) { return x+1; }
```

- Creates a new function object.
- Does not declare any variable, creates only the function object.
- Uses:
	- Assignment: `var x = function(x) { return x+1; }`
		- Only the variable declaration is hoisted. But assignments to those variables are not hoisted. The variable initialization code remains where you placed it.
		- Value of `x` is `undefined` until its declaration.
	- Invocation: `func(function(x) { return x+1; });`
- If a function definition expression includes a name, the local function scope for that function will include a binding of that name to the function object.  `var f = function fact(x) { if (x <= 1) return 1; else return x*fact(x-1); };`
	- In effect, the function name becomes a local variable within the function.
	- Useful for recursion.


#### Function Declaration Statement
```js
function f(x) { return x+1; }
```

- Creates a new function object.
- Declares the function name as a variable and assigns the newly created function object to it.
- Both the function name and the function body are hoisted.
	- All functions in a script or all nested functions in a function are declared before any other code is run. They are visible throughout the script or function.
	- This means that you can invoke a Javascript function before you declare it.
- It creates variables that cannot be deleted. But they are not read-only and their value can be overwritten.
- It can appear in global code, or within other functions, but it cannot appear inside of loops, conditionals, or try/catch/finally or with statements.

#### Invoking Functions

- Javascript functions can be invoked in four ways which can differ in their handling of arguments, invocation context, and return value.
	- as functions
		- Invocation context is either the global object (ES3 and non-strict ES5) or `undefined` (strict mode);
	- as methods
		- if the function is the property of an object or an element of an array -then it is a method invocation.
		- Invocation context is the object on which the method is invoked.
  - as constructors
		- if a constructor has no parameters, you can omit the pair of empty parentheses.
		- It creates a new, empty object that inherits from the prototype property of the constructor.
		- They do not normally use the return keyword and return implicitly when they reach the end of their body.
		- In this case, the new object is the value of the invocation expression.
		- If a constructor explicitly used the return statement to return an object,
			- then that object becomes the value of the invocation expression.
			- If the constructor uses return with no value, or if it returns a primitive value,
				- that return value is ignored and the new object is used as the value of the invocation.
	- indirectly through their call or apply methods.
		- Since functions are objects they can have methods it-selves.
		- These methods allow you to explicitly specify the invocation context.
- Javascript invokes functions by passing-by-value very similar to Java;
	- Javascript is always pass by value, but when a variable refers to an object (including arrays), the "value" is a reference to the object.
	- Changing the value of a variable never changes the underlying primitive or object, it just points the variable to a new primitive or object.
	- Changing a property of an object referenced by a variable does change the underlying object.

#### The Arguments object

- Within the body of a function, the identifier `arguments` refers to the Arguments object for that invocation.
- It can be used to write functions that can operate on any number of arguments or to directly refer to unnamed argument values.
- `f(a,b,c)`
	- In non-strict mode, `arguments[0]` and `a` are like two different names for the same variable.
	- In strict mode, `arguments[0]` and `a` could refer initially to the same value, but a change to one would have no effect on the other.
- In non-strict mode, `arguments` is just an identifier.
	- In strict mode, it is a reserved word. Functions cannot use arguments as a parameter name or as a local variable name. They cannot assign values to `arguments`.
- It is an array-like object. You can use `Array.prototype.slice.call` to convert arguments object into an true Array:
	- `Array.prototype.slice.call(arguments)`
- The Arguments object also defines 2 properties : `callee` and `caller`
- `callee` property refers to the currently running function. It allows unnamed functions to call themselves recursively.
- `caller` is a nonstandard property that refers to the function that called this one. It gives access to the call stack.
- In ES5 strict mode, these properties raise a **TypeError** if you try to read or write them.

#### Defining function properties

- When a function needs a *static variable* whose value persists across invocations, it is often convenient to use a property of the function, instead of cluttering up the namespace by defining a global variable.
- Suppose you want to write a function that returns a unique integer whenever it is invoked. The function must never return the same value twice:

```js
uniqueInteger.counter = 0;
function uniqueInteger() {
    return uniqueInteger.counter++;
}
```
- Note that this implementation creates a public property on the `uniqueInteger` function.
- This can cause buggy or malicious code to reset the counter or set it to a non-integer, causing the function to violate the "unique" or the "integer" part of its contract.
- You can use closures to make counter a private variable.

#### Function Scope and Hoisting

- **Function scope** means that any variable which is defined within a function is visible within that entire function.
- This is different from **block scope**, in which a variable scope is limited by the block a variable is declared in.
- Variables declared outside of a function are global variables and are visible everywhere in a Javascript program.
- Variables declared inside a function have function scope and are visible everywhere inside that function including any functions nested within that function.
- This effect is accomplished by "variable hoisting":
	- All variable declarations in a function (*but not any associated assignments*) are hoisted to the top of the function.
	- This causes variables to be visible even before they are declared.

```js
// Function Scope
function test(o) {
     var i = 0;                          // i is defined throughout the body of the function
     if (typeof o == "object") {
          var j = 0;                     // j is defined throughout the body of the function, not just block
          for(var k = 0; k < 10; k++)    // k is defined throughout the body of the function, not just loop
               console.log(k);           // print numbers 0 through 9
          }
          console.log(k);                // k is still defined: prints 10
     }
     console.log(j);                     // j is defined, but may not be initialized
}

//Hoisting
var scope = "global";
function f() {
     console.log(scope);      // Prints "undefined", not "global"
     var scope = "local";     // Variable initialized here, but defined everywhere
     console.log(scope);      // Prints "local"
}
```

- Since Javascript does not have block scope, some programmers make a point of declaring all their variables at the top of the function, rather than trying to declare them closer to the point at which they are used. This technique makes their source code accurately reflect the true scope of the variables.
- There is one exception to function scope :
	- The identifiers associated with a catch clause has block scope - they are only defined within the catch block.

#### Scope Chain, Variable resolution and Lexical Scope (Static Scope or Closure) :

- Every chunk of Javascript code (global code or functions) has a scope chain associated with it.
- This scope chain is a chain of list of objects that defines the variables that are "in scope" for that code.
- When Javascript needs to look up the value of a variable `x` (a process called **variable resolution**),
	- It starts by looking at the first object in the chain.
	- If that object has a property named `x`, the value of that property is used.
	- If the first object does not have a property named `x`, Javascript continues the search with the next object in the chain.
	- If the second object does not have a property named `x`, the search moves on to the next object, and so on.
	- If `x` is not a property of any of the objects in the scope chain, then `x` is not in scope for that code, and a **ReferenceError** occurs.
- **Lexical scoping** means *functions are executed using the variable scope that was in effect when they were defined, not the variable scope that is in effect when they are invoked*.
	- In order to implement lexical scoping, the internal state of a Javascript function includes not only the code of the function but also a 				reference to the scope chain then in effect.
	- This combination of a function object and a scope (a set of variable bindings: copies of primitives and references to objects) in which the function’s variables are resolved is called a **closure**.
	- When that function is invoked, it creates a new execution context object to store its local variables, and adds that new object to the stored scope chain to create a new chain that represents the scope for that function invocation.
- Closures become important when they are invoked under a different scope chain than the one that was in effect when they were defined.
	- Each time the outer function is called, the inner function is defined again.
	- Since the scope chain differs on each invocation of the outer function, the inner function will be subtly different each time it is defined.
	- The code of the inner function will be identical on each invocation of the outer function, but the scope chain associated with that code will be different.
- Closures reduce the need to pass state around the application. The inner function has access to the variables in the outer function so there is no need to store the state data at a global place that the inner function can get it.
- Scope of an inner function contains the scope of a parent function even if the parent function has returned.
	- How does a function can execute a scope chain that does not exist any more?
	- The scope chain is a list of objects, not a stack of bindings.
	- Each time a Javascript function is invoked, a new object is created to hold the local variables for that invocation, and that object is added to the scope chain.
	- When the function returns, that variable binding object is removed from the scope chain.
	- If there were no nested functions, there are no more references to the binding object and it gets garbage collected.
	- If there were nested functions defined, then each of those functions has a reference to the scope chain, and that scope chain refers to the variable binding object.
	- If those nested functions objects remained within their outer function, then they themselves will be garbage collected, along with the variable binding object they referred to.
	- If the function defines a nested function and returns it or stores it into a property somewhere, then there will be an external reference to the nested function. It won’t be garbage collected, and the variable binding object it refers to won’t be garbage collected either.

#### Immediately Invoked Function Expressions and Namespaces
- If you want to create a Javascript module you dont know whether the variables it creates will conflict with variables used by the programs that import it.
- The solution is to put the code into a function and then invoke the function. This way, variables that would have been global become local to the function.
- This technique can be used to
	- protect against polluting the global environment
	- simultaneously allow public access to methods while retaining privacy for variables defined within the function.
	- avoid variable hoisting from within blocks

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

#### Call() and Apply() Methods

- `f.call(o, 1, 2);`
	- calls `f` passing variable `o` as the invocation context and `1`,`2` as the arguments.
- `f.apply(o, [1,2]);`
	- calls `f` passing variable `o` as the invocation context and `1`,`2` as the arguments.

#### Bind() Method (ES5)

```js
var bindArguments = (
    !!Function.prototype.bind
) ?
function(context,delegate) {
    return delegate.bind(context,
        Array.prototype.slice.call(arguments).splice(2)
    );
} :
function(context,delegate) {
    var slice =Array.prototype.slice,
         args =slice.call(arguments).splice(2);
    return function() {
        returndelegate.apply(context,args.concat(slice.call(arguments)));
    };
};
```

- It returns a new function.
- Invoking the new function invokes the original function as a method of context.
- It is also used for partial application (**currying**) in functional programming:

```js
var sum = function(x,y) { return x + y };
var succ = sum.bind(null, 1);
succ(2)                                  // => 3
```

```js
function f(y,z) { return this.x + y + z };
var g = f.bind({x:1}, 2);
g(3)                                     // => 6:
```


#### True functions vs callable objects
- Javascript makes a subtle distinction between functions and *callable objects*. All functions are callable, but it is possible to have a callable object - that can be invoked just like a function - that is not a true function.
- Most browser vendors use native Javascript function objects for the methods of their host objects. Microsoft, however, has always used non-native callable objects for their client-side methods, and before IE 9 the typeof operator returns "object" for them, even though they behave like functions. In IE9 these client-side methods are now true native function objects.
- The ES3 spec says that the `typeof` operator returns "function" for all native objects that are callable. The ES5 specification extends this to require that `typeof` return "function" for all callable objects, whether native objects or host objects.

```js
function isTrueFunction(x) {
     return Object.prototype.toString.call(x) === "[object Function]";
}
```


**References**

- <http://stackoverflow.com/questions/6605640/javascript-by-reference-vs-by-value/>
- [JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
