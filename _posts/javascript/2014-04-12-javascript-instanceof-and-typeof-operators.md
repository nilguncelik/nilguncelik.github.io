---
title: Javascript instanceof and typeof operators
author: NC
category: javascript
public: true
---

#### object instanceof class
- Evaluates to ```true``` if object is an instance of the class.
- In Javascript, classes of objects are defined by the constructor function that initializes them. Thus, the right-side operand of ```instanceof``` should be a function.
- If the left-side operand of ```instanceof``` is not an object, instance of returns ```false```.
- If the right-hand side is not a function, it throws a **TypeError**.

```
var d = new Date();
d instanceof Date;     // true; d was created with Date()
d instanceof Object;   // true; all objects are instances of Object
d instanceof Number;   // false; d is not a Number object
```

```
var a = [1, 2, 3];
a instanceof Array;    // true; a is an array
a instanceof Object;   // true; all arrays are objects
a instanceof RegExp;   // false; arrays are not regular expressions
```

#### typeof Operator
- Evaluates to a string that specifies the type of the operand.

```
  x => typeof x
  undefined => "undefined"
  null => "object"
  true/false => "boolean"
  any number / NaN => "number"
  any string => "string"
  any function => "function"
  any non-function native object => "object"
  any host object    => An implementation-defined string, but not “undefined”, “boolean”, “number”, or “string”.
```

- ```typeof``` returns ```"object"``` if the operand value is ```null```. If you want to distinguish ```null``` from objects, you’ll have to explicitly test for this special-case value.
- ```typeof``` may return a string other than ```"object"``` for host objects. In practice, however, most host objects in client-side Javascript have a type of ```"object"```.
- Because ```typeof``` evaluates to ```"object"``` for all object and array values other than functions, it is useful only to distinguish objects from other, primitive types. In order to distinguish one class of object from another, you must use other techniques, such as the ```instanceof``` operator , the ```class``` attribute, or the ```constructor``` property.
- Although functions in Javascript are a kind of object, the ```typeof``` operator considers functions to be sufficiently different that they have their own return value.


**References**

[JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
