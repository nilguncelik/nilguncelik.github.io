---
title: CSS Best Practices
author: NC
category: css
public: true
---

- While starting a new project break the design into components.
- Find similarities and differences between components.
	- Where can i use `nav` element?
		- top menu, tab menu, links widget, social buttons
	- Where can i use `button` class?
		- Tickets sold out, start and subscribe buttons.
		- What do these buttons have in common?
			- color, alignment, font, border.
		- Then I can have classes like button, button-primary, button-secondary, button-ternary.
	- Where can I use a widget structure?
		- HTML Mag News, Resources and Try Yourself boxes.
		- Try Yourself box = widget-banner = widget + red background + white color.
![](/img/css_design.jpg)

1- Naming

- Do not name your elements based on how they look.
	- eg. instead of `.red` use `.warning` or `.notification`
	- Your code will have more meaning and never go out of sync with your designs.
- Do not name your elements based on content.

	```html
	<div class="news">
	     <h2> News </h2>
	     [news content]
	</div>
	```

	- The class name *news* gives you no information about the architectural structure of the component, and it cannot be used with content that isn't *news*.

- Name your elements using repeating **functional patterns** in a design.
	- What functionality does the class provide? ex. widget, btn
	- What additional features does the class provide? ex. btn-secondary
	- What state does the element have? ex. hidden, error

- [BEM style naming](http://bem.info/) (Yandex 2011)
	- Block Element Modifiers
	- widget, widget__element, widget--modifier
	- Makes it easy to understand the relation between the element and the class.

	```html
	<nav class=“navigation navigation--main”>
		<a href=“#” class=“navigation__item navigation__item--main”>…</a>
		<a href=“#” class=“navigatio__item”>…</a>
		<a href=“#” class=“navigation__item”>…</a>
	</nav>
```

- [About HTML semantics and front end architecture - Nicolas Gallagher](http://nicolasgallagher.com/about-html-semantics-front-end-architecture/)
- [Naming conventions - Necolas Gallagher](https://gist.github.com/necolas/1309546)


2- Don't repeat yourself

- Try not to repeat property/value pairs.
- Group repeated css properties together and then add selectors to these groups.

	```css
	.button {
	    display: inline-block;
	    padding: 5px;
	    border-radius: 12px;
	}
	.field{
	    display: inline-block;
	    padding: 5px;
	    border-radius: 12px;
	}

	.column{
			float: left;
	    padding: 5px;
	    border-radius: 12px;
	}
	```

	can be re-written as:

	```css
	.button , .field, .column {
	    padding: 5px;
	    border-radius: 12px;
	}
	.button, .field {
	    display: inline-block;
	}
	.column{
	    float: left;
	}
	```

- Where a noticeable design pattern is repeated more than once it’s probably a good candidate for abstracting in an OOCSS style / component.

	```css
	.header-inner, .main-content, .footer-inner{
	     position: relative;
	     margin: 0 auto;
	     padding: 15px;
	     width: 90%;
	}
	.header-inner{
	     height: 150px;
	}

	// can be rewritten as:
	// (add global-width class to the elements with  header-inner, main-content, footer-inner classes)

	.global-width{
	     position: relative;
	     margin: 0 auto;
	     padding: 15px;
	     width: 90%;
	}
	.header-inner{
	     height: 150px;
	}
	```

3- Have low specificity, don't assume a specific DOM hierarchy, use namespaces

- Selector trains:

	```css
	.nav ul li a span {
	}
	// instead
	.nav span {
	}
	```

- The larger number of selectors are, the harder it is to reuse later.

	```css
	button strong span .callout {
	}
	// instead
	button .callout {  // you can move `.callout` around more easily and it's not tightly coupled with the DOM tree.
	}
	```

- The larger number of selectors are, the higher specificity you have i.e. the harder it is to override them later.

	- The following example prevents the easy combination of the `.btn` component with the `.uilist` component as specificity of `.btn` is less than that of `.uilist a`:

	```css
	.btn { /* styles */ }
	.uilist { /* styles */ }
	.uilist a { /* styles */ }

	// instead, use classes to style the child DOM elements.

	.btn { /* styles */ }
	.uilist { /* styles */ }
	.uilist-item { /* styles */ }
	```

- Namespaces:
	- you can use them to extend or change a class selector.
	- they keep components self-contained and modular.
	- they are easier to reuse, and harder to create hacky combinations and overrides.



4 - Don't require use of specific element types

- Don't rely on tag (element) selectors.
- They are not reusable and performant.
- Can be easily overridden.
- Use classes instead.

	```css
	div.content{
	}
	// instead
	.content{
	}
	```


5 - Follow single responsibility principle

- Every class should be defined for a single job and should be used only for that job.
- We don't want a swiss knife.
- Different classes can be used together. ( having up to 3-4 for classes for a single element is ok.)


6 - Don't break other classes functionality

7 - Be adaptable to different containers

8 - Decouple layout from your components

9 - Decouple theming from your components

10 - Universal selector *

- Don't rely on universal selector.
- It is not performant.

11 - `important!`

- If you have to use it, document your use of `!important`.


## OOCSS ( Object Orientated Cascading Style Sheets )

- [Proposed by Nicole Sullivan](http://www.slideshare.net/stubbornella/object-oriented-css).
- The aim of a object-oriented architecture is to be able to develop a limited number of reusable components that can contain a range of different content types.
- The "object" is a repeating visual pattern.
- Visual patterns are abstracted into independent CSS "modules".
- The modules can be re-used anywhere in your site by assigning them to HTML elements.

- We need to think of style patterns instead of just styling individual HTML elements.
- Also we need to think of our website as these code independent components that can be rearranged without affecting surrounding components.

- OOCSS has 2 main concepts:
	- Separation of structure from appearance.
  		1. Abstract repeating visual patterns into separate skins that are reusable.
    	2. Name the skin classes logically.
    	3. Add classes to HTML elements.
	- Separation of containers and content.
    	- Avoid location dependent styles.
    	- CSS should be tied up to the HTML or a location in the document.
    	- Modules should be able to adapt to different containers and be easily themed.
    	- All elements with the given classes should look the same no matter what.

- Results in smaller css files that are easier to maintain and scale.
- Creating new pages will require very little to no css coding.


### Scalable and Modular Architecture For CSS (SMACSS)

+ [SMACSS](http://www.smacss.com)
+ Similar to OOCSS, combines repeating CSS patterns into reusable components.
+ Components are separated into 5 categories:


1. **Base Rules**
     + Rules that can be used as CSS reset.
     + They are applied on the element selectors not classes or IDs.
2. **Layout Rules**
     + Divide page into major components: header, main, footer, sidebar, grid etc.
     + These components can contain one or more modules.
3. **Module Rules**
     + Reusable modular components - minor components.
     + Each module should exist as a standalone component and can be easily moved throughout the layout without breaking it.
     + Avoid using id and element selectors - just use class names.
     + Subclassing
          + If we need to change the look of a module to use in other parts of the site, subclass it.
          + Avoid creating new, conditional style based on location.

	```css
	.search-box{
	     padding:10px;
	     min-weight: 150px;
	     width: 200px;
	}

	// Assume search-box component needs to be modified to be used in the footer or sidebar sections.
	// Instead of creating descendant selectors, create subclasses that contain modified styles.

	.search-box{
	     padding:10px;
	     min-weight: 150px;
	     width: 200px;
	}
	.search-box-sidebar{
	      width: 80%;
	}
	```

4. **State Rules**
    + Define how modules look when they are in a particular state.
    + ex. collapse, expanded, success, error, hover, active, hidden, transparent,
    + Augment or override other styles.
    + They can also be used with pseudo-classes, media-queries or javascript.
5. **Theme Rules**
    + Define color scheme or typography.
    + Separate themes into their own set of styles so that they are easier to modify.

+ Thinking about your interface not only modularly but as a representation of those modules in various states will make it easier to separate styles appropriately and build sites that are easier to maintain.


### Scalable FrontEnd Architecture

- <https://github.com/bcinarli/scalable-frontend-architecture>
- Pyramid structure from general to more specific
	- settings(for sass, color codes, variables)
	- tools(mixins and functions)
	- global ( ex. normalize css, reset, body, \*)
		- box-sizing : border-table
	- layout ( page, wrapper, header, footer, single column, multi-column )
		- page-wrap has relative positioning so that I can easily absolutely set other elements relative to it.
	- elements ( a, table, h1 , styling for elements without classes )
		- a elements have default padding for mobile screens.
	- components (menu, widget, media, main-navigation, main-navigation links)
	- auxilary ( is-error, is-hidden)


### IDs vs Classes

+ Even though IDs are more efficient than classes, the difference is extremely small, so opt for classes when you can.
+ IDs as best to use as JS hooks or as fragment identifiers (for url hash and href attribute) in a page.
+ They are vey heavy in specificity and and cannot be reused.
+ Classes are more flexible for reuse.

+ Avoid using the same class or ID for Css styling and JS. Keep those layers separate.
     + Prefix js classes with js-.
     + Decouples presentation classes with functional classes.
     + Reduces the chances of affecting JS behavior when making theme or structural changes in the CSS.


### CSS Selector Performance

- The browser starts by matching the rightmost part of the selector against your element, then chances are it won't match and the browser is done. If it does match, the browser has to do more work, proportional to your tree depth.
- For example `h1 {}` is faster to evaluate than `div p{}` which has more number of selectors.
	- `h1`: match any `h1` tag.
	- `div p`: match any `p` tag, but then walk up the dom tree and only apply this rule if there is a `div` element as its parent.
- **The more specific a rule is the slower it takes to evaluate**.

### Document everything

- Whenever you add a new class or group of classes, leave comments to clarify what they're for, examples of where they're being used, etc. You want people to be able to read your CSS and understand your intentions, just as if you were writing in a programming language.

### Property Ordering

+ Properties should be divided into groups and arranged in a logical order.
+ CSS Comb
	+ sorts css properties.
  + Sublime Text editor has it as a plugin.

### Vendor Prefixes

+ caniuse.com, MDN
+ Add unprefixed properties last.
+ Prefixr: converts your css to cross browser compatible css.
+ Sublime Text and Coda have plugins for it.


### Divs and spans

+ Divitus: Using too many divs
	+ It is usually a sign that your code is poorly structured and overly complicated.
  + Divs should be used to group related items based on their meaning or function rather than their presentation or layout.
  + Use the new HTML5 elements when possible.
  + Unfortunately sometimes you cannot avoid adding an extra non semantic div or span to get the page to display the way you want.


### Having too many classes

- If you find yourself adding lots of extraneous classes to your document, it is probably a warning sign that your document is *not well structured*.
- Instead, think about how these elements differ from each other. Often, you will find that the only difference is where they appear on the page.
- Rather than give these elements different classes, think about applying a class or an ID to one of their ancestors, and then targeting them using a descendant selector.
- Removing extraneous classes will help simplify your code and reduce page weight. Over-reliance on class names is almost never necessary.


### Develop with progressive enhancement in mind

- Start with a basic working example, an experience all browsers will be able to provide.
- add enhancement layers one by one.
- start with semantic, well structured markup, then add the css layer, followed by the JS layer.
- This minimises the dependency on CSS3 features and doesn’t sacrifice accessibility for convenience.
- Use feature detection as a last resort.
- Modernizr
	- Tests for 40 features in a matter of milliseconds
	- But still, create a custom build to include only the features you will need.
 	- Modernizr places classes on the root <html> element specifying whether features are supported. Bleeding edge styles can then easily cascade from (or be removed from) these classes.

```css
.my_elem {
   -webkit-box-shadow: 0 1px 2px rgba(0,0,0,0.25);
   -moz-box-shadow: 0 1px 2px rgba(0,0,0,0.25);
   box-shadow: 0 1px 2px rgba(0,0,0,0.25);
}

/* when box shadow isn't supported, use borders instead */
.no-boxshadow .my_elem {
   border: 1px solid #666;
   border-bottom-width: 2px;
}
```

### Page Reset:

- Don’t use universal selector `*` for page reset.
- no control over which elements are reset.
- Inheritance is lost in css values ? Then we have to write a lot of extra css to define a property for both the parent and the child.
- Slows down page load time - browser has to run through every element to apply the properties.

- Eric Meyer Reset css 2.0
	- Removes all css. You will need to write your own styles thereafter.
- Normalize.css
	- Preserves useful default styles, makes all elements look similar on different browsers.

### CSS Coverage Report

- Helps identify unused CSS styles that can be safely removed.
	- Use Chrome or Firefox Dev Tools.
	- Firefox Dev Tools allows you to browse multiple pages and then spot unused css rules.



**References**

- [CSS Mastery: Advanced Web Standards Solutions](http://www.amazon.com/CSS-Mastery-Advanced-Standards-Solutions/dp/1430223979)
- [Lynda](http://www.lynda.com)
- [Treehouse](http://www.treehouse.com)
- [CSS Best Practices | Treehouse Workshop](https://www.youtube.com/watch?v=vQVvbwzM9YU )
- TR - [writing style sheets for rapidly changing, long-lived projects](http://benfrain.com/enduring-css-writing-style-sheets-rapidly-changing-long-lived-projects/)
- TR - [High-level advice and guidelines for writing sane, manageable, scalable CSS](http://cssguidelin.es/)
- TR - [Slaying the Dragon: Refactoring CSS for Maintainability](http://vimeo.com/100501790)
- TR - [Effortless Style](http://vimeo.com/101718785)
- <https://github.com/sezgi/CSS-Best-Practices>
- <https://speakerdeck.com/bcinarli/yonetilebilir-arayuz-mimarisi>
