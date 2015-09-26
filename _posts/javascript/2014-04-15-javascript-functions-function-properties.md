---
title: Javascript Functions - Function Properties
author: NC
category: javascript
public: true
---

- When a function needs a *static variable* whose value persists across invocations, it is often convenient to use a property of the function, instead of cluttering up the namespace by defining a global variable.
- Suppose you want to write a function that returns a unique integer whenever it is invoked. The function must never return the same value twice:

```js
uniqueInteger.counter = 0;
function uniqueInteger() {
    return uniqueInteger.counter++;
}
```
- Note that this implementation creates a public property on the `uniqueInteger` function.
- This can cause buggy or malicious code to reset the counter or set it to a non-integer, causing the function to violate the "unique" or the "integer" part of its contract.
- You can use closures to make counter a private variable.



**References**

- [JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
- [JavaScript Allongé, the "Six" Edition](https://leanpub.com/javascriptallongesix/read)
