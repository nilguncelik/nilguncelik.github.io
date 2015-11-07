---
title: Javascript Error Class
author: NC
category: javascript
public: true
---


- The `Error` constructor creates an error object.
- Instances of `Error` objects are thrown when runtime errors occur.
- The `Error` object can also be used as a base object for user-defined exceptions.

#### Throwing errors:
- `throw expression;`
- expression may evaluate to a value of any type. You might throw a number that represents an error code or a string that contains a human-readable error message.

```js
if (x < 0)
    throw new Error("x must not be negative");
```

#### Error Handling

```js
try {
  // ..
} catch (e) {
  if (e instanceof EvalError) {
    // ..
  } else if (e instanceof RangeError) {
    // ..
  }
}
```

- Unlike any other identifiers, the identifiers associated with a catch clause has block scope — they are only defined within the catch block.

**References**

[JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
