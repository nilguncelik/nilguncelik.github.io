---
title: Javascript Property Access
author: NC
category: javascript
public: true
---

## in operator
- It expects a property name (as a string) on its left side and an object on its right.
- It returns true if the object has an own property or an inherited property by that name.

```js
var point = { x:1, y:1 };
"x" in point             // => true: object has property named "x"
"z" in point             // => false: object has no "z" property.
"toString" in point      // => true: object inherits toString method
```

```js
var data = [7,8,9];
"0" in data              // => true: array has an element "0"
1 in data                // => true: numbers are converted to strings
3 in data                // => false: no element 3
```

- `in` can distinguish between properties that do not exist and properties that exist but have been set to undefined.

```js
var o = { x: undefined } // Property is explicitly set to undefined
o.x === undefined        // true: property exists but is undefined
o.y === undefined        // true: property doesn't even exist
"x" in o                 // true: the property exists
"y" in o                 // false: the property doesn't exists
delete o.x;              // Delete the property x
"x" in o                 // false: it doesn't exist anymore
```

## hasOwnProperty() method
- It tests whether that object has an own property with the given name.
- It returns false for inherited properties.

```js
var o = { x: 1 }
o.hasOwnProperty("x");          // true: o has an own property x
o.hasOwnProperty("y");          // false: o doesn't have a property y
o.hasOwnProperty("toString");   // false: toString is an inherited property
```

## for/in loop
- It runs the body of the loop once for each enumerable property (own or inherited) of the specified object, assigning the name of the  property  to  the  loop  variable.
- If the body of a for/in loop deletes a property that has not yet been enumerated, that property will not be enumerated.
- If the body of the loop defines new properties on the object, those properties will generally not be enumerated.
- Some implementations may enumerate inherited properties that are added after the loop begins.

## Object.keys() function (ES5)
- Returns an array of the names of the enumerable own properties of an object.

## Object.getOwnPropertyNames() function (ES5)
- It works like `Object.keys()` but returns the names of all the own properties of the specified object, not just the enumerable properties.
- There is no way to write this function in ES3, because ES 3 does not provide a way to obtain the non-enumerable properties of an object.

## propertyIsEnumerable() method
- It returns true only if the named property is an own property and its enumerable attribute is true.
- Certain built-in properties are not enumerable.
- Properties created by normal Javascript code are enumerable unless you’ve used one of the ES5 methods to make them non-enumerable.

```js
var o = inherit({ y: 2 });
o.x = 1;
o.propertyIsEnumerable("x");                       // true: o has an own enumerable property x
o.propertyIsEnumerable("y");                       // false: y is inherited, not own
Object.prototype.propertyIsEnumerable("toString"); // false: not enumerable
```

**References**

[JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
