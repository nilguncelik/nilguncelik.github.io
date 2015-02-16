---
title: Javascript Objects
author: NC
category: javascript
public: true
---


- An object is an unordered collection of properties, each of which has a name and a value.
- In addition to its properties, every object has 3 associated object attributes:
	1. An object’s prototype is a reference to another object from which properties are inherited.
	2. An object’s class is a string that categorizes the type of an object.
	3. An object’s extensible flag specifies (in ES5) whether new properties may be added to the object.
- There are 3 categories of Javascript objects:
	1. A native object is an object or class of objects defined by the ECMAScript specification. Arrays, functions, dates, and regular expressions are native objects.
	2. A host object is an object defined by the host environment (such as a web browser) within which the Javascript interpreter is embedded. The HTMLElement objects that represent the structure of a web page in client-side Javascript are host objects. Host objects may also be native objects, as when the host environment defines methods that are normal Javascript Function objects.
	3. A user-defined object is any object created by the execution of Javascript code.
- There are 2 types of object properties:
	1. An own property is a property defined directly on an object.
	2. An inherited property is a property defined by an object’s prototype object.
- Property attributes:
	1. The writable attribute specifies whether the value of the property can be set.
	2. The enumerable attribute specifies whether the property name is returned by a for/in loop.
	3. The configurable attribute specifies whether the property can be deleted and whether its attributes can be altered.
- All properties created by ES3 programs are writable, enumerable, and configurable, and there is no way to change this.
- ES5 has an API for querying and setting property attributes. It allows library authors to
	- add methods to prototype objects and make them non-enumerable, like built-in methods.
	- "lock down" their objects, defining properties that cannot be changed or deleted.

### Object Creation
1. object literals
2. new keyword
3. Object.create() function (in ES5)

#### Object Creation with object literals:
```
var book = {
     "main title": "Javascript",
     'sub-title': "The Definitive Guide",
     "for": "all audiences",
     author: {
          firstname: "David",
          surname: "Flanagan"
     }
};
```
- An object literal is an expression that creates and initializes a new and distinct object each time it is evaluated.
- The value of each property is evaluated each time the literal is evaluated.
	- This means that a single object literal can create many new objects if it appears within the body of a loop in a function that is called repeatedly.
- Property names that include spaces, hyphens or reserved words should be quoted.

#### Object Creation with new keyword:
```
var o = new Object();       // Create an empty object: same as {}.
var a = new Array();        // Create an empty array: same as [].
var d = new Date();         // Create a Date object representing the current time
var r = new RegExp("js");   // Create a RegExp object for pattern matching.
```

- It creates and initializes a new object.
- It must be followed by a function invocation.
	- A function used in this way is called a constructor and serves to initialize a newly created object.
	- Javascript first creates a new empty object, just like the one created by the object initializer {} .
	- *This new object inherits from the prototype property of the constructor*.
	- Then, it invokes the specified function with the specified arguments, passing the new object as the value of the this keyword.
	- The function can then use this to initialize the properties of the newly created object.
	- Functions written for use as constructors do not return a value, and the value of the object creation expression is the newly created and initialized object.
	- If a constructor does return an object value, that value becomes the value of the object creation expression and the newly created object is discarded.
	- If the constructor uses return with no value, or if it returns a primitive value the return value is discarded and the value of the object creation expression is the newly created and initialized object.
- Core Javascript includes built-in constructors for native types.
- You can also define your own constructor functions to initialize newly created objects.

#### Object Creation with Object.create():
```
var o1 = Object.create({x:1, y:2}); // o1 inherits properties x and y.
```

- It is a static function, not a method invoked on individual objects.
- You can pass null to create a new object that does not have a prototype.
	- But if you do this, the newly created object will not inherit anything, not even basic methods like toString():
		- ```var o2 = Object.create(null);```
- If you want to create an ordinary empty object (like the object returned by {}or new Object()), pass Object.prototype:
	- ```var o3 = Object.create(Object.prototype);```
- It also takes an optional second argument that describes the properties of the new object.

#### Creating a new object that inherits from a prototype:

```
function inherit(p) {
     if (p == null) throw TypeError();
     if (Object.create)
          return Object.create(p);
     var t = typeof p;                       // Do some more type checking
     if (t !== "object" && t !== "function")
				throw TypeError();
     function f() {};                        // Define a dummy constructor function.
     f.prototype = p;                        // Set its prototype property to p.
     return new f();                         // Use f() to create an "heir" of p.
}
```

- ```inherit()``` returns a newly created object that inherits properties from the prototype object ```p```.
	- It uses the ES5 function ```Object.create()``` if it is defined.
	- Otherwise falls back to an older technique.
- ```inherit()``` is not a full replacement for ```Object.create()```:
	- it does not allow the creation of objects with null prototypes.
	- it does not accept the optional second argument that ```Object.create()``` does.
- You can use ```inherit()``` function when you want to guard against unintended (but non-malicious) modification of an object by a library function that you don't have control over.
	- Instead of passing the object directly to the function, you can pass an heir. If the function reads properties of the heir, it will see the inherited values. If it sets properties, however, those properties will only affect the heir, not your original object:
		- ```var o = { x: "don't change this value" };```
		- ```library_function(inherit(o));     // Guard against accidental modifications of o```


#### How properties are queried and set:
- Suppose you query the property ```x``` in the object ```o```.
	- If ```o``` does not have an own property with that name, the prototype object of ```o``` is queried for the property ```x```.
	- If the prototype object does not have an own property by that name, but has a prototype itself, the query is performed on the prototype of the prototype.
	- This continues until the property ```x``` is found or until an object with a ```null``` prototype is searched.
	- As you can see, the prototype attribute of an object creates a chain or linked list from which properties are inherited.

```
var o = {}             // o inherits object methods from Object.prototype
o.x = 1;               // and has an own property x.
var p = inherit(o);    // p inherits properties from o and Object.prototype
p.y = 2;               // and has an own property y.
var q = inherit(p);    // q inherits properties from p, o, and Object.prototype
q.z = 3;               // and has an own property z.
var s = q.toString();  // toString is inherited from Object.prototype
q.x + q.y              // => 3: x and y are inherited from o and p
```
- Suppose you assign to the property ```x``` of the object ```o```.
 - If ```o``` already has an own property named ```x```, then the assignment simply changes the value of this existing property.
 - Otherwise, the assignment creates a new property named ```x``` on the object ```o```.
 - If ```o``` previously inherited the property ```x```, that inherited property is now hidden by the newly created own property with the same name.
- Property assignment examines the prototype chain to determine whether the assignment is allowed. If ```o``` inherits a read-only property named ```x```, for example, then the assignment is not allowed. If the assignment is allowed, however, it always creates or sets a property in the original object and never modifies the prototype chain.
- The fact that inheritance occurs when querying properties but not when setting them is a key feature of Javascript because it allows us to selectively override inherited properties:

```
var unitcircle = { r:1 };     // An object to inherit from
var c = inherit(unitcircle);  // c inherits the property r
c.x = 1; c.y = 1;             // c defines two properties of its own
c.r = 2;                      // c overrides its inherited property
unitcircle.r;                 // => 1: the prototype object is not affected
```

- There is one exception this assignment rule:
	- If ```o``` inherits the property ```x```, and that property is an accessor property with a setter method, then that setter method is called rather than creating a new property ```x``` in ```o```.
	- This setter method is called on the object ```o```, not on the prototype object that defines the property, so if the setter method defines any properties, it will do so on ```o```, and it will again leave the prototype chain unmodified.
- Attempting to set a property on ```null``` or ```undefined``` causes a **TypeError**.
- An attempt to set a property ```p``` of an object ```o``` fails in these circumstances:
	- ```o``` has an own property ```p``` that is read-only.
		- ```defineProperty()``` is an exception that allows configurable read-only properties to be set.
	- ```o``` has an inherited property ```p``` that is read-only.
		- It is not possible to hide an inherited read-only property with an own property of the same name.
	- ```o``` does not have an own property ```p```; ```o``` does not inherit a property ```p``` with a setter method, and ```o```'s extensible attribute is false.
		- If ```p``` does not already exist on ```o```, and if there is no setter method to call, then ```p``` must be added to ```o```. But if ```o``` is not extensible, then no new properties can be defined on it.
- Failed attempts to set properties
	- fail silently in non-strict mode:
		- ```Object.prototype = 0;      // The prototype properties of built-in constructors are read-only. Object.prototype is unchanged.```
	- throws a **TypeError** exception in strict mode of ES5.

#### Prototypes

- Every Javascript object has a second Javascript object associated with it. This second object is known as a prototype, and the first object inherits properties from the prototype.
- All objects created by object literals have the same prototype object, and we refer to this prototype object as ```Object.prototype```.
- Objects created using the ```new``` keyword use the value of the ```prototype``` property of the constructor function as their prototype.
	- The object created by ```new Object()``` inherits from ```Object.prototype``` just as the object created by ```{}``` does.
	- Similarly, the object created by ```new Array()``` uses ```Array.prototype``` as its prototype, and the object created by ```new Date()``` uses ```Date.prototype``` as its prototype.
- Objects created with ```Object.create()``` use the first argument to that function (which may be ```null```) as their prototype.
- ```Object.prototype``` is one of the rare objects that has no prototype: it does not inherit any properties.
- Other prototype objects are normal objects that do have a prototype.
	-	All of the built-in constructors (and most user-defined constructors) have a prototype that inherits from ```Object.prototype```.
	- For example, ```Date.prototype``` inherits properties from ```Object.prototype```, so a ```Date``` object created by ```new Date()``` inherits properties from both ```Date.prototype``` and ```Object.prototype```. This linked series of prototype objects is known as a **prototype chain**.

#### getPrototypeOf() method (ES5)
- You can query the prototype of any object by passing that object to ```Object.getPrototypeOf()```.
- There is no equivalent function in ES3, but it is possible to determine  the  prototype  of  an  object  ```o``` using  the expression:
	- ```o.constructor.prototype```

#### isPrototypeOf() method (ES5)
- Determines whether one object is the prototype of (or is part of the prototype chain of) another object.
- Note that isPrototypeOf() performs a function similar to the ```instanceof``` operator.

```
var p = {x:1};                      // Define a prototype object.
var o = Object.create(p);           // Create an object with that prototype.
p.isPrototypeOf(o)                  // => true: o inherits from p
Object.prototype.isPrototypeOf(o)   // => true: p inherits from Object.prototype
```

### Classes

- A class is a set of objects that inherit properties from the same prototype object.
- If we define a prototype object, and then use ```inherit()``` to create objects that inherit from it, we have defined a JavaScript class.

#### Factory Function vs Constructor Function
	- **Factory function** creates the object (using inherit function) in the body and returns it.
	- **Constructor function** does not create any object. It is created by the new operator and passed as ```this``` value to the constructor. The new object is automatically returned.

```js
// Factory function
function range(from, to) {
  var r = inherit(range.methods);
  r.from = from;
  r.to = to;
  return r;
}
range.methods = {
  includes: function(x) { return this.from <= x && x <= this.to; },
  foreach: function(f) {
    for(var x = Math.ceil(this.from); x <= this.to; x++) f(x);
  },
  toString: function() { return "(" + this.from + "..." + this.to + ")"; }
};

var r = range(1,3);           // Create a range object
r.includes(2);                // => true: 2 is in the range
r.foreach(console.log);       // Prints 1 2 3
console.log(r);               // Prints (1...3)


// Constructor function
function Range(from, to) {
  this.from = from;
  this.to = to;
}
Range.prototype = {
  includes: function(x) { return this.from <= x && x <= this.to; },
  foreach: function(f) {
    for(var x = Math.ceil(this.from); x <= this.to; x++) f(x);
  },
  toString: function() { return "(" + this.from + "..." + this.to + ")"; }
};

var r = new Range(1,3);     // Create a range object
r.includes(2);              // => true: 2 is in the range
r.foreach(console.log);     // Prints 1 2 3
console.log(r);             // Prints (1...3)
```

- The name of the constructor function is adopted as the name of the class.
- Constructors are used with the ```instanceof``` operator when testing objects for membership in a class.
	- ```r instanceof Range```
	- The ```instanceof``` operator does not actually check whether ```r``` was initialized by the ```Range``` constructor. It checks whether it inherits from ```Range.prototype```.
- Any Javascript function can be used as a constructor, and constructor invocations need a prototype property. Therefore, every Javascript function automatically has a prototype property. The value of ```this``` property is an object that has a single non-enumerable constructor property.

- Every object has a build-in property named constructor.

```js
function Rabbit() { /* ..code.. */ }
// Rabbit.prototype = { constructor: Rabbit }   ---> automatic
```
- When you declare a function `function Rabbit() { }`:
	- The interpreter creates a new function object from your declaration.
	- Together with the function, it’s `prototype` property is created and populated.
	- This default `prototype` property is an object with property `constructor`, which is set to the function itself.
	- i.e. `Rabbit.prototype = { constructor: Rabbit }`.

```js
var rabbit = new Rabbit()
// rabbit.__proto__ == { constructor: Rabbit }  ---> automatic
// rabbit.constructor == Rabbit                 ---> automatic
// rabbit.constructor actually calls rabbit.__proto__.constructor
```
- When you call `new Rabbit()`:
	- The interpreter creates a new object.
	- The interpreter sets the `constructor` property of the object to Rabbit.
	- The interpreter sets up the object to delegate to Rabbit.prototype.
	- The interpreter calls Rabbit() in the context of the new object.
	- <http://pivotallabs.com/javascript-constructors-prototypes-and-the-new-keyword/>


- If you override prototype of Rabbit, rabbit will loose its constructor property:

```js
function Rabbit() { }
Rabbit.prototype = {}    // this results in rabbit loosing its constructor. dont do it.
var rabbit = new Rabbit()
// rabbit.__proto__ == {  }  ---> automatic
```
- <http://javascript.info/tutorial/constructor>




####  Inheritance

- a base class Animal:

```js
function Animal(name) {
	// each instance have this property initialized.
	this.name = name;
}

// Prototype properties are shared across all instances of the class.
// However, they can still be overwritten on a per-instance basis with the `this` keyword.
Animal.prototype.speak = function() {
	console.log("My name is " + this.name);
};

var animal = new Animal('Monty');
animal.speak(); // My name is Monty

new Animal('Monty')
Animal
	name: "Monty"
	__proto__: Animal
		constructor: function Animal(name){
		speak: function (){
		__proto__: Object

```

- inheriting from Animal class:

```js
function Cat(name) {
	Animal.call(this, name);      // inherit Animals constructor. similar to super in Java.
	                              // Note that context is passed to Animal constructor.
}

Cat.prototype = new Animal();   // cat inherits all of Animals properties.

var cat = new Cat('Monty');
cat.speak(); 										// My name is Monty

new Cat('Monty')
Cat
	name: "Monty"
	__proto__: Animal
		name: undefined
		__proto__: Animal
			constructor: function Animal(name){
			speak: function (){
			__proto__: Object
```
- Defining subclass
	- ```constructor.prototype = inherit(superclass.prototype);
		constructor.prototype.constructor = constructor;```
- Javascript’s prototype-based inheritance mechanism is dynamic:  
	- **an  object  inherits properties from its prototype, even if the prototype changes after the object is created**.


#### Java-like Classes

- We can create a Java-style class using 3 step algorithm:
	- write a constructor function that sets instance properties on new objects.
	- define instance methods on the prototype object of the constructor.
	- define class fields and class properties on the constructor itself.

```
function MyClass() {

    var self = this;

    this.publicMember;
    var privateMember;
    function privateMethod() { 
        // can access private and public members
    }

    // It is inefficient because assigned is done at every constructor call.
    this.privilegedPublicMethod = function() { // can access private and public members };
}

// This is more efficient than privileged methods.
MyClass.prototype.publicMethod = function() { // can access private? and public members }
MyClass.publicStaticMethod = function() {}
MyClass.publicStaticMember = {}

var myClass = new MyClass();


// more memory friendly
// private members/methods are not actually private
function MyClass2() {
    this.publicMember;
    this._privateMember;
}
MyClass2.prototype = {
    publicMethod = function(){};
    _privateMethod = function(){};
}
MyClass2.publicStaticMethod = function() {}
MyClass2.publicStaticMember = {}

var myClass2 = new MyClass2();
```

- Private properties can be created using closures.
	- **But a class that uses a closure to encapsulate its state is slower and larger than the equivalent class with unencapsulated state variables**.






#### Determining Classes and Types

- ```typeof``` operator
	- Does not distinguish objects based on their class.
- ```class``` attribute / ```classof()``` function
	- User-defined classes have a class attribute of "Object".
- ```instanceof```
	- ```o instanceof c```
		- evaluates to ```true``` if ```o``` inherits from ```c.prototype```.
	- The inheritance need not be direct.
	- It tests what an object inherits from, not what constructor was used to create it.
	- It won't work when there are multiple execution contexts.
		- ex. The ```Array``` constructor in one window is not equal to the ```Array``` constructor in another window.
- ```isPrototypeOf```
	- It tests what an object inherits from, not what constructor was used to create it.
	- It won't work when there are multiple execution contexts.
		- ex. The ```Array``` constructor in one window is not equal to the ```Array``` constructor in another window.
- ```constructor``` property
	- It won't work when there are multiple execution context
		- ex. The ```Array``` constructor in one window is not equal to the ```Array``` constructor in another window.
	- Every object may not have a constructor property.
- name of the constructor function
	- Works even there are multiple execution contexts.
	- Every object may not have a constructor property.
- Duck-Typing
	- If an object can walk and swim and quack like a Duck, then we can treat it as a Duck, even if it does not inherit from the prototype object of the Duck class.

```
function type(o) {
  var t, c, n;                     // type, class, name

  if (o === null) return "null";

  if (o !== o) return "nan";

  // Use typeof for any value other than "object".
  // This identifies any primitive value and also functions.
  if ((t = typeof o) !== "object") return t;

  // Return the class of the object unless it is "Object".
  // This will identify most native objects.
  if ((c = classof(o)) !== "Object") return c;

  // Return the object's constructor name, if it has one
  if (o.constructor && typeof o.constructor === "function" &&
  (n = o.constructor.getName())) return n;

  // We can't determine a more specific type, so return "Object"
  return "Object";
}

function classof(o) {
  return Object.prototype.toString.call(o).slice(8,-1);
};

Function.prototype.getName = function() {
  if ("name" in this) return this.name;
    return this.name = this.toString().match(/function\s*([^(]*)\(/)[1];
};

// Duck Typing
// Return true if o implements the methods specified by the args.
function quacks(o /*, ... */) {
  for(var i = 1; i < arguments.length; i++) {
    var arg = arguments[i];
    switch(typeof arg) {
      case 'string':                    // check for a method with that name
        if (typeof o[arg] !== "function") return false;
          continue;
      case 'function':                  // use the prototype object
        arg = arg.prototype;
        // fall through to the next case
      case 'object':                    // check for matching methods
        for(var m in arg) {             // For each property of the object
          if (typeof arg[m] !== "function") continue;       // skip non-methods
            if (typeof o[m] !== "function") return false;
          }
        }
    }

    return true;
}
```






#### Objects As Associative Arrays
- ```object["property"]``` syntax, looks like array access where the array is indexed by strings rather than by numbers.
- This kind of array is known as an associative array (or hash or map or dictionary). Therefore Javascript objects are associative arrays.
- When you access a property of an object with the [] array notation, the name of the property is expressed as a string. Strings can be manipulated and created while a program is running

```
var addr = "";
for(i = 0; i < 4; i++) {
     addr += customer["address" + i] + '\n';
}    // read and concatenate the address0, address1, address2, and address3 properties of the customer object.
```

- If the name of the property you want to access is determined at run time dynamically, you can use the [] operator. Because it uses a string value (which is dynamic and can change at runtime) rather than an identifier (which is static and must be hard-coded in the program) to name the property.


**References**

- [JavaScript: The Definitive Guide, 6th Edition](http://shop.oreilly.com/product/9780596805531.do)
- <http://davidwalsh.name/javascript-objects-deconstruction>
- <http://wildlyinaccurate.com/understanding-javascript-inheritance-and-the-prototype-chain/>
