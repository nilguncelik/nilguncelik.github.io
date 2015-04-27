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

### Best Practices

- When a view is no longer displayed, if they continue to listen to their models for events they continue to stay in memory because models still retain references to them. This may cause serious memory leaks over time.
	- You can use Backbone’s `listenTo` method when subscribing to events rather than using the `on/bind` methods directly.

- Do not use data-attributes on DOM, `e.currentTarget` in handler functions and loops in templates for data that is not read-only.

	```js
	var Person = Backbone.Model.extend();

	var People = Backbone.Collection.extend({
  	model: Person
	});

	var PeopleView = Backbone.View.extend({
	  events: {
	    'click .person': '_personClicked'
	  },
	  render: function() {
	    var renderTemplate = _.template($('#people').text());
	    this.$el.html(renderTemplate({people: this.collection}));
	  },
	  _personClicked: function(e) {
	    var personId = $(e.currentTarget).data('id');
	    var person = this.collection.get(personId);
	    $(e.currentTarget).text(
	      'Nice to meet you, ' + person.get('name')
	    );
	  }
	});
	<script id="people" type="text/template">
	  Here is our list of people:
	  <ul>
	    <% people.each(function(person) { %>
	      <li class='person' data-id='<%= person.id %>'>
	        Hi, my name is <%= person.get('name') %>
	      </li>
	    <% }); %>
	  </ul>
	</script>
	```
	- `_personClicked` function uses `data-id` attribute and `e.currentTarget` to identify and set the person model that is clicked.
	- This is a bad practice. Instead use a different view for `Person`:

	```js
	var PersonView = Backbone.View.extend({
	  tagName: 'li',
	  events: {
	    'click': '_clicked'
	  },
	  render: function() {
	    var renderTemplate = _.template($('#person').text());
	    this.$el.html(renderTemplate({person: this.model}));
	    return this;
	  },
	  _clicked: function() {
	    this.$el.text(
	      'Nice to meet you, ' + this.model.get('name')
	    );
	  }
	});
	var PeopleView = Backbone.View.extend({
	  render: function() {
	    var renderTemplate = _.template($('#people').text());
	    this.$el.html(renderTemplate({people: this.collection}));

	    this.collection.each(function(person) {
	      this.$('ul').append(
	        new PersonView({model: person}).render().$el
	      );
	    }, this);
	  }
	});
	<script id="people" type="text/template">
	    Here is our list of people:
	    <ul></ul>
	</script>
	<script id="person" type="text/template">
	  Hi, my name is <%= person.get('name') %>
	</script>
	```

	- Having lots of views is OK.
	- You may rarely need to use iterators in templates, for example if you are rendering purely read-only data.

- Document your use of options
	- If you didn’t write the code, you often only find out about an option when it got used deep within a class.

	```js
	var MyView = Backbone.View.extend({
	  initialize: function(options) {
	    this._options = options;
	  },
	  // … lots more code
	  doStuff: function() {
	    // ... do a bunch of stuff
	      this._options.obscureBackdoor.doSomethingCrucial();
	    // … do a bunch more stuff
	  }
	  // ... do more stuff
	});
	```
	- Nobody will know that the view has a dependency on an obscure backdoor until they find the options reference deep within the code.
	- This is unfortunate because the options that a view takes constitute part of the public interface of that view.
	- Consequently, all options that a model or view uses be documented somewhere in the class or initializer declaration
	```js
	/**
	 * options:
	 * - obscureBackdoor: a now slightly-less obscure backdoor
	 */
	var MyView = Backbone.View.extend({
	  ...
	});
	```
	- You can also document which options are mandatory and which aren’t actually required.
	- You can check for the presence of mandatory options in the initialize() method of your object.

- Be careful while adding new custom events.
	- The events that an object emits constitute a part of the public interface for that object. So if you’re going to have something emit custom events, it’s really important that you document that it can do so.
	- The most useful events are those that are well-defined, globally understood, and potentially of interest in more than just one or two special-cases. The existing Backbone built-in events meet these criteria. They can take you a long way if you fully leverage them.
	- The one place custom events to be useful is in views that you want to reuse through your apps – for example, UI components like tabs or accordions for other views to detect what a component is doing.

- Don't use templates with single root elements. Views already append their templates to a root element. This makes two nested root elements.

- Always start with the UX and work backwards from there. This means working backwards from your templates and Backbone Views before trying to use fancy architectural approaches.

- Don’t be afraid to have lots of view classes and – where necessary – link between them.

- If you have duplicated business logic in your views, push it down into your models. If views still have to know to much about when models are being updated, start using event listeners on the models so the views don’t have to know in advance when they’re going to change. If your views are getting too big, break them down. If they are still too complicated, introduce an intermediate layer of view-models.

- Have unit tests.



**References**

- <http://addyosmani.github.io/backbone-fundamentals/>
- <https://www.codeschool.com/courses/anatomy-of-backbone-js>
- <https://www.codeschool.com/courses/anatomy-of-backbone-js-part-2>
- <http://blog.shinetech.com/2013/11/26/backbone-antipatterns/>
