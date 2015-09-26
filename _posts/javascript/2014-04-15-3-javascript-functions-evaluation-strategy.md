---
title: Javascript Functions - Evaluation Strategy
author: NC
category: javascript
public: true
---


- JavaScript uses call-by-sharing (a specialization of call-by-value) evaluation strategy similar to Java.


- When an argument is passed as an parameter to a function, JavaScript binds the value of argument to the name of the parameter in the function's environment.
- The general rule is that the value bound in the function's environment must be identical to the original.
- **When JavaScript binds a primitive-type to a name, it makes a copy of the value and places the copy in the environment**.
	- value types like strings and numbers are identical to each other if they have the same content, satisfying the above rule.
- **When binding a reference-type value to a name, JavaScript does not place copies of reference values, rather places references to reference types in the environments**.
	- When the value needs to be used, JavaScript uses the reference to obtain the original.
	- "call by sharing" name comes from the fact that JavaScript passes references as arguments and many references can share the same value.

- As a result:
	- Changing the value of a parameter variable never changes the underlying primitive or object, it just points the variable to a new primitive or object.
	- Changing a property of an object referenced by a parameter variable does change the underlying object.


**References**


- [JavaScript Allongé, the "Six" Edition](https://leanpub.com/javascriptallongesix/read)
- <http://stackoverflow.com/questions/6605640/javascript-by-reference-vs-by-value/>
