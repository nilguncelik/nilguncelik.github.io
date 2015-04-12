---
title: JS Performance Tips
author: NC
category: javascript
public: true
---

1- Try not to dynamically type variables

Try to keep variables’ types consistent. It also applies to arrays, try not to mix different types in an array, although it’s mostly optimized by browsers. That’s one of the reasons why C/C++ code compiled to JavaScript is fast, static types.

2- String to Number conversion

Use parseInt and parseFloat functions rather than + and bitwise operators for your code to be fast in both Firefox and Chrome based compilers.

3- Dont use delete operator

It is a lot slower than assigning null to a property. (%99 slower)
The reason is that assigning null doesn’t modify an object’s structure, but delete does.

Note that this can lead to memory leaks as the actual keys in the object are not garbage collected when they just point to the null value. This is especially harmful in objects that are used as dictionaries.

4- Dont add properties later

Define your object’s schema from the beginning. (%100-89 faster)

5- Searching for existence of a string

RegEx.prototype.test is faster than String.prototype.search because it doesn’t return the index of found match.

And also if you are only testing at the beginning or the end of a string, using slice and then comparing the slice to your string is even faster. Example: “mytext”.slice(0, 2) === “my”

6- Searching for index of a found match

String.prototype.indexOf is faster than String.prototype.search

7- Declare and pass local scoped variables

When you call a function, the browser has to do something called scope lookup, which is expensive based on how many scopes it has to lookup. Try not to rely on global/higher scoped variables (closures), instead, make locally scoped variables and **pass them to functions**. Less scopes to lookup, less speed to sacrifice.

8- Dont use JQuery for everything

```js
$('input').keyup(function() {
    if($(this).val() === 'blah') { ... }
});
```
code is much much slower than then:

```js
$('input').keyup(function() {
  if(this.value === 'blah') { ... }   // this.value is compatible with all browser.
});
```


9- Use Web Workers for Heavy Tasks

If you have heavy calculations in your app, for ex some image processing, you can use Web Workers to let the browser run the task in a background thread and give you the results asynchronously instead of hanging up and annoying the user.

You can also use the message channels to show the progress of the task, let’s say you have a long for loop (iterating over pixels for example), you can send a message to indicate how much of the loop is done each 100 iterations and show a progress bar so the user knows what’s happening.


**References**

- <https://medium.com/the-javascript-collection/lets-write-fast-javascript-2b03c5575d9e>
