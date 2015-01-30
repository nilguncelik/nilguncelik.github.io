---
title: Javascript null and undefined Types
author: NC
category: javascript
public: true
---

#### null
- ```null``` indicates the absence of a value.
- Using the ```typeof``` operator on ```null``` returns the string ```"object"```, indicating that ```null``` can be thought of as a special object value that indicates "no object".
- In practice, however, ```null``` is typically regarded as the sole member of its own type, and it can be used to indicate "no value" for numbers and strings as well as objects.
- You might consider ```null``` to represent program-level, normal, or expected absence of value.


#### undefined
- The undefined value represents a deeper kind of absence. It is:
	- the value of variables that have not been initialized.
	- the value of an object property or array element that does not exist.
	- the value returned by functions that have no return value.
	- the value of function parameters for which no argument is supplied.
- ```undefined``` is a predefined global variable (not a language keyword like ```null```) that is initialized to the ```undefined``` value.
- If you apply the ```typeof``` operator to the ```undefined``` value, it returns “undefined”, indicating that this value is the sole member of a special type.
- You might consider ```undefined``` to represent a system-level, unexpected, or error-like absence of value.


--

- ```null``` and ```undefined``` both indicate an absence of value and can often be used interchangeably.
- The equality operator == considers them to be equal. (Use === to distinguish them.)
- Using . or [] to access a property or method of these values causes a **TypeError**.
- If you need to assign one of these values to a variable or property or pass one of these values to a function, ```null``` is almost always the right choice.


**References**

[JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
