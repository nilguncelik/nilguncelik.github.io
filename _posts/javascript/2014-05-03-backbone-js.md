---
title: Backbone
author: NC
category: javascript
public: true
---

### Backbone Models

- Here is how a Backbone.Model looks like:

```javascript
var Todo = Backbone.Model.extend({
	initilialize : function(){
		// called when a new instance of a model is created.
		this.on('change', function(){
			console.log('Values for this model have changed.');
		});

		this.on('change:title', function(){
			console.log('Title value for this model have changed.');
		});
	},
	defaults : {
		title : '',
		completed : false
	},
	validate: function(attribs){
		// Note: Backbone passes the attribs param by shallow copy using the Underscore _.extend method.
		// Therefore it is possible to change attributes of objects in this function.

		if(attribs.title === undefined){
			return "Remember to set a title for your todo.";
		}
	}
});
```

- Here is how you can create a Backbone.Model instance and use it:

```javascript
var myTodo = new Todo({
	title: 'this is a title'
});
myTodo.get('completed');  
//  false
myTodo.toJSON();
// returns a copy of the attributes as an object
// i.e. {"title":"this is a title","completed":false}
myTodo.set({
	title: "Both attributes set through Model.set().",
	completed: true
});
myTodo.set("title", "Title attribute set through Model.set().");
myTodo.escape("title") // if title property is supplied from user, you can escape it to prevent XSS attack.

myTodo.set({title: "Pickup Kids"}, {highlight: false});
myTodo.on("change:title", function(model, value, options){
	// options.highlight is false.
});
```

- Events fired on models:
	- `change, change:<attr>, destroy, sync, error, all`
	- **Events triggered on a model in a collection will also be triggered on the collection.**



### Backbone Views

- Here is how a Backbone.View looks like:

```javascript
var TodoView = Backbone.View.extend({
	tagName: 'li',
	todoTpl: _.template( $('#item-template').html() ),
	events: {
		"<event> <selector>" : "<method>",
		// eventnames: click, dblclick, submit, mouseover, mousedown, mouseenter, mouseleave, mousemove, mouseout, mouseup, keypress, keydown, hover, blur, change, focus, focusin, focusout, load, unload, ready, resize, scroll, select
		// if no selector given el is used.
		'dblclick label': 'edit',
		'keypress .edit': 'updateOnEnter',
		'blur .edit': 'close',
	},
	render: function() {
		// This method can be bound to a model’s change() event, allowing the view to always be up to date.

		this.$el.html( this.todoTpl( this.model.toJSON() ) );
		this.input = this.$('.edit');
		return this;
	},
	edit: function() {
		// executed when todo label is double clicked
	},
	close: function() {
		// executed when todo loses focus
	},
	updateOnEnter: function( e ) {
		// executed on each keypress when in todo edit mode,
		// but we'll wait for enter to get in action
	}
});
var myTodoView = new TodoView();


myTodoView.stopListening();
// stop all listeners for this view.
myTodoView.remove()
// will internally call stopListening
// added in Backbone 0.9.9
```

- If you want to create a new HTML element for your view, set any combination of the following view’s properties: `tagName`, `id` and `className`. A new element will be created for you by the framework and a reference to it will be available at the el property.

```javascript
var TodosView = Backbone.View.extend({
	tagName: 'ul', // required, defaults to 'div' if not set
	className: 'container', // optional, you can assign multiple classes
	id: 'todos', // optional
});
```

- If the element already exists in the page, you can set `el` as a CSS selector that matches the element.

```javascript
var TodosView = Backbone.View.extend({
	el: '#footer'
});

var View = Backbone.View.extend({
	el: $("#container"),
	initialize: function(){
		this.render();
	},

	render: function(){
		var template = _.template($("#first_template").html(), {});
		this.$el.html(template);
	}
});
```

- Submitting forms:

```html

// Using plain jquery:
<form action="/todos" method="POST">
	<input name="description" value="What do you need to do?">
	<button>Save<button>
</form>

$('button').click(function(e){
	e.preventDefault();
	var uri = $('form').attr('action');
	var description = $('input[name=description]').val();
	$.post(uri, { description : description } );
});

// Using Backbone:
var TodoForm = Backbone.View.extend({
	template: _.template('<form>' +
		'<input name=description value="<%= description %>" />' +
		'<button>Save</button></form>'),
	events: {
		submit: 'save'
	},
	save: function(e) {
		e.preventDefault();
		var newDescription = this.$('input[name=description]').val();
		this.model.save({description: newDescription});
	}
});

```

### Backbone Collections

- Here is how a Backbone.Collection looks like:


```javascript
var TodosCollection = Backbone.Collection.extend({
	model: Todo,
	localStorage: new Store('todos-backbone')
});
```

- Here is how you can create a Backbone.Collection instance and use it:

```javascript
var myTodo = new Todo({title:'Read the whole book', id: 2});
var todos = new TodosCollection([myTodo]);
var todo2 = todos.get(2);

var a = new Todo({ title: 'Go to Jamaica.'}),
    b = new Todo({ title: 'Go to China.'}),
    c = new Todo({ title: 'Go to Disneyland.'});
var todos = new TodosCollection([a,b]);
todos.add(c);
todos.remove([a,b]);
todos.remove(c);

todos.on("add", function(todo) {  // fires when a model is added.
	console.log("I should " + todo.get("title") + ". Have I done it before? " + (todo.get("completed") ? 'Yeah!': 'No.' ));
});
// "add" event fires when a model is added.
// "remove" event fires when a model is removed.
// "reset" event fires when collection is reset or fetched.

todos.on("change:title", function(model) {
	console.log("Changed my mind where I should go, " + model.get('title'));
});
todos.reset([
	{ title: 'go to Cuba.', completed: false }
]);    // fires reset event.


var filteredNames = todos.chain()
     .filter(function(item) { return item.get('age') > 10; })
     .map(function(item) { return item.get('name'); })
     .value();

var names = todos.pluck('name');

```

- Sorting collections:

```javascript
var TodosCollection = Backbone.Collection.extend({
	comparator: function( todo1, todo2 ){
		return todo1.get("status") < todo2.get("status");
	}
});

// or

var sortedByAlphabet = todos.sortBy(function (todo) {
	return todo.get("title").toLowerCase();
});
```

- Underscore methods implemented on the Collection:
	- `forEach(each), map(collect), reduce(foldl, inject), reduceRight(foldr), find(detect), filter(select), reject, every(all), some(any), contains(include), invoke, max, min, sortBy, groupBy, sortedIndex, shuffle, toArray, size, first(head, take), initial, rest(tail), last, without, indexOf, lastIndexOf, isEmpty, chain`
	- <http://documentcloud.github.io/backbone/#Collection>


### Events

```javascript
var ourObject = {};
_.extend(ourObject, Backbone.Events);
ourObject.on('dance', function(msg){
	console.log('We triggered ' + msg);
});
ourObject.trigger('dance', 'our event');
function dancing (msg) {
	console.log("We started " + msg);
}
ourObject.on("dance:tap", dancing);
ourObject.on("dance:break", dancing);
ourObject.trigger("dance:tap", "tap dancing. Yeah!");
ourObject.trigger("dance:break", "break dancing. Yeah!");
ourObject.trigger("dance", "break dancing. Yeah!"); // This one triggers nothing as no listener listens for it
ourObject.on("all", function(eventName){
	console.log("The name of the event passed was " + eventName);
});                                                              // "all"  triggered when any event occurs
ourObject.off("dance:tap"); // Removes event bound to the object
ourObject.on("move", dancing);
ourObject.on("move", jumping);
ourObject.trigger("move", "Yeah!");
ourObject.off("move", dancing);  // Removes (only the) specified listener
ourObject.trigger("dance jump skip", 'very tired from so much action.'); // Multiple events
ourObject.trigger("dance", {duration: "5 minutes", action: 'dancing'}); // Passing multiple arguments to single event
ourObject.trigger("dance jump skip", {duration: "15 minutes", action: 'on fire'});  // Passing multiple arguments to multiple events
```

### Routes

```javascript
var TodoRouter = new (Backbone.Router.extend({
	routes : {
		'search/:query(/p:page)(/)' : 'search'   // page is optional, slash is optional
		'/^todos\/(\d+)$/' : 'show'              // each regex capture group becomes a param
		'*path' : 'notFound'                     // no route matches
		'file/*path' : 'file'
	},
	search : function(query, page){
		page = page || 0;
		query = decodeURIComponent(query);
	},
	notFound : function(path){
		alert("There is no content here.");
	},
	file : function(path){
		var parts = path.split("/");
	},
}));

TodoRouter.route("<pattern>","<functionName>");   // externally adding new routes.
TodoRouter.navigate("search/milk/p2/", {trigger:true});
TodoRouter.navigate("search/Hello%20World/p2", {trigger:true});
```


**References**

- <http://addyosmani.github.io/backbone-fundamentals/>
- <https://www.codeschool.com/courses/anatomy-of-backbone-js>
- <https://www.codeschool.com/courses/anatomy-of-backbone-js-part-2>
