---
title: Javascript Boolean Type
author: NC
category: javascript
public: true
---

- The following values convert to, and work like, false: `undefined, null, 0,-0, NaN, ""`.
- All other values, including all objects (and arrays) convert to, and work like, true.
- `if (o)`
	- execute body if only if `o` is not any falsy value.
	- If you need to distinguish `null` from `0` and `""`, then you should use an explicit comparison.
- `if (o !== null)`
	- if the value of `o` is `undefined`, it causes **ReferenceError**.
	- executes body only if `o` is not `null`.
- `if (o != null)`
	- executes body only if `o` is not `null` or `undefined`.






**References**

[JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
