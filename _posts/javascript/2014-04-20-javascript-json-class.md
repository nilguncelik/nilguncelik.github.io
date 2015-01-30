---
title: Javascript JSON Class (ES5)
author: NC
category: javascript
public: true
---

- JSON syntax is a subset of Javascript syntax, and it cannot represent all Javascript values.
- Objects, arrays, strings, finite numbers,  ```true```, ```false```, and ```null``` are supported and can be serialized and restored.
- ```NaN```, ```Infinity```, and  ```-Infinity``` are serialized to ```null```.
- Function, RegExp, and Error objects and the ```undefined``` value cannot be serialized or restored.

#### Javascript JSON.stringify() method

- serializes Javascript objects to JSON.
- It serializes only the enumerable own properties of an object.
- It looks for a  ```toJSON()``` method on any object it is asked to serialize.
- If this method exists on the object to be serialized, it is invoked, and the return value is serialized, instead of the original object.
	- ex. ```Date``` objects are serialized to ISO-formatted date strings.
- If a property value cannot be serialized, that property is simply omitted from the stringified output.
- It accepts optional second arguments that can be used to customize the serialization process by specifying a list of properties to be serialized, or by converting certain values during the serialization or stringification process.

#### Javascript JSON.parse() method

- restores Javascript objects from JSON.
- It accepts optional second arguments that can be used to customize the restoration process by specifying a list of properties to be serialized, or by converting certain values.
- It leaves ISO-formatted date strings in string form and does not restore the original ```Date``` object.


**References**

[JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
