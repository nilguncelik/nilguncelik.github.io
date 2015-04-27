---
title: Javascript Delete Operator
author: NC
category: javascript
public: true
---

- `delete` operator attempts to delete the object property or array element specified as its operand.
- It returns `true` if it successfully deletes the specified lvalue.
- It expects its operand to be an *lvalue*.
  - If it is not an lvalue, the operator takes no action and returns `true`.
  - Otherwise, it attempts to delete the specified lvalue.
  - All properties can be deleted, except the following:
      - Some built-in core and client-side properties.
      - User-defined variables declared with the `var` statement.
      - Functions defined with the function statement.
      - Declared function parameters.
- If its operand is an unqualified identifier such as a variable, function, or function parameter:
  - In ES5 strict mode: it raises a **SyntaxError** (it only works when the operand is a property access expression.)
  - Outside of strict mode, no exception occurs and delete simply returns `false` to indicate that the operand could not be deleted.
- If its operand is a non-configurable property (Certain properties of built-in objects are non-configurable, as are properties of the global object created by variable declaration and function declaration):
  - In ES5 strict mode: it raises a **TypeError**.
  - Outside of strict mode, no exception occurs and delete simply returns `false` to indicate that the operand could not be deleted.
- It only deletes own properties, not inherited ones.
  - To delete an inherited property, you must delete it from the prototype object in which it is defined.
  - Doing this affects every object that inherits from that prototype.
- Note that the `delete` keyword in Javascript is nothing like the `delete` keyword in C++. In Javascript, memory deallocation is handled automatically by garbage collection, and you never have to worry about explicitly freeing up memory. Thus, there is no need for a C++- style `delete` to delete entire objects.

```js
var a = [1,2,3];
delete a[2];     // Delete the last element of the array
a.length         // => 2: array only has two elements now
```

```js
var o = {x:1, y:2};
delete o.x;      // Delete one of the object properties; returns true
"x" in o         // => false: the property does not exist anymore
typeof o.x;      // Property does not exist; returns "undefined"
delete o.x;      // Delete a nonexistent property; returns true
delete o;        // Can't delete a declared variable; returns false.
                 // Would raise an exception in strict mode.
```

```js
delete 1;        // Argument is not an lvalue: returns true
this.x = 1;      // Define a property of the a global object without var
delete x;        // Try to delete it: returns true in non-strict mode
                 // SyntaxError in strict mode. Use 'delete this.x' instead
x;               // Runtime error: x is not defined
```

```js
var truevar = 1;      // A properly declared global variable, nondeletable.
fakevar = 2;          // Creates a deletable property of the global object.
this.fakevar2 = 3;    // Creates a deletable property of the global object.
delete truevar        // => false: variable not deleted
delete fakevar        // => true: variable deleted
delete this.fakevar2  // => true: variable deleted
```

```js
delete Object.prototype;  // Can't delete; property is non-configurable
var x = 1;                // Declare a global variable
delete this.x;            // Can't delete this property
function f() {}           // Declare a global function
delete this.f;            // Can't delete this property either
```

**References**

[JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
