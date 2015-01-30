---
title: Javascript Types
author: NC
category: javascript
public: true
---


Javascript types can be grouped in 3 different ways:

1. **primitive** types / **object** types
2. types **with methods** / types **without methods**
3. **mutable** types / **immutable** types
    + mutable types = object types
    + immutable types = primitive types

Primitive Types
---------------------------------------------------

+ numbers, strings, booleans, null and undefined.

Object Types
---------------------------------------------------

+ Any Javascript value that is not a number, a string, a boolean, or null or undefined is an **object**.
+ An object is an unordered collection of key and value pairs.
+ **Arrays** are special kind of objects, that represents an ordered collection of numbered values.
+ **Functions** are another special kind of objects that have executable code associated with it.
+ Functions that are written ( to be used with the new operator) to initialize a newly created object are known as **constructors**.
+ In addition to the Array and Function classes, core Javascript defines three other classes: The **Date class**, the **RegExp class** and the **Error class**.

Types with / without methods
---------------------------------------------------

+ Technically, only Javascript objects have methods. But numbers, strings, and boolean values behave as if they had methods.  (see **javascript wrapper objects**)
+ **null** and **undefined** are the only values that methods cannot be invoked on.

Mutable types / immutable types
---------------------------------------------------

+ A value of a mutable type can change. Objects and arrays are mutable.
+ Numbers, strings, booleans, null, and undefined are immutable.
+ Strings can be thought of as arrays of characters, and you might expect them to be mutable. However they are immutable: you can access the text at any index of a string but Javascript provides no way to alter the text of an existing string.
+ Primitive types are immutable, and object types are mutable.



**References**

[JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
