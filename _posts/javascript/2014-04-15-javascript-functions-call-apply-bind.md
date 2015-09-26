---
title: Javascript Functions - Call, Apply, Bind
author: NC
category: javascript
public: true
---


#### Currying and Partial Application

- **Currying** is the technique of translating the evaluation of a function that takes multiple arguments into evaluating a sequence of functions, each with a single argument:

```js
(x, y, z) => x + y + z

//can be curried as

(x) =>
   (y) =>
     (z) => x + y + z
```

- Calling a curried function with only some of its arguments is called **partial application**.

```
((x) =>
   (y) =>
     (z) => x + y + z)(1)
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
- It is also used for partial application in functional programming:

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


#### Note on True functions vs callable objects

- Javascript makes a subtle distinction between functions and *callable objects*. All functions are callable, but it is possible to have a callable object - that can be invoked just like a function - that is not a true function.
- Most browser vendors use native Javascript function objects for the methods of their host objects. Microsoft, however, has always used non-native callable objects for their client-side methods, and before IE 9 the typeof operator returns "object" for them, even though they behave like functions. In IE9 these client-side methods are now true native function objects.
- The ES3 spec says that the `typeof` operator returns "function" for all native objects that are callable. The ES5 specification extends this to require that `typeof` return "function" for all callable objects, whether native objects or host objects.

```js
function isTrueFunction(x) {
     return Object.prototype.toString.call(x) === "[object Function]";
}
```


**References**

- [JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
- [JavaScript Allongé, the "Six" Edition](https://leanpub.com/javascriptallongesix/read)
