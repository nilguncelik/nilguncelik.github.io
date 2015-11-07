---
title: Javascript Types
author: NC
category: javascript
public: true
---


Javascript types can be grouped in a few different different ways:

1. **primitive** (**value**) types / **object** (**reference**) types
2. **mutable** types / **immutable** types
    + mutable types = object types
    + immutable types = primitive types
3. types **with methods** / types **without methods**

Primitive (Value) Types
---------------------------------------------------

+ numbers, strings, booleans, null and undefined.
+ Strict equality operator (===) considers them to be equal if they have the same value.
+ When we refer to values in javascript we are not refering to value types. Functions, arrays and objects are also values, but their type is not a value type.

Object (Reference) Types
---------------------------------------------------

+ Any Javascript value that is not a number, a string, a boolean, or null or undefined is an **object**.
+ An object is an unordered collection of key and value pairs.
+ **Arrays** are special kind of objects, that represents an ordered collection of numbered values.
+ **Functions** are another special kind of objects that have executable code associated with it. They represent computations to be performed.
+ Functions that are written ( to be used with the new operator) to initialize a newly created object are known as **constructors**.
+ In addition to the **Array** and **Function** classes, core Javascript defines other classes: **Date class**, **RegExp class**, **Error class** and wrapper classes: **Number class**, **Boolean class**, **String class**.
+ Strict equality operator (===) considers them to be equal only if they **refer to** the same instance in the memory.


Mutable types / immutable types
---------------------------------------------------

+ A value of a mutable type can change. Objects and arrays are mutable.
+ Numbers, strings, booleans, null, and undefined are immutable.
+ Strings can be thought of as arrays of characters, and you might expect them to be mutable. However they are immutable: you can access the text at any index of a string but Javascript provides no way to alter the text of an existing string.
+ Primitive types are immutable, and object types are mutable.


Types with / without methods
---------------------------------------------------

+ Technically, only Javascript objects have methods. But numbers, strings, and boolean values behave as if they had methods.  (see **javascript wrapper objects**)
+ **null** and **undefined** are the only values that methods cannot be invoked on.


**References**

[JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
