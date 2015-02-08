---
title: Website Performance Optimization
author: NC
category: internet-topics
public: true
---

## Critical Rendering Path

- The sequence of steps that the browser goes through to convert HTML,CSS and Javascript into actual pixels on the screen.
- You should optimize **critical rendering path** to render pages faster.
	- DOM
	- CSSOM
	- Render Tree
	- Layout
	- Paint
- Javascript affects DOM & CSSOM.

### DOM: Document Object Model

- The browser
	1. Sends a request to the server.
	2. Receives a response.
	3. Receives data.
	4. Starts to parse html.
		- **Token**izes the characters.
		- Converts tokens into **node**s.
		- Builds **DOM tree** from the nodes.
		- DOM tree contains all HTML markup with nodes and their attributes.
		- Server may flush partial HTML to the browser and the browser starts to render as soon as it gets incoming HTML. This way, users start to see the content early which results in better user experience.

- Flushing the content:
	- Flushing is when the server sends the initial part of the HTML document to the client before the entire response is ready. All major browsers start parsing the partial response.
	- When done correctly, flushing results in a page that loads and feels faster.
	- The key is choosing the right point at which to flush the partial HTML document response. The flush should occur *before* the expensive parts of the back end work, such as database queries and web service calls. But the flush should occur *after* the initial response has enough content to keep the browser busy.
	- The part of the HTML document that is flushed should contain some resources as well as some visible content. If resources (e.g., stylesheets, external scripts, and images) are included, the browser gets an early start on its download work. If some visible content is included, the user receives feedback sooner that the page is loading.
	- <http://www.amazon.com/gp/product/0596522304>
	- <http://www.stevesouders.com/blog/2009/05/18/flushing-the-document-early/>


#### Optimizing DOM:

- Stream html to client as fast as possible.
- Remove comments and white space.
- Compress (with Gzip).
- Cache.



### CSSOM: CSS Object Model

- Unfortunately, CSSOM can not be constructed incrementally like the DOM. The browser can not render a partial CSSOM because that would cause it to use wrong styles to be rendered.
- The browser blocks page rendering until it receives and processes all of the CSS i.e. **CSS is render blocking**. Therefore it makes sense to inline critical CSS instead of making a separate request for it.
- The browser also **blocks script execution** until the CSS file arrives and gets parsed:

	```html
	<style src="style.css"/>
	<p>
		Awesome page
		<script>
			var e = document.getElementsByTagName("p")[0];
			e.style.color = "red";
		</script>
		is awesome
	</p>
	```
	- The parser starts to parse the file.
	- It parses the CSS style tag and sends a request.
	- The parser continues to parse and encounters the script tag. The parser does not know if the script will change CSS properties. Therefore it blocks script execution until the CSS file is received and parsed into CSSOM. Once this is finished, parser continues with the script execution.

- While matching CSS selectors with DOM, the browser starts from right to left.
	- <http://stackoverflow.com/questions/5797014/why-do-browsers-match-css-selectors-from-right-to-left>
	- The browser starts by matching the rightmost part of the selector against your element, then chances are it won't match and the browser is done. If it does match, the browser has to do more work, proportional to your tree depth.
	- For example `h1 {}` is faster to evaluate than `div p{}` which has more number of selectors.
		- `h1`: match any `h1` tag.
		- `div p`: match any `p` tag, but then walk up the dom tree and only apply this rule if there is a `div` element as its parent.
	- **The more specific a rule is the slower it takes to evaluate**.

- In the "Parse HTML" step in the Chrome DevTools Timeline, the browser parses the CSS file.
	- Send a request to server to retrieve the CSS file.
	- Receives response.
	- Receives data.
	- Converts the CSS response into the CSSOM.
	- Checkout how long this step takes to measure performance.

- Paul Irish advices to eliminate render blocking css and sticking CSS for above-the-fold content in a style tag in the head.
	- Note that this causes FOUC (flashes of unstyled content) for the unstyled content while the CSSOM is built.

- TR - [Authoring Critical Above-the-Fold CSS](http://css-tricks.com/authoring-critical-fold-css/)

	```js
	<script>
		var cb = function() {
			var l = document.createElement('link'); l.rel = 'stylesheet';
			l.href = 'small.css';
			var h = document.getElementsByTagName('head')[0]; h.parentNode.insertBefore(l, h);
		};
		var raf = requestAnimationFrame || mozRequestAnimationFrame || webkitRequestAnimationFrame || msRequestAnimationFrame;
		if (raf)
			raf(cb);
		else
			window.addEventListener('load', cb);
	</script>
	```

#### Optimizing CSSOM:
- Split CSS into multiple files and specify media query on `media` attribute of the `link` tag. If the media query is not valid the browser will not block rendering for the CSS file.
- Use inline CSS.
- Use inline CSS for the above-the-fold content and asynchronously fetch css with javascript.




### The Render Tree:

- Combines the DOM and the CSSOM:
	- Start at the root of the DOM tree and check if there is any CSS rules that match it.
	- Then copy the root node to the render tree alongside with its CSS properties.
	- Walk down the DOM tree.
	- If you see a node with CSS property `display:none` skip it and its children. (Render tree only captures visible content.)





### Layout

- Compares the position of every element and calculates its dimensions against the layout viewport.
- When you use `viewport` meta tag (`<meta  name=“viewport” content="width=device-width">`), you say that the width of the layout viewport should be equal to the device width.
	- i.e. if your device width is 320 pixels, the browser will set your `width:100%` CSS rule to be equal to 320 pixels.
	- If you don't use the `viewport` meta tag the default is assumed to be 980px typically.
	- If the dimensions of the layout viewport change ( for example when device orientation changes or window resizes ), the browser reruns the layout step.
	- Use batch updates to avoid multiple layout events.

- Any layout step that take less than 1ms are actually pretty fast.
- One 45ms layout event isn't going to be noticeable, but multiple 45ms layouts will make the website feel clunky and slow.



### Paint



### Javascript

- When the DOM parser encounters a script tag, it pauses the DOM construction and let Javascript execute before it can continue. Therefore JS is said to be **parser blocking**.
- If the JS script tag requires javascript code to be fetched from server, the parser can't continue constructing the DOM until the file is fetched and executed, which slows down the critical path.
- Use inline Javascript:
	- not recommended because js code cannot be re-used across pages.
	- Be aware that the script execution blocks on CSS fetch and CSSOM construction.
- Use async attribute on script tag:
	- JS won't block DOM construction.
	- TR - <https://developers.google.com/web/fundamentals/performance/critical-rendering-path/adding-interactivity-with-javascript#parser-blocking-vs-asynchronous-javascript>
- Defer javascript execution by loading script after the browser fires the `onload` event.
	- <https://developer.mozilla.org/en-US/docs/Web/API/GlobalEventHandlers.onload>
- Put script tag or inline js before the closing tag of body so that the parser can render the existing markup when the CSS file is received.

![](/img/js_execution.jpg)

#### Optimizing Javascript

- Minify JS files.
- Compress JS files.
- Cache JS files.
- Using `async` attribute.
- Defer javascript execution by loading script after the page is loaded.
- Put script tag before the closing tag of body.


### Critical Path Metrics:

- Number of critical resources.
- Total critical KB.
- Minimum critical path length (roundtrips) :
	- Minimum number of roundtrips assuming some files can be fetched in parallel.
	- If the size of the file is high, it may take multiple roundtrips to fetch one file.
	- ex. <https://www.youtube.com/watch?v=R_udjn0u3yM>


### Preload Scanner

- The browser has a special process called preload scanner which peaks ahead in the document and tries to discover critical CSS and javascript files.
- That way it is able to detect critical files early and send requests ahead while the parser is blocked for the first critical file.
- TR - <http://andydavies.me/blog/2013/10/22/how-the-browser-pre-loader-makes-pages-load-faster/>


### Rendering Gotchas

- HTML is fetched - possibly flushed.
- Parser starts to parse HTML to construct DOM and CSSDOM.
- If parser sees HTML it is added to DOM. DOM can be incrementally built.
- If parser sees inline CSS it is added to CSSDOM.
- If parser sees a CSS file to be fetched it sends a request and continues to parse.
- The browser can not start rendering (building render tree) until all CSS is fetched and CSSDOM is constructed.
	- What if DOM is partially constructed and the parser does not know if there is going to be a CSS next? Can it start partially rendering existing DOM? For example in this [video](https://www.youtube.com/watch?v=jw4tVn7CRcI) how does Google know that there is not going to be css for the header part when the second flush arrives?
		- //TODO Since css is in the header and the visible part is in the body, the parser already knows there wont be any css coming from server?
- If parser sees script tag (whether inline or requires fetching from remote server, but does not have `asych` or `defer` attributes)
	- If there is a CSS request pending, it waits till it is fetched and parsed before it can proceed.
	- Waits until JS is fetched and executed and only then it can proceed.
	- If script is marked as `asych` then parser continues to parse during js fetching. But pauses when the script arrives and waits for it to be executed.
		- What happend if CSS is not arrived when the script arrives. Can it be executed?
			- // TODO
	- If script is marked as `defer` then parser continues to parse. And js is executed after initial rendering done.


**References**


- <https://www.udacity.com/course/ud884>
- TR - [Chrome Timeline performance profiling](https://developer.chrome.com/devtools/docs/timeline)
- TR - [High-Performance Browser Networking - Ilya Grigorik](http://chimera.labs.oreilly.com/books/1230000000545/index.html)
- TR - <https://developers.google.com/web/fundamentals/>
- TR - <https://developers.google.com/web/starter-kit/>
- TR - <http://www.stubbornella.org/content/2009/03/27/reflows-repaints-css-performance-making-your-javascript-slow/>
- TR - <https://engineering.gosquared.com/optimising-60fps-everywhere-in-javascript>
