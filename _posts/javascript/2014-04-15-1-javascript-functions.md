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

#### Invoking Functions

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

#### this (invocation context)

- It contains a reference to the object of invocation.
- It is one of the big code reuse ideas in javascript. We can have a single inherited function which can work on many objects and the way that function knowns which object this can be working on by **this** binding.

- `this` keyword looks more alike to dynamic scoping model.
- Every function, while executing, has a reference to its current execution context, called this.
- In order to identify the execution context you have to go to the calling side ask these questions in order:
    - Is the function called with `new` operator?
        - then a new empty object is the value of `this` keyword.
    - Is the functions hard-binded before using `bind` method or alike?
        - then
    - Is the function called with `call` or `apply`?
        - then first argument is the context object.
    - Is the function call a method invocation?
        - then `this` keyword gets the value of the object that the method is invoked on.
    - Is it a normal function call?
        - default binding rule applies. i.e.
        - In strict mode, `this` keyword defaults to `undefined` value.
        - In unstrict mode, `this` keyword defaults to global object.

- Many times, programmers create a controller class and define controller functions in this class. This works pretty when the functions are called as method invocations. But sometimes the programmers try to pass `controller.function` as a callback function to an ajax call or a button click callback to find out that value of `this` has changed and their code is now broken. For these cases, you can use `bind` method to hard bind the context object.
    - Because of this problem, some programmers never use `new` and `this` keywords in their programs.
    - Instead they use **factory functions**.
    ```js
    class Dog() {
        constructor() {
            this.sound = 'woof';
        }
        talk() {
            console.log(this.sound);
        }
    }
    const sniffles = new Dog();
    sniffles.talk();    // woof

    $('button.myButton').click( sniffles.talk );   // this is now button object
    $('button.myButton').click( sniffles.talk.bind(sniffles) ); // very ugly
    $('button.myButton').click( _ => sniffles.talk() );   // better

    // alternatively

    const dog = () => {
        const sound => 'woof';
        return {
            talk: ()=> console.log(sound);
        }
    }
    const sniffles = dog();
    sniffles.talk();  // woof
    $('button.myButton').click( sniffles.talk );   // woof
    ```
    - One drawback with this approach is that closures are less performant than classes. So if you need to create a lot of (thousands) of objects, classes will be more performant.

- When a property is not found on the context object, it is searched in the prototype chain of the context object which goes up to `Object.prototype`. Note that this mechanism is orthogonal to lexical scoping where variable resolution chain goes up to the global or window object.


**References**

- [JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
- [JavaScript Allongé, the "Six" Edition](https://leanpub.com/javascriptallongesix/read)
