---
title: Javascript Comparison
author: NC
category: javascript
public: true
---


## Value vs Reference Comparison
- Primitive types are compared by value:
	- Two values are the same only if they have the same value.
		- ex. numbers, booleans, null, and undefined.
	- Two strings are equal if, and only if, they have the same length and if the character at each index is the same.
- Objects are compared by reference:
	- Two objects are not equal even if they have the same properties and values.
	- Two arrays are not equal even if they have the same elements in the same order.
	- Two object values are the same if and only if they refer to the same underlying object.

## Strict equality operator `===`
- It evaluates its operands, and then compares the two values as follows, performing no type conversion:
	- If the two values have different types, they are not equal.
	- If both values are `null` or both values are `undefined`, they are equal.
	- If both values are the boolean value `true` or both are the boolean value `false`, they are equal.
	- If one or both values is `NaN`, they are not equal. The `NaN` value is never equal to any other value, including itself.
	- If both values are numbers and have the same value, they are equal. If one value is 0 and the other is -0, they are also equal.
	- If both values are strings and contain exactly the same 16-bit values in the same positions, they are equal. If the strings differ in length or content, they are not equal.
		- Two strings may have the same meaning and the same visual appearance, but still be encoded using different sequences of 16-bit values. Javascript performs no Unicode normalization, and a pair of strings like this are not considered equal to the `===` or to the `==` operators. `String.localeCompare()` can be used to compare these strings.
	- If both values refer to the same object, array, or function, they are equal. If they refer to different objects they are not equal, even if both objects have identical properties.

## Equality operator `==`
- It is like the `===` operator, but it is less strict. If the values of the two operands are not the same type, it attempts some type conversions and tries the comparison again:
	- If the two values have the same type, test them for `===`. If they are strictly equal, they are equal. If they are not strictly equal, they are not equal.
	- If the two values do not have the same type, use the following rules and type conversions to check for equality:
		- If one value is `null` and the other is `undefined`, they are equal.
		- If one value is a number and the other is a string, convert the string to a number and try the comparison again, using the converted value.
		- If either value is true, convert it to 1 and try the comparison again. If either value is false, convert it to 0 and try the comparison again.
		- If one value is an object and the other is a number or string, convert the object to a primitive and try the comparison again. An object is converted to a primitive value by either its toString() method or its valueOf() method. The built-in classes of core Javascript attempt `valueOf()` conversion before `toString()` conversion, except for the `Date` class, which performs `toString()` conversion. Objects that are not part of core Javascript may convert themselves to primitive values in an implementation-defined way.
		- Any other combinations of values are not equal.

```js
undefined == false // false
null == undefined  // true
"0" == 0           // true
0 == false         // true
"0" == false       // true
```

**References**

[JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
