---
title: Javascript Type Conversions
author: NC
category: javascript
public: true
---

See  <https://www.inkling.com/read/javascript-definitive-guide-david-flanagan-6th/chapter-3/type-conversions/>


#### Number to String Conversion

- `toString()` method.
```js
var num = 2;
var str = num.toString();
```

- `String` function.
```js
var num = 2;
var str = String(num);
// !! do not use new prefix. TODO why?
var str = new String(num);
```


#### String to Number Conversion

- `+` prefix operator.
   - preferred way, because it is shortest.

- `Number` function
```js
new Number("3 blind mice")  // NaN, returns Wrapper object
new Number("11", 2)         // 11, only works for base-10 integers , returns Wrapper object
new Number("077", 8)        // 77, only works for base-10 integers , returns Wrapper object
new Number("0xFF")          // 255, returns Wrapper object
new Number(".1")            // 0.1, returns Wrapper object
```

- `parseInt` function
    - Stops at first non-digit character, without warning.
    - radix always be used, because otherwise for example parsing `08` from dates and times can result in base 16 interpretation.
```js
parseInt("3 blind mice")    // => 3, returns primitive number type
parseInt(" 3 blind mice")   // => 3, returns primitive number type
parseInt("blind 3 mice")    // => NaN
parseInt("11", 2)           // => 3 , returns primitive number type
parseInt("077", 10)         // => 77 , returns primitive number type
parseInt("0xFF")            // => 255, returns primitive number type
parseInt(".1")              // => NaN: integers can't start with ".",
							// returns primitive number type
parseFloat(" 3.14 meters")  // => 3.14, returns primitive number type
parseFloat("$72.47")        // => NaN: numbers can't start with "$",
							// returns primitive number type
```

#### Value to Boolean conversion

- Use `!!` operator.


**References**

[JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
