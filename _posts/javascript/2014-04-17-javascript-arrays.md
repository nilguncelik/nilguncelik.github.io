---
title: Javascript Arrays
author: NC
category: javascript
public: true
---



- Arrays are a specialized kind of object.
- The square brackets used to access array elements work just like the square brackets used to access object properties.
- Javascript converts the numeric array index you specify to a string - the index 1 becomes the string "1" - then uses that string as a property name.
- It is helpful to clearly distinguish an array index from an object property name.
	- All indexes are property names, but only property names that are integers between 0 and 2^32-1 are indexes.
- All arrays are objects, and you can create properties of any name on them. If you use properties that are array indexes, however, arrays have the special behavior of updating their `length` property as needed.
- **When you omit value in an array literal, you are not creating a sparse array. The omitted element exists in the array and has the value `undefined`**.
	- This is subtly different than array elements that do not exist at all.
	- You can detect the difference between these two cases with the `in` operator:

```js
var a1 = [,,,];         // This array is [undefined, undefined, undefined]
var a2 = new Array(3);  // This array has no values at all
0 in a1                 // => true: a1 has an element with index 0
0 in a2                 // => false: a2 has no element with index 0
// The difference between a1 and a2 is also apparent when you use a for/in loop.
```

- The second special behavior that arrays implement in order to maintain the length invariant is that if you set the length property to a non-negative integer n smaller than its current value, any array elements whose index is greater than or equal to n are deleted from the array:

```js
a = [1,2,3,4,5];  // Start with a 5-element array.
a.length = 3;     // a is now [1,2,3].
a.length = 0;     // Delete all elements. a is [].
a.length = 5;     // Length is 5, but no elements, like new Array(5)
```

- In ES5, you can make the length property of an array read-only with `Object.defineProperty()`:

```js
a = [1,2,3];                                            // Start with a 3-element array.
Object.defineProperty(a, "length", {writable: false});   // Make the length property readonly.
a.length = 0;                                           // a is unchanged.
```

- if you make an array element non-configurable, it cannot be deleted. If it cannot be deleted, then the length property cannot be set to less than the index of the non-configurable element.

#### Array functions
- push
	- modifies the array in place.
	- `a.push("c")`
- pop
	- modifies the array in place.
	- `a.pop()`
- unshift
	- adds items to the first position of the array.
	- modifies the array in place.
	- `a.unshift(3,[4,5]);`
- shift
	- removes an item from the first position of the array.
	- modifies array in place.
	- a.shift();
- reverse
	- reverses the order of the elements of an array and returns the reversed array.
	- modifies the array in place.
- sort
	- sorts the elements of an array and returns the sorted array.
	- modifies the array in place.
	- `a.sort(function(a,b) { return a-b;});    // can take sorting function as the argument`
- join
	- converts all the elements of an array to strings and concatenates them (using comma), returning the resulting string.
	- does not modify the array on which it is invoked.
	- it is the inverse of `String.split()`.
	- `a.join()`
	- `a.join("-")    // changes seperator`
- concat
	- creates and returns a new array that contains the elements of the original array on which `concat()` was invoked, followed by each of the arguments to `concat()`.
	- it does not modify the array on which it is invoked.
	- If any of its arguments is itself an array, then it is the array elements that are concatenated, not the array itself.
	- `a.concat(["b",1]);`
- slice
	- returns a slice, or subarray, of the specified array. The returned array contains the element specified by the first argument and all subsequent elements up to, but not including, the element specified by the second argument.
	- If either argument is negative, it specifies an array element relative to the last element in the array
	- It does not modify the array on which it is invoked.
	- If only one argument is specified, the returned array contains all elements from the start position to the end of the array.
- splice
	- The first argument to `splice()` specifies the array position at which the insertion and/or deletion is to begin.
	- The second argument specifies the number of elements that should be deleted from (spliced out of) the array.
	- These arguments may be followed by any number of additional arguments that specify elements to be inserted into the array, starting at the position specified by the first argument.
	- If this second argument is omitted, all array elements from the start element to the end of the array are removed.
	- It returns an array of the deleted elements, or an empty array if no elements were deleted.
	- It inserts arrays themselves, not the elements of those arrays.
	- It modifies the array on which it is invoked.

```js
var a = [1,2,3,4,5];
a.splice(2,0,'a','b');      // Returns []; a is [1,2,'a','b',3,4,5]
a.splice(2,2,[1,2],3);      // Returns ['a','b']; a is [1,2,[1,2],3,3,4,5]
var a = [1,2,3,4,5,6,7,8];
a.splice(4);                // Returns [5,6,7,8]; a is [1,2,3,4]
a.splice(1,2);              // Returns [2,3]; a is [1,4]
a.splice(1,1);              // Returns [4]; a is [1]
```
- foreach (ES5)
	- `a.foreach(function(item){})`
- map (ES5)
	- `a.map()`
- filter (ES5)
	- `a.filter()`
- every (ES5)
	- `a.every()`
- some (ES5)
	- `a.some()`
- reduce (ES5)
	- `a.reduce()`
- reduceRight (ES5)
	- `a.reduceRight()`
- isArray (ES5)

```js
var isArray = Function.isArray || function(o) {
     return typeof o === "object" &&  Object.prototype.toString.call(o) === "[object Array]";
};
```

#### Looping through arrays:
1. Regular for loop
	- It is the best way to loop through arrays.
2. for/in loop
	- The order of iteration is not guaranteed (implementations differ in how they handle this case), so the array indexes may not be visited in the numeric order.
	- You should filter out inherited properties which are also enumerated. (such as the names of methods that have been added to `Array.prototype`)

#### "Array-like" objects
```js
/* Javascript Array-Like Objects */

// The Arguments object is an array-like object.
// In client-side Javascript a number of DOM methods return array-like objects.
// e.g. document.getElementsByTagName()

function arrayLikeObjectTest(){
  var arrayLike = {};           // Start with a regular empty object
  var i = 0;
  while(i < 10) {               // Add properties to make it "array-like"
    arrayLike[i] = i * i;
    i++;
  }
  arrayLike.length = i;

  var total = 0;
  for(var j = 0; j < arrayLike.length; j++)     // Iterate through it as if it were a real array
    total += arrayLike[j];
}

function isArrayLike(o) {
  if ( o &&
       typeof o === "object" &&
       isFinite(o.length) &&
       o.length >= 0 &&
       o.length === Math.floor(o.length) &&
       o.length < 4294967296)
    return true;
  else
    return false;
}

// Since array-like objects do not inherit from Array.prototype, you can not invoke array methods on them directly.
// You can invoke them indirectly using the Function.call method.
```



**References**

- <http://stackoverflow.com/questions/3010840/loop-through-array-in-javascript/>
- [JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
