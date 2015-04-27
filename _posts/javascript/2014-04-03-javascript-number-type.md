---
title: Javascript Number Type
author: NC
category: javascript
public: true
---

- Javascript does not make distinction between integer values and floating-point values.
- All numbers in Javascript are represented as floating-point values.
- Javascript represents numbers using the 64-bit floating-point format.
- Certain operations in Javascript (such as array indexing and the bitwise operators) are performed with 32-bit integers.
- All numbers are floating-point, so all division operations have floating-point results.
  - `a = 5/2;         // evaluates to 2.5, not 2.`

#### Rounding Errors

```js
var x = .3 - .2;
var y = .2 - .1;
x == y         // => false
x == .1        // => false: .3-.2 is not equal to .1
y == .1        // => true: .2-.1 is equal to .1
```

- This problem is not specific to Javascript: it affects any programming language that uses binary floating-point numbers.


#### Infinity, Not-a-number, Zero, Negative Zero

```js
Infinity  = Number.POSITIVE_INFINITY = 1/0 = Number.MAX_VALUE + 1
-Infinity = Number.NEGATIVE_INFINITY = -1/0 = -Number.MAX_VALUE - 1
NaN = Number.NaN = 0/0
Number.MIN_VALUE/2 = 0
-Number.MIN_VALUE/2 = -1/Infinity = -0
```

- ```NaN``` value does not compare equal to any other value, including itself.
    -    i.e. you can’t write ```x == NaN``` to determine whether the value of a variable x is ```NaN```.
    -    Instead, you should write ```x != x```. That expression will be true if, and only if, x is ```NaN```.
    -    ```isNaN()``` function returns true if its argument is ```NaN```, or if that argument is a non-numeric value such as a string or an object.
- ```isFinite()``` function returns true if its argument is a number other than ```NaN```, ```Infinity```, or ```-Infinity```.
- The negative zero value compares equal to positive zero, which means that the two values are almost indistinguishable, except when used as a divisor:

```js
var zero = 0;                   // Regular zero
var negz = -0;                  // Negative zero
zero === negz                   // => true: zero and negative zero are equal
1/zero === 1/negz               // => false: infinity and -infinity are not equal
```

**References**

[JavaScript: The Definitive Guide, 6th Edition] (http://shop.oreilly.com/product/9780596805531.do)
