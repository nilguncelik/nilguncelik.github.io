---
title: Flux Architecture
author: NC
category: javascript
public: true
---


### Flux


- Flux takes its name from the Latin word for flow.
- It encourages centralized data stores, immutable objects, and single directional data flow in place of controllers, models, and bi-directional data bindings.
- It works well with React because the objects are passed directly into React views for consumption, where they cannot be modified by the views themselves. When a view wants to change a piece of data, (perhaps based on user input), the view informs the store that something has changed, which will validate the input and then propagate the change out to the rest of the application. In this way, you never worry about incremental state mutation, or incremental updates, and every change that happens to the system (whether it comes from user input, an ajax response from the server, or anything else) goes through the exact same flow (which handles validation, batching, persisting, etc).
	- The concept "Flux" is simply that your view triggers an event (say, after user types a name in a text field), that event updates a model, then the model triggers an event, and the view responds to that model's event by re-rendering with the latest data.
	- This one way data flow / decoupled observer pattern is designed to guarantee that your source of truth always stays in your stores / models.
	- Put all the async data loading on the action creators, and keep views/stores fully sync.

	#### Stores
	- Moving the application logic into the central store layer makes it more testable, and it becomes easier to refactor the internal representation without breaking existing views. We also get a nice separation of concerns between the views and the data layer, something that React already encourages.
	- Each store should be a **singleton**. They should remain as independent and decoupled as possible - a self-contained universe that one can query from a Controller-View.
	- A store manages application state and business logic for a logical domain
	- Private variables hold the application data.
	- The only road into the Store is through the callback it registers with the Dispatcher.
	- The only road out is through getter functions. Stores also publish an event when their state has changed, so Controller-Views can know when to query for the new state, using the getters.

```js
// FooStore.js
var _dispatchToken;
var _messages =	{};
class FooStore extends EventEmitter {  // extends EventEmitter to emit events with this.emit()
	constructor()	{
		super();
		_dispatchToken = AppDispatcher.register((action)	=>	{
			switch(action.type)	{
				case ActionTypes.MESSAGE_CREATE:
					var message =	{
						id: Date.now(),
						text: action.text
					}
					_messages[message.id]	= message;
					this.emit('change');
					break;
				case ActionTypes.MESSAGE_DELETE:
					delete _messages[action.messageID];
					this.emit('change');
					break;
					default:
						//	no	op
			}
		});
	}
	getDispatchToken()	{
		return _dispatchToken;
	}
	getMessages()	{
		return _messages;
	}
}
module.exports = new FooStore();
```


	#### Controller-Views
	- They are views often that are found at the top of the hierarchy that retrieve data from the stores and pass this data down to their children.
	- We often pass the entire state of the store down the chain of views in a single object, allowing different descendants to use what they need. In addition to keeping the controller-like behavior at the top of the hierarchy, and thus keeping our descendant views as functionally pure as possible, passing down the entire state of the store in a single object also has the effect of reducing the number of props we need to manage.
	- Occasionally we may need to add additional controller-views deeper in the hierarchy to keep components simple. This might help us to better encapsulate a section of the hierarchy related to a specific data domain. Be aware, however, that controller-views deeper in the hierarchy can violate the singular flow of data by introducing a new, potentially conflicting entry point for the data flow. In making the decision of whether to add a deep controller-view, balance the gain of simpler components against the complexity of multiple data updates flowing into the hierarchy at different points. These multiple data updates can lead to odd effects, with React's render method getting invoked repeatedly by updates from different controller-views, potentially increasing the difficulty of debugging.

	#### Action Creators

	- The action construction may be wrapped into a semantic helper method, which we refer to as **action creators**. These methods provide the payload to the dispatcher. This method may be invoked from within our views' event handlers, so we can call it in response to a user interaction. The action creator method also adds the type to the action, so that when the payload is interpreted in the store, it can respond appropriately to a payload with a particular action type.

	#### Dispatcher

	- The Dispatcher has the following primary API: dispatch(), register(), waitFor().
	- The Dispatcher manage dependencies between stores by invoking the registered callbacks in a specific order. Stores can declaratively `waitFor()` other stores to finish updating, and then update themselves accordingly.
	- The arguments for `waitFor()` are an array of dispatcher registry indexes, which is referred to as each store's `dispatchToken`. When `waitFor()` is encountered in a callback, it tells the Dispatcher to invoke the callbacks for the required stores. After these callbacks complete, the original callback can continue to execute. Thus the store that is invoking `waitFor()` can depend on the state of another store to inform how it should update its own state.
	- In a Flux app there should only be one **singleton** Dispatcher. All data flows through this central hub. Having a singleton Dispatcher allows it to manage all Stores. This becomes important when you need Store #1 update itself, and then have Store #2 update itself based on both the Action and on the state of Store #1. Flux assumes this situation is an eventuality in a large application. This also makes debugging easy because it just requires a single `console.log` in the dispatcher to observe every single state change trigger.

- This structure allows us to reason easily about our application in a way that is reminiscent of functional reactive programming, or more specifically data-flow programming or flow-based programming, where data flows through the application in a single direction — there are no two-way bindings. Application state is maintained only in the stores, allowing the different parts of the application to remain highly decoupled. Where dependencies do occur between stores, they are kept in a strict hierarchy, with synchronous updates managed by the dispatcher.


## Flux Best Practices

- "Uncaught Error: Invariant Violation: Dispatch.dispatch(...): Cannot dispatch in the middle of a dispatch."
	- "No actions can be dispatched until the current action is fully processed by the stores."
	- [Cannot dispatch in the middle of a dispatch](https://groups.google.com/forum/#!topic/reactjs/mVbO3H1rICw)
	- [What is "flux"?](https://groups.google.com/forum/#!topic/reactjs/mo0RWkg68vU)

	- The stores themselves emit updates to their registered listeners during the course of a dispatch - rather than at the end (in the Promise.all of the dispatcher).
	- What we try to avoid is having another action go through the dispatcher as a result of the stores processing an action. **Emitting updates to the registered listeners is fine assuming that the views just re-render as the result of consuming that update, and doesn't try to add another action to the loop**. In practice, that assumption is enforced by the dispatcher so that an error is thrown if the views did try to do something like that.
	- On a related note, we make use of React's batched updates to make this efficient, since the emit can happen at any time, but React can make sure that the view updates only happen at the end of the cycle.

	- Q: We are getting Uncaught Error: Invariant Violation: Dispatch.dispatch(...): Cannot dispatch in the middle of a dispatch.
		- Here is the sequence of events:
			1. Action A is dispatched.
			2. The store updates its internal state and emits the change message.
			3. A react component X receives the change message and updates its state (setState).
			4. The component renders and as part of that a new component Y is mounted.
			5. The new component Y needs data to display that isn't initially loaded so on `componentDidMount()` it calls action B's action creator.
			6. The action B creator both sends off to the server to get data (in a util function) and creates an action B (to say that data is loading - state we want on the store). That action B is dispatched and we get the above message.
		- **Component views can not send actions while they update, render and mount new components in response to store changes**. So it seems likely that at some point you can run into this situation unless **you constrain that no store change can result in another action being sent** and that only a user action can cause an action to be sent. This seems rather limiting.

		- A: At step 5: when the new component needs additional data, it first off an action creator. In the past, I've had components request data through the stores, where the stores will update the component (through subscriptions) once data is received from the server. The result from the server goes through the Dispatcher as an Action when it comes back, but that's asynchronous and wouldn't interfere with Action A. Actions fired from the client have just been user-initiated actions (like the result of clicking on a button), and actions from the server (as an initial data payload, the result of a data fetch, or a push update) are asynchronous.
		- It sounds like you want the action creator to update state in the store to indicate that data is loading - in my case, I just have the views show a loading indicator until its callback is called.

	- Using `defer()`
		- Using defer() to solve the dispatch-within-dispatch is a bit of a bandaid that just avoids the invariant without restructuring anything. If possible, I try to work around it using `waitFor()` and rethinking the way that data is split across different stores.

	- Q: In my app, I make two ajax calls to for one piece of data. How Flux goes about this?
		- <http://stackoverflow.com/questions/27947335/nesting-flux-data>
		- Instead of trying to fire off an action in response to another action , back up and respond to the original action. If you don't yet have a complete set of data, and you need to make two calls to the server, **wait to fire the action until you have all the data you need to make a complete update to the system**. **Fire off the second call in the XHR success handler**, not in the view component. This way your XHR calls are independent of the dispatch cycle and you have moved application logic out of the view and into an area where it's more appropriately encapsulated.
		- If you really want to update the app after the first call, then you can dispatch an action in the XHR success handler before making the second call.
		- Ideally, you would handle all of this in a single call, but I understand that sometimes that's not possible if the web API is not under your control.
		- **In a Flux app, one should not think of Actions as being things that can be chained together as a strict sequence of events. They should live independently of each other, and if you have the impulse to chain them, you probably need to back up and redesign how the app is responding to the original action**.


- I have a scenario where I feel like I need to dispatch an action in response to another action, and I don't know the best way to sort it out.
	- <http://stackoverflow.com/questions/26934953/dispatching-further-actions-when-handling-actions/27569490#27569490>
	- You should look back how you are trying to create this flow. You say that you need to create an action in response to another action, right? So, let's name this the "ActionForwarderStore". We end up with a flow like this:

		```
    AuthAction --> Dispatcher --+--> UserStore
                                |
                                +--> ActionForwarderStore --+
                                                            |
               +--------------------------------------------+
               |
               +-> Dispatcher -----> RouteStore
		```
	- You see that you still have someone that understands that a `action1` should end up changing a route? This is the `ActionForwarderStore`. As Flux suggests that every Store listens to every Action, this knowledge of the `action1` ending up in a route change can go straight into `RouteStore`. Like this:

		```
    AuthAction --> Dispatcher --+--> UserStore
                                |
                                +--> RouteStore
		```
	- Remember that Flux was "created" in order to avoid the unpredictability of MVC. If you keep all your route changes into `RouteStore`, you just need to look at this Store code to understand what Actions will cause a route change. If you go in the way of creating an action in response to another action, you will only know that `NavigateAction` changes routes, and you will need to look at the other Stores to check which ones are triggering this Action in response to others.
	- This is what Flux names as "unidirectional flow". It's easy to catch problems this way because this is the only flow allowed. If you click a button and it changes the route, you can know for sure that the action that the click dispatched is causing the route change, there are no cascading actions.




- Asynchronous operations:
	- [How do you manage asynchronous Store operations with Flux?](http://stackoverflow.com/questions/23635964/how-do-you-manage-asynchronous-store-operations-with-flux)
	- Asynchronous actions that rely on Ajax, etc. shouldn't block the action from being dispatched to all subscribers.
	- You'll have a separate action for the user action, like `TODO_UPDATE_TEXT` in the TodoMVC example and one that gets called when the server returns, something like `TODO_UPDATE_TEXT_COMPLETED` (or maybe just something more generic like `TODO_UPDATE_COMPLETED` that contains a new copy of the latest attributes).
	- In cases where you want to do optimistic updates to show the user the effects of their change immediately, you can update the store in response to the user action immediately (and then once again when the server returns with the authoritative data). If you want to wait on the server, you can have the store only update itself in response to the server-triggered actions
	- Suppose the update fails and the server returns an error message that you'd like to display. In the `TODO_UPDATE_FAILED` handler, would you save the error message in the todo store?
	- You should create a seperate data store for error messages that in turn will be used by components that handles error messages (such as a alert message component).

- Writes versus Reads
	- For writes, issue an action with a payload of the data, but for reads call a store directly and that might trigger actions to fetch the data.

- How to call a Web API from stores?

	- Call the WebAPIUtils from the store, instead of from the ActionCreators. This is fine as long as the response calls another ActionCreator, and is not handled by setting new data directly on the store. The important thing is for new data to originate with an action. It matters more how data enters the system than how data exits the system.
	- <http://stackoverflow.com/questions/26295898/flux-architecture-misunderstanding-in-example-chat-app>
	- There is no action to fetch data. We don’t have any action type that’s like fetch messages or anything like that. The store takes care of all the fetching for you. It might be doing it from a cache. It might be actually contacting the server. It might be making multiple server calls just to get the data you need.

- Flushing stores on routing / page change
	- <http://stackoverflow.com/questions/23591325/in-flux-architecture-how-do-you-manage-store-lifecycle)>
	- When we move from pseudo-page to pseudo-page, we want to reinitialize the state of the store to reflect the new state. We might also want to cache the previous state in localStorage as an optimization for moving back and forth between pseudo-pages, but my inclination would be to set up a `PageStore` that waits for all other stores, manages the relationship with localStorage for all the stores on the pseudo-page, and then updates its own state. Note that this PageStore would store nothing about something in the domain of a regular Store. It would simply know whether a particular pseudo-page has been cached or not, because pseudo-pages are its domain.
	- The regular Store would have an `initialize()` method. This method would always clear the old state, even if this is the first initialization, and then create the state based on the data it received through the Action, via the Dispatcher. Moving from one pseudo-page to another would probably involve a PAGE_UPDATE action, which would trigger the invocation of initialize(). There are details to work out around **retrieving data from the local cache, retrieving data from the server, optimistic rendering and XHR error states**, but this is the general idea.
	- If a particular pseudo-page does not need all the Stores in the application, I'm not entirely sure there is any reason to destroy the unused ones, other than memory constraints. But stores don't typically consume a great deal of memory. You just need to make sure to remove the event listeners in the Controller-Views you are destroying. This is done in React's `componentWillUnmount()` method.

- When a non-logged in visitor attempts an action that requires he/she to be logged in, what is the Flux way of (a) checking if a user is logged in, (b) starting the login flow, (c) finishing the action on success?
	- You'd want to just check that the user has a valid session before creating a comment by first retrieving that value from the SessionStore:

	```js
	case CommentConstants.ADD_COMMENT:
		if (SessionStore.getUser()) {
			createComment(action.data);
		}
		break;
	```
	- But to preserve the comment so that it gets created after the user logs in, I would create a collection of pending comments in the CommentStore, and then later, in a callback to the login verification and session creation, dispatch a new action to inform the CommentStore that the user has now logged in. Then the CommentStore can respond to that by creating real comments out of the pending ones.
	- <http://stackoverflow.com/questions/26328949/react-flux-way-to-handle-permission-sensitive-actions-with-login-flows>


- How to handle UI state?
	- [No Fit State: Managing UI state in Flux](http://www.thomasboyt.com/2014/09/15/no-fit-state.html)
	- Imagine that you have a modal that allows a user to make a new post in a feed. Since you're using React, you implement this with a parent component that has a single state boolean (`postEditorIsOpen`) that determines whether modal is open or not. When a user opens the modal, this is set to `true`, and the view is re-rendered.
	- Now, imagine the user writes a post and clicks submit. This triggers an action in Flux that submits the post via an AJAX request. The request comes back a success, and the success callback triggers an event that the FeedStore is listening for, indicating the post was made and to insert it into the local feed cache.
	- The data is now updated, and everything's fine so far, but our modal is still open. But how do we close this modal in the Flux architecture?
	- Solution A: Embrace global state
		- The most "Flux-ish" way to do this would be to actually move the `postEditorIsOpen` boolean from the component's state into the store's state.
		- This would require two changes:
		- Adding an action for when the user requests the modal to open (clicking "new post") that will trigger an event listened to by the store that will set `postEditorIsOpen` to true in the store's state.
		- The post success handler in the store would update postEditorIsOpen to false before emitting the change event.
		- This pattern - moving UI state out of a component's state into the store - is immediately attractive, because it seems relatively easy to adapt view code to use, and it also allows us to stay within the bounds of Flux's data flow.
		- However, global UI state is dangerous (which is, in fact, one of the problems React tries to solve). Remember that stores are global singletons. In a single page app, if you navigate away from a page that uses a store and then return to it, the store's state will be the same as when you left it. Thus, if you leave the page with the modal open and return to it later, the modal would once again be open without the user prompting for it!
		- This can be solved by manually managing your global state - i.e., resetting the UI state in your store when the component is removed from the page. This is tricky and easy to forget or mess up, though.
	- Solution B: Add a new channel of communication
		- The other option is to add another binding between the view and the store that will allow for arbitrary events to be listened to, rather than just the single change event. The way you do this likely depends on your Flux implementation:
		- Fluxxor uses EventEmitter as a mixin on its store objects, so you can emit and listen for arbitrary events out of the box.
		- Reflux uses event-emitting Action objects instead of a central dispatcher. Your components can bind listeners onto events emitted by these Actions, just like stores would.
		- In either case, you'd register listeners in your `componentWillMount` hook and deregister them in `componentWillUnmount`, like you would for any other event. These listeners could then update the component's internal state: for example, the post modal would set `this.state.postEdtiorIsOpen` to `false` in its callback.
	- Neither of these solutions are ideal - one requires too much global state, while the other requires going around Flux entirely.


- When should you store something in `state`, versus in a `prop`/`store`?
	- If you follow the React way and render everything top-down, you often don't need state. Its definitely easier to 'go with the flow'.
	- We want to get rid of as much state from our React components as possible, and to move that state into the stores. **So every time you find yourself keeping state in your components, ask yourself: "Can I move this state into the stores?"**. After thinking about it a bit, you'll find that this is possible, and it actually cleans up your code quite a bit.
	- The only exception to this rule is state that is 100% internal to the component, and even this is often something that can be put in stores. As an example, text input components are an example of this kind of component.
	- This approach maintains the proper data flow, and as soon as you want to do something else with the shared state, like display related information in a table off to the side in a different column, you are looking at a significant refactoring. If you stick with the Flux pattern, you will have an easier time down the road. You will know where all the state is being maintained, how it gets updated, etc. Six months from now you will be able to open this app up again and know where everything lives. **Putting the state in React components makes them less reusable, harder to reason about, more tightly coupled to each other and their specific context**.
	- What about trivial or ephemeral type of state such as the expanded state on a flyout menu?
		- There is a tendency with Flux for this ephemeral type of state to also get pushed into the store. Its often difficult to separate this from the pure 'domain model' state - its easier to keep it in one place. i.e. keep certain kinds of UI-centric bits of state in its own dedicated UI store.
	- **Pure data transformations** shouldn't be state; they should be part of the render cascade or in store.
	- [Unclear on Flux best practices. Thoughts?](https://groups.google.com/forum/?utm_medium=email&utm_source=footer#!msg/reactjs/8uu8_UZjJWs/eiqTFZQ4wZ0J)
	- [ViewController state effectively a mirror of store contents](https://github.com/facebook/flux/issues/55#event-176149848)


- When should parent-to-child callbacks be used, versus the child calling the dispatcher in order to affect the parent?
	- Lots of branch-to-root callback propagation seems like it bypasses the dispatcher (backwards data flow) so it seems anti-flux.
	- Flux eliminates the need for most callbacks, particularly if you are comfortable with handling ephemeral UI state in the store.
	- Too much chaining of callbacks from child to parent clutters the code.
	- There should be a divide between UI components and application components. In the case of generic UI components, say a treeview or autocompletion widget, callbacks feel like the right way to go about things.
	- Generic, re-usable components can and should receive callbacks from their parents, since they're app-agnostic and don't really participate directly in flux.
	- The generic widgets pass a message up to the application level, which can then dispatch the appropriate action.
	- [Unclear on Flux best practices. Thoughts?](https://groups.google.com/forum/?utm_medium=email&utm_source=footer#!msg/reactjs/8uu8_UZjJWs/eiqTFZQ4wZ0J)
	- On which components should I place my actions? Do I need every component to work with actions? Or is it better to keep the actions in as few components as possible and pass callbacks to the children?
		- Think about some of your components as application specific "controllers" which will contain logic specific to your app, including calling actions, etc. These "controller" components are more logic heavy and produce very little output, usually just a div or something. Then the child components under the "controller" components would be built to be more generic so they can be reused across different projects and are not coupled tightly with my app, so for these generic components I would generally pass a callback because action names are likely specific to a specific application.
		- [flux actions vs props callbacks](https://groups.google.com/forum/?utm_medium=email&utm_source=footer#!msg/reactjs/mBiK-n9_SPY/SvKZ7bn8HlwJ)

- When should views render from `props`, versus rendering from data directly queried from stores?
	- TR - <http://stackoverflow.com/questions/26563933/passing-store-state-as-props-or-each-component-accessing-global-stores>
	- Seems like rendering from `props` is definitely the norm.
	- Not having data as props makes it impossible to compare next props with prev props in shouldComponentUpdate().
	- Use of `props` de-couples the views from the store.
	- `Props` can also be type checked.
	- However, long lists of `props` clutter the code.
	- Our rule of thumb is we query stores directly mainly in root-level components, use `props` mainly in branch-level components.
	- This root-level components are called 'controller-views' and they do pull data from the stores and pass that data to their children.
	- We are not really managing state in these controller-views. It's simply a convenient way to respond to the 'change' event and to get the data to the render method, allowing the render method to remain dedicated to rendering logic, instead of putting data fetching in there too. As long as you're not actually trying to manage state in the controller-view, there is nothing wrong with using `this.state` in this way. All the children below this controller-view will simply take the data in as `props`, and remain stateless.
	- Controller-views are views that layout other views and pass store data into them. Not places to try and keep consistent models.
	- When an individual component needs to manage it's own state (such as an input element) we do use `this.state` to do this. This is the one place in a Flux + React app where you do store state in a component that would otherwise be stateless. A significant difference here is that only this one component -- none of its children -- no other components -- need a reference to the component's state.
	- Shared state should always be in the stores and pass through the component hierarchy as `props`.
	- [Unclear on Flux best practices. Thoughts?](https://groups.google.com/forum/?utm_medium=email&utm_source=footer#!msg/reactjs/8uu8_UZjJWs/eiqTFZQ4wZ0J)
	- [ViewController state effectively a mirror of store contents](https://github.com/facebook/flux/issues/55#event-176149848)
	- TR - <https://www.youtube.com/watch?v=KYzlpRvWZ6c#t=1056>


- Routing

	- [Using the Navigation mixin in a Flux architecture versus the removed Router transition methods](https://github.com/rackt/react-router/issues/380)
	- [In Flux architecture, how do you manage client side routing / url states?](http://stackoverflow.com/questions/23624651/in-flux-architecture-how-do-you-manage-client-side-routing-url-states/23636491#23636491)
		- Way1: Let's say I have a component that creates a new post. I hit the create button and a component responds by firing off an action. I use Router.transitionTo in either the action or store layers when the action was successful.
		- Way2: Make the routing layer just another store. This means that all links that change the URL actually trigger an action through the dispatcher requesting that the route be updated. A RouteStore responded to this dispatch by setting the URL in the browser and setting some internal data (via route-recognizer) so that the views could query the new routing data upon the change event being fired from the store.

		```js
		var ApplicationView = React.createClass({
			mixins: [RoutingMixin],

			handleRouteChange: function(newUrl, fromHistory) {
				this.dispatcher.dispatch(RouteActions.changeUrl(newUrl, fromHistory));
			},
		});
		RouteStore.prototype.handleChangeUrl = function(href, skipHistory) {
			var route = results[0].handler(href, results[0].params);
			this.currentRoute = route;
			history.pushState(href, '', href);
			this.emit("change");
		}
		```
		- You should be doing it with way2 because component should know how to render themselves when the user actually lands on the new url.

	- React-Router
		- Nested Routes does correspond to nested URLs. React router gives you complete freedom and control about how your url look like. Just because you nest a Route does not mean you have to append another segment to the URL.

	- React-Router With Flux
		- <http://jaketrent.com/post/react-router-with-flux/>

			```js
			Router.run(function (Handler,state) {
				React.render(<Handler params={state.params} query={state.query} />, document.body);
				CoreViewActionCreators.changeRoute({Handler:Handler,state:state});
			});
			```
		- <https://github.com/rackt/react-router/blob/master/docs/guides/flux.md>

	- How can I pass data between routes without params using react-router?
		- http://stackoverflow.com/questions/28080102/react-router-passing-data-through-routes
		- The problem is that when the person refreshes, or in some other way directly loads the url, it needs to show the correct view. Because URLs are just strings, you need to represent the route as a string.
		- The job of a router is to take that string (the URL) and map it to the actual code (the handler), and provide any extra data (the params, query, and/or hash).
		- Your job as a router user is to ensure there's enough information in the URL for the router to pick the right handler, and for the handler to have enough information to do its job.

	- Why the react-router API uses JSX for configuration?
		- <https://groups.google.com/forum/?utm_medium=email&utm_source=footer#!msg/reactjs/RdpfIgW0aOY/PKYv3eammZYJ>
		- React-router uses JSX to describe how your routes are laid out because it's great for viewing a nested route hierarchy. But internally we just take those descriptors (called "elements" in React 0.12) and just use their props to create our own route objects that we use from that point forward. The router isn't "implemented" with elements. They're just used for config.
		- At its core, the router is all about describing a nested view hierarchy. In fact, we used to call it "react-nested-router". Nesting is the key thing that Ember figured out how to do correctly, which we copied when we created react-router.
		- I haven't actually seen another router that mentions nesting at all. This isn't a dig on other routers. I just haven't seen it. Most "routing" libraries out there do some simple pattern matching on the URL and then render one top-level component. This may work well for a router that lives in a server environment, where a full page is generated on each request. But in a browser environment you need a way to manage the state of your UI without blowing the whole thing away every time the URL changes. That's where the nesting comes in. And that's where JSX really shines for declaring the relationship of your views up front.
		- As for async transition resolution, just use `transition.wait`.


- How would du you manage caching / checking that the data already exists in the store?
	- Getters should be initiated from stores. So they know about existing data.


- Loading/Fetching State

	- The loading and saving state related an entity can be stored in Stores. Since View gets its initial state from Store, the only way to know whether its loading/saving comes from a Store.

- Showing server errors
	- <https://github.com/facebook/flux/issues/78>
	- I would render a PopupControllerView at the bottom of the body, in it's own React root, which would be listening to stores. It might have number of child popups, or I might create logic to dynamically create those children.
	- I might maintain a PopupStore, which would have currentPopupID value, which could be null. Down in my list of popup components, they would all receive currentPopupID as a prop, and if their popupID matched, they would get displayed.
	- Or I would simply let the values in the other stores drive what popup to render more directly, perhaps with some logic in PopupControllerView determining if a popup should be displayed, or which one.
	- Basically this is all just Flux + React -- nothing special going on, other than creating a separate root for it, and I'm not even sure that's necessary. The generic Popup React component could be made to simply take props and let the store or controller-view above it determine those props. You could then use that generic component to compose various different popups

- Showing client errors

- Showing confirmation

- Validation
	- <https://github.com/facebook/flux/issues/2>
		- I would create a utility library like `FooValidationUtils.js` that could determine whether the input was valid based on data passed into the React component - and I would pass down whatever data was required to judge the validity of the input. This would encapsulate the logic required for validation.
		- The Utils modules should not have dependencies on Stores, so that they can be used in any context - any part of the system, view or store, can invoke these utility methods. The methods should be stateless and pure, in the functional sense. So then you could do view-level validation and store-level `invariant()` enforcement with the same Utils functions. Unit testing these is easy and straightforward.
		- Also, if the individual form input components need to be reused, but have different validation logic in different contexts, you will want to pass event handlers to them as `props`, allowing the parent components to define how the validation should be done.
		- If the amount of data required to determine validity is really quite large and complex, and thus difficult to pass down through the component tree (which I'm having a little trouble imagining), then I might consider storing the validation state in the `FooStore` itself (maintaining a `formErrors` object), or a `FormStore` or an `ErrorStore`.
		- But this seems like it isn't ideal for most validation. Form inputs are, after all, one of the few places where maintaining state in the React component is a good thing, and it seems appropriate to perform validation on that state before creating a new Action.
		- Moving validation to the stores makes more sense to me if you want to create a UI where the user is free to put the stored data into an invalid state, and work with the UI in that invalid state for a while. For example, an image picker where the user must pick a minimum of 5 images. But it's okay for them to have 3 images picked while they are browsing images, with the save button grayed out. Then your controller-views would call `FooStore.hasEnoughImages()` in the handler for the Store's change event to get that boolean flag.
	- <https://groups.google.com/forum/?utm_medium=email&utm_source=footer#!msg/reactjs/OQ9wSws0eyY/qZ0B4Ixd5MoJ>
		- I keep my form state in the stores and the library I'm using forces async validations. Where to do form validation in React + Flux?
		- When you had new data to validate you'd just fire off your validations from within the store which sets `store.isValidating = true` and then when finished it emits a change so views know to update.
		- Your views would then simply have the logic to work around `store.isValidating()` and `store.isValid()` for display validations appropiately.
		- This approach seems to keep it quite stateful? Only downside at the moment I see is if you had a second store that cared when the first store was validated. But simply listening to change events on the first store might solve this?


- Editing form data that can be cancelled:
	- Q: Should intermediate form values be stored in views' states rather then sent to store?
	- A: Your input fields should have their own memory. That means that Store state (source of truth) is immutably decoupled from any changes that happen in components. Through actions, those changes are communicated to the Stores. Whether they become the new truth or fail with errors, the Store state will again be immutably copied to the component input state.

- Why Facebook uses constants for action types instead of string:
	- For minification. Optimisers can substitute a smaller identifier for a constant, but have to leave strings as they are.
	- Static analysis tools can more easily find usages and catch errors.
	- They can help serve as documentation. If all the action types that your application generates are defined centrally as constants, it becomes easier to tell at-a-glance what kinds of operations the system as a whole responds to.
	- <http://stackoverflow.com/questions/27109652/why-do-flux-architecture-examples-use-constants-for-action-types-instead-of-stri/27109765#27109765>

		```js
		var keyMirror = require('react/lib/keyMirror');

		module.exports = keyMirror({
		  TODO_CREATE: null,
		  TODO_COMPLETE: null,
		  TODO_DESTROY: null,
		  TODO_DESTROY_COMPLETED: null,
		  TODO_TOGGLE_COMPLETE_ALL: null,
		  TODO_UNDO_COMPLETE: null,
		  TODO_UPDATE_TEXT: null
		});
		// keyMirror:
		// Input:  {key1: val1, key2: val2}
		// Output: {key1: key1, key2: key2}
		```


- <http://stackoverflow.com/questions/26593732/unit-conversions-permissions-and-other-transforms-in-flux-react>
	- Where do behaviors like unit conversions (for display & input), permissions checks, and other presentation related transforms like applying user layout settings to a view. (for example, a user can define what data fields to see in a summary view, and in which order to see those) belong in a Flux architecture?
		- If your transformations are "pure" functions, then they can live in a Utils module.
		- You could create a mixin for the view layer instead, sure. But I personally prefer static method Utils modules to mixins, because it makes it easier to understand where a method is defined.
		- As far as whether you should store the transformations, I think you probably should not, but this is probably something that needs to be decided on a case-by-case basis. This feels like tightly coupling your view and data layers, and they should probably operate more independently.

- Should I put logic into ActionCreators?
	- <https://github.com/facebook/flux/issues/86>
	- I have a scenario where an action is to be dispatched however I need to perform some logic dependent on the state of certain stores to determine what actions to dispatch. Should I put the logic in the ActionCreator?
		- You can put logic in an ActionCreator, but often there is a better design.
		- Is this in response to a user interaction with the UI?
		- If so, I would try to do as much logic as possible in the stores, perhaps utilizing Dispatcher.waitFor(), and pass those values down as props to the view. In an event handler, the view would only apply the user-driven variables against those precalculated values that were passed down, and then call the appropriate ActionCreator with the parameters it needs.
		- If this is in response to another action, I would back up and look at how I am handling that action. I would gather all the required information, again possibly with waitFor(), to "apply a route..." in response to that original action.


- Is triggering an action in the store bad practice?
	- <http://stackoverflow.com/questions/28203081/is-triggering-an-action-in-the-store-bad-practice>
	- In Flux architecture, the views should be the only ones triggering actions.


**References**

- [React and Flux: Building Applications with a Unidirectional Data Flow](https://www.youtube.com/watch?v=i__969noyAM#t=21)
- [Flux Overview](https://github.com/facebook/flux/tree/master/examples/flux-todomvc)
- [Egghead.io React:Flux Architecture Lessons](https://egghead.io/series/react-flux-architecture)
	- [eggheadio/egghead-react-flux-example](https://github.com/eggheadio/egghead-react-flux-example)
- [React and Flux Interview](http://ianobermiller.com/blog/2014/09/15/react-and-flux-interview/)
- [Avoiding Event Chains in Single Page Applications](http://www.code-experience.com/avoiding-event-chains-in-single-page-applications/)
- React Flux Routing
	- <http://jaketrent.com/post/react-router-with-flux/>
	- [rackt/react-router](https://github.com/rackt/react-router)
	- [flux architecture with react-router](https://groups.google.com/forum/#!topic/reactjs/sDEN6oOqksU)
	- [gaearon/flux-react-router-example](https://github.com/gaearon/flux-react-router-example)
	- [React router - Update URL hash without re-rendering page](http://stackoverflow.com/questions/26239154/react-router-update-url-hash-without-re-rendering-page)
