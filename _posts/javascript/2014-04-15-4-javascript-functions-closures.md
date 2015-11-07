---
title: Javascript Functions - Closures
author: NC
category: javascript
public: true
---

- What happens when we write:
```js
((x) => x)(2)
```
1. JavaScript parses it as an expression made up of several sub-expressions.
2. It then starts evaluating the expression.
3. First sub-expression,(x) => x evaluates to a function.
4. Second sub-expression, 2, evaluates to the number 2.
5. JavaScript now evaluates applying the function to the argument 2.
6. An environment is created.
```js
environment = { }
```
7. The value ‘2’ is bound to the name ‘x’ in the environment.
```js
environment= {x: 2, ...}
```
8. The expression ‘x’ (the right side of the function) is evaluated within the environment we just created.
9. The value of a variable when evaluated in an environment is the value bound to the variable’s name in that environment, which is ‘2’.
10. And that’s our result.



- Now lets think about what happens when we define a function within a function:
```js
((x) => (y) => x)(1)(2)
```
- The environment belonging to `(x) => ...` is `{x: 1, ...}`, and the result of applying the function is another function value.
- Now we have a value representing that function. Then we’re going to take the value of that function and apply the argument `2` to it:
```js
((y) => x)(2)
```
- Now we have a new environment `{y: 2, ...}`. How is the expression `x` going to be evaluated in that function’s environment? There is no `x` in its environment, it must come from somewhere else.
	- The variable x in this case is a **free variable** which means that it is not bound within the function. It is not an argument or a local variable.
	- Functions which do not contain any free variables are **pure functions**. We can expect the same result whenever we call them with the same arguments.
	- Functions which contain one or more free variables are **closures**. We may not directly infer what the closure does by just looking its definition.
	- Functions which does not have free variables but contain closures are also pure functions.
- Whenever a function is applied to arguments, its environment always has a reference to its parent environment at the time of its definition.
```js
environment for ((y) => x)(2) =
{
	y: 2,                // '.' : { y: 2 }
	'..': {x: 1, ...}    // parent
	'...': {...}         // grand-parent
	'....': {...}        // great grand-parent
	.
	.
	'......': {...}     // global environment
}.
```
- Now we can evaluate `((y) => x)(2)` in this environment.
- The variable `x` isn’t in `(y) => ...`’s immediate environment, but it is in its parent’s environment, so it evaluates to `1`.



- Closure is the mechanism for a language with functions as first class members to be useful. If functions could be passed around as values but could not remember their lexical scope, nobody would pass functions around.

- When you execute a function it creates a scope object, if there is anybody having a reference to the scope object via closure, that scope object is not garbage collected.

- Creating a closure via IIFE's to create copies of loop variables:
```js
for ( var i = 0; i < 5; i++) {
    setTimeout(function(){
        console.log(i);
    }, i * 1000);
}
// outputs: 5, 5, 5, 5, 5
// we need to create copy of i per iteration
for ( var i = 0; i < 5; i++) {
    (function(i) {
        setTimeout(function(){
            console.log(i);
        }, i * 1000);
    }(i));
}
// outputs: 0, 1, 2, 3, 4

// Note that if were to use let keyword instead of var for the i variable, according to the es6 spec, a new variable is allocated in each loop. Therefore the first version would work as requested with let keyword.
for ( let i = 0; i < 5; i++) {
    setTimeout(function(){
        console.log(i);
    }, i * 1000);
}
// outputs: 0, 1, 2, 3, 4

for ( var i = 0; i < 5; i++) {
    let j = i;   // block scoped
    setTimeout(function(){
        console.log(j);
    }, j * 1000);
}
// outputs: 0, 1, 2, 3, 4
```

#### Scope Chain

- Every chunk of Javascript code (global code or functions) has a **scope chain** associated with it.

#### Variable Resolution

- This scope chain is a chain of list of objects that defines the variables that are "in scope" for that code.
- When Javascript needs to look up the value of a variable `x` (a process called **variable resolution**),
	- It starts by looking at the first object in the chain.
	- If that object has a property named `x`, the value of that property is used.
	- If the first object does not have a property named `x`, Javascript continues the search with the next object in the chain.
	- If the second object does not have a property named `x`, the search moves on to the next object, and so on.
	- If `x` is not a property of any of the objects in the scope chain, then `x` is not in scope for that code, and a **ReferenceError** occurs.

#### Lexical Scope (Compile Time Scope or Static Scope or Closure)

- **Lexical scoping** means **functions are executed using the variable scope that was in effect when they were defined, not the variable scope that is in effect when they are invoked (calling context)**.
	- When resolving a variable in JavaScript it is looked up in the environment where they are declared allowing us to determine which declaration it belongs to by looking at the source code.
	- This is in contrast to dynamic scoping where the name resolution depends upon the program state when the name is encountered which is determined by the execution context or calling context.
	- In practice, with lexical scope a variable's definition is resolved by searching its containing block or function, then if that fails searching the outer containing block, and so on, whereas with dynamic scope the calling function is searched, then the function which called that calling function, and so on.
	- Lexical resolution can be determined at compile time and is also known as early binding, while dynamic resolution can only be determined at run time, and thus is known as late binding.

- Decisions about how all the scoping will occur are made at compiler's lexical phase.

- In order to implement lexical scoping, **the internal state of a Javascript function includes not only the code of the function but also a reference to the scope chain then in effect**.
- This combination of a function object and a scope in which the function’s variables are resolved is called a **closure**.
- Closures are created on **every** function definition at creation time.
- When that function is invoked, it creates a *new* execution context object to store its local variables, and adds that new object to the stored scope chain to create a new chain that represents the scope for that function invocation.
	- At definition time we have fn + scopeChain
	- At invocation time we have fn + [ currentContext , scopeChain ]
- **It is important to note that the scopeChain object references the variables and not their values. Therefore the values of the variables are resolved at invocation time**.

```js
function buildList(list) {
  var result = [];
  for (var i = 0; i < list.length; i++) {
  	var item = 'item' + list[i];
    result.push( function() {alert(item + ' ' + list[i])} );
  }
  return result;
}
function testList() {
  var fnlist = buildList([1,2,3]);
  // Using j only to help prevent confusion -- could use i.
  for (var j = 0; j < fnlist.length; j++) {
  	fnlist[j]();
  }
}
testList();



// item3 undefined
// item3 undefined
// item3 undefined
```


- Scope of an inner function contains the scope of a parent function even if the parent function has returned. But how does a function can execute a scope chain that does not exist any more?
	- Each time a Javascript function is invoked, a new object is created to hold the local variables for that invocation, and that object is added to the scope chain.
	- When the function returns, that variable binding object is removed from the scope chain.
	- If there were no nested functions, there are no more references to the binding object and it gets garbage collected.
	- If there were nested functions defined, then each of those functions has a reference to the scope chain, and that scope chain refers to the variable binding object.
	- If those nested functions objects remained within their outer function, then they themselves will be garbage collected, along with the variable binding object they referred to.
	- If the function defines a nested function and returns it or stores it into a property somewhere, then there will be an external reference to the nested function. It won’t be garbage collected, and the variable binding object it refers to won’t be garbage collected either.


- Closures become important when they are invoked under a different scope chain than the one that was in effect when they were defined.
	- Each time the outer function is called, the inner function is defined again.
	- Since the scope chain differs on each invocation of the outer function, the inner function will be subtly different each time it is defined.
	- The code of the inner function will be identical on each invocation of the outer function, but the scope chain associated with that code will be different.


- Closures reduce the need to pass state around the application. The inner function has access to the variables in the outer function so there is no need to store the state data at a global place that the inner function can get it.


- The name closure comes from the fact that inner scopes "enclose" outer scopes, having access to variables in them.
![](/img/javascript_closures.png)

#### Lazy instantiation

```js
var digit_name = (function(n) {
    var names = ['zero', 'one', 'two', 'three'];
    return function(n) {
        return names[i];
    }
}());
alert(digit_name(3));
```
- Above definition of `digit_name` function is immediately invoked event if the function is never called and the `names` array . Instead we could have rewrite it like this:

```js
var digit_name = function(n) {
    var names = ['zero', 'one', 'two', 'three'];
    digit_name = function(n) {
        return names[i];
    };
    return digit_name(n);
};
alert(digit_name(3));
```
- But this is not recommended for a couple of reasons:
    - The value of `digit_name` is changing during execution which causes confusion.
    - If this function is passed as parameter and called from there, the caller function does not see that the name changed and pays the cost of creating `name` array each time it invokes `digit_name` function. This breaks the first classness of `digit_name` function.
    - This is premature optimization.
- We could have avoided the above problem by:
```js
var digit_name = (function(n) {
    var names;
    return function(n) {
        if(!names) {
            names = ['zero', 'one', 'two', 'three'];
        }
        return names[i];
    };
}());
alert(digit_name(3));
```
- Still this is a tiny optimization and the source of problem is invoking it a million times which have other consequences and you wont notice the payoff here.


#### Making functions within a loop

- It is problematic because the function closes over the loop's variables, not to their current values:
```js
for(var i ...) {
    var div_id = divs[i].id;
    divs[i].onclick = function() {
        alert(div_id);
    }
}
```
- Instead
```js
var i;
function make_handler(div_id) {
    return function() {
        alert(div_id);
    }
}
for(, ...) {
    var div_id = divs[i].id;
    divs[i].onclick = make_handler(div_id);
}
```



**References**

- [JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
- [JavaScript Allongé, the "Six" Edition](https://leanpub.com/javascriptallongesix/read)
- <https://javascriptweblog.wordpress.com/2010/10/25/understanding-javascript-closures/>
- <http://stackoverflow.com/questions/111102/how-do-javascript-closures-work>
