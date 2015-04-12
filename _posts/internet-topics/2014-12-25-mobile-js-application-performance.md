---
title: Mobile JS Application Performance
author: NC
category: internet-topics
public: true
---

## Mobile Constraints

### Network

- Problems occurs not due to low bandwidth but due to latency:
	- Latency is high.
	- Latency is highly variable.

### Battery

#### Network requests

#### Javascript

#### Images

- Dont load images if they are not in the viewport.
- Avoid using images at all.

#### DOM

- Dont have more than 5000 nodes in an app.
- Dont have more than 12-15 level nesting.

### Memory

- All applications share less than 1gb of memory.

### Processing Power

- Mobile processors are not designed for speed but for producing less heat and spending less battery power.


## How to speed things up

- Although followings are general facts about optimizations you should be measuring, profiling your own application to come to a verdict that best fits in your case.


### Faster Networking

- Reduce number of HTTP requests. (batch requests)

- Use caching.
	- Abstract data access layer:
		- getUserProfile()
	- inside getUserProfile() first look at the cache. if not exists bring from the server and cache.
- Have an Offline Mode.

### Faster Rendering

- Avoid CSS shadows, gradients.
- Avoid animations
	- dont use js to animate, always use css.
	- css is gpu accelarated.
- Dont touch DOM.
	- slow and synch API.
	- even "reading" an elements attribute value like offsetTop or border, will result it layout calculations and will make it slow.
	- Cache accesses to DOM. Pu cached value into a variable and always use it.
	- To make manipulations detach a node make all the manipulations offline and re-attach.
	- Use settimeout to yield control to make ux smoother.
	- Use Chrome Dev Tools "continous repaint mode".
	- Jankiness
		- use requestAnimationFrame

### Faster Caching

- Use localStorage
- Use compression to overcome 5mb limit ( if you are targeting higher than jellybean and iphone4 )
- Abstract cache layer and have a single cache entry point.
- Use LRU Cache Eviction algorithm.
- To find out the size of your cache for eviction use `JSON.stringify(localStorage).length`.

### Faster Reaction

- Never block UI.
	- Do not run js while user is doing some kind of gesture ( swiping, zooming, scrolling)
	- Ajax responses blocks a bunch of things such as requestAnimationFrame loop and main ui thread.
	- For example in infinite scrolling lists when you come to the end of the list you try to scroll, application fetches the data try to put the data at the bottom of the list while the user still trying to scroll. Then the browser can freeze for a few second because it is trying to do too much ( browser is already doing rasterization, upload things to gpu, stash away and render back in things to respond to the gesture).

```js
function handleAjaxResponse(response){
	if(isUiInMotion){   // If the user is interactive than wait for the gesture to finish.
		delay(function(){
			handleAjaxResponse(res);
		}, 400);
		return;
	}

	handleAjaxResponse(res);
}
```

- Event handling
	- use event delegation
	- avoid frequent event attach and detaching for example before and after tap events.


### Faster Execution

- It is not js that should optimized but its interaction js with rendering layer.
- Having said that for js you can
	- delegate complex computational stuff to web workers.
	- reduce number of event handlers.
	- join stuff and get rid of objects.
- JS engines are getting better, you can go deep about what is in the background:
	- <https://developers.google.com/v8/design>
	- <http://wingolog.org/tags/v8>
- Frameworks
	- Normally you use a subset of the frameworks functionality, try to detect and chop off the parts you dont use.
	- Increase the memory consumption and memory footprint therefore makes your application slower.
- Memory leaks
	- A global reference to a detached node.
	- An event handler not being detached for ex in pub sub pattern.
	- A timer not being cleared.
	- A cached object not being evicted.
	- Closures.
	- Controller, Renderer, Manager, Provider, ..
	- Any object that touches DOM.
	- Any object that acts like a cache.
	- It is very hard do memory profiling.
		- Use Three Snapshot Technique <http://bit.ly/3snapshots>
- Reduce DOM Access
	- Think as if the ui thread is a node.js event loop.
	- Batch your DOM operations.
	- Yield as fast as you can.
- Web Workers
	- delegate complex computational stuff to web workers.
	- they are not free either.
- Do as little as possible
	- reduce js, reduce radio, reduce DOM.
- Give feedback and overestimate remaining time.
	- Instead of using progress bars use gradually increasing number of feedback elements to the user so that she feels stg is flowing.


### Profile, profile, profile


- Always measure, never assume.
- Always be testing
- Choose the tools that you’ll use.

- First, profile on a desktop browser to have an initial idea.
- Then, test on a real device!
- DO NOT trust simulator/emulator. Always test on a mobile network.

- Entropy Always Wins
	- Your app’s performance won’t stay the same unless you put more energy into it ( always measure! ).

**References**

- <https://www.youtube.com/watch?v=O5pz1M5CArE>
- <https://speakerdeck.com/volkan/the-secrets-of-high-performance-mobile-javascript-applications>
