---
title: Javascript Wrapper Objects
author: NC
category: javascript
public: true
---


- Strings, numbers and booleans are primitive types in JavaScript.
- But they can have **properties** and **methods**.
- When you refer to property of a string,number or boolean, JavaScript:
    1. converts the primitive value to an object by calling **new String()**, **new Number()** or **new Boolean()** on it.
    2. resolves property reference.
    3. discards newly created object.
      - (JS interpreters do not necessarily create and discard this transient object, but they must behave as if they do.)

```js
    var s = "hello world!";
    var word = s.substring(s.indexOf(" ")+1, s.length);

    var s = "test";
    s.len = 4;
    // creates a temporary String object, sets its len property to 4,
    // and then discards that object.
    var t = s.len;
    // creates a new String object from the original (unmodified) string
    // value and tries to read the len property.
    // this property does not exist, and the expression evaluates to *undefined*.
```

- There are no wrapper objects for the null and undefined values.
  - Any attempt to access a property of one of these values causes a **TypeError**.


### Distinguishing between primitive value and its wrapper

- The `==` operator treats a value and its wrapper object as equal but `===` operator does not.
- The `typeof` operator can also show the difference between a primitive value and its wrapper object.


**References**

[JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
