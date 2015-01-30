---
title: Javascript Strict Mode
author: NC
category: javascript
public: true
---


- The strict mode of ES5:
    - fixes a few important language deficiencies
    - provides stronger error checking and increased security.
- In strict mode:
  - ```with``` statement is not allowed.
  - All variables must be declared:
      - If you assign a value to an identifier that is not a declared variable, function, function parameter, catch clause parameter, or property of the global object, a **ReferenceError** is thrown.
      - In non-strict mode, this implicitly declares a global variable by adding a new property to the global object.
  - Functions invoked as functions (rather than as methods) have a ```this``` value of ```undefined```.
      - In non-strict mode, functions invoked as functions are always passed the global object as their this value.
      - This difference can be used to determine whether an implementation supports strict mode:
          - ```var hasStrictMode = (function() { "use strict"; return this===undefined}());```
  - When a function is invoked with ```call()``` or ```apply()```, the ```this``` value is exactly the value passed as the first argument to ```call()``` or ```apply()```.
      - In non-strict mode, ```null``` and ```undefined``` values are replaced with the global object and non-object values are converted to objects.
  - Assignments to non-writable properties and attempts to create new properties on nonextensible objects throw a **TypeError**.
      - In non-strict mode, these attempts fail silently.
  - Code passed to ```eval()``` cannot declare variables or define functions in the caller’s scope as it can in non-strict mode. Instead, variable and function definitions live in a new scope created for the ```eval()```. This scope is discarded when ```eval()``` returns.
  - The ```arguments``` object in a function holds a static copy of the values passed to the function.
      - In non-strict mode, the arguments object has "magical" behavior in which elements of the array and named function parameters both refer to the same value.
  - If the ```delete``` operator is followed by an unqualified identifier such as a variable, function, or function parameter, **SyntaxError** is thrown.
      - In non-strict mode, such a delete expression does nothing and evaluates to false.
  - An attempt to delete a non-configurable property throws a **TypeError**.
      - In non-strict mode, the attempt fails and the delete expression evaluates to false.
  - It is a syntax error for an object literal to define two or more properties by the same name.
      - In non-strict mode, no error occurs.
  - It is a syntax error for a function declaration to have two or more parameters with the same name.
      - In non-strict mode, no error occurs.
  - Octal integer literals (beginning with a 0 that is not followed by an x) are not allowed.
      - In non-strict mode, some implementations allow octal literals.
  - The identifiers ```eval``` and ```arguments``` are treated like keywords, and you are not allowed to change their value. You cannot assign a value to these identifiers, declare them as variables, use them as function names, use them as function parameter names, or use them as the identifier of a catch block.
  - The ability to examine the call stack is restricted. ```arguments.caller``` and ```arguments.callee``` both throw a **TypeError** within a strict mode function. Strict mode functions also have ```caller``` and ```arguments``` properties that throw **TypeError** when read.
      - Some implementations define these nonstandard properties on non-strict functions.


**References**

[JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
