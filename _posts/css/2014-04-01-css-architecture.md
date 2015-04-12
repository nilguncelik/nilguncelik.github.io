---
title: CSS Architecture
author: NC
category: css
public: true
---

### Things to consider

- Semantics (readibility)
- Modularity (reusability, flexibility)
- Efficiency ( performance )
	- Performance of css selectors are not much of a problem.
	- But css has a huge impact on file size and HTTP requests. You should be worried about that side of performance effect of CSS instead of selector performance ( Nicole Sullivan ).

### Naming

#### Name your elements based on what they are rather than how they look.
	- eg. use .warning or .notification instead of .red
  - Your code will have more meaning and never go out of sync with your designs.


#### Do not name your elements based on content.

	```html
	div class="news"
	     h2 News h2
	     [news content]
	div
	```

	- The class name *news* doesn’t tell you anything that is not already obvious from the content.
	- It gives you no information about the architectural structure of the component, and it cannot be used with content that isn't *news*.

#### Name your elements using repeating **structural and functional patterns** in a design.

- [About HTML semantics and front end architecture - Nicolas Gallagher](http://nicolasgallagher.com/about-html-semantics-front-end-architecture/)
- [Naming conventions - Necolas Gallagher](https://gist.github.com/necolas/1309546)
- [BEM style naming](http://bem.info/)


### Be DRY

- *Each property/value pair should be defined only once.*
- Group repeated css properties together and then add selectors to these groups.
- Very maintainable.
- Following code:

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

### Do not rely on parent selectors - use namespaces instead

+ They lower the specificity of child elements.
+ Use namespaces instead as a modifier to extend or change a class selector.
+ Namespaces in classes keep components self-contained and modular. They can be used anywhere.
+ Namespaces are easier to reuse, and harder to create hacky combinations and overrides.
+ This namespace approach is very similar to subclass approach of smacss.


```css
.sidebar{
}
.sidebar .title{
}
```

instead:

```css
.sidebar{
}
.sidebar-title{
}
```


```css
.sidebar{
}
#main-footer .title{
}
```

instead:

```css
.sidebar{
}
.main-footer-title{
}
```

### Dont rely on universal selector *
### Dont rely on tag (element) selectors:

+ They are not reusable and performant.
+ can be easily overridden
+ Use classnames instead.


### important!

- If you have to use it, document your use of !important.

### Object Orientated Cascading Style Sheets (OOCSS)

+ Proposed by [Nicole Sullivan](http://www.slideshare.net/stubbornella/object-oriented-css).
+ Don’t *lock* styles to a particular element. Where possible pull them out so they can be re-usable.
+ Where a noticeable design pattern is repeated more than once it’s probably a good candidate for abstracting in an OOCSS style.
+ The aim of a object-oriented architecture is to be able to develop a limited number of reusable components that can contain a range of different content types.
+ The important thing for class name semantics is that they be driven by pragmatism and best serve their primary purpose - providing meaningful, flexible, and reusable presentational/behavioural hooks for developers to use.

#### Reusable and combinable components

+ Scalable HTML/CSS rely on classes to allow for the creation of reusable components. *A flexible and reusable component is one which neither relies on existing within a certain part of the DOM tree, nor requires the use of specific element types. It should be able to adapt to different containers and be easily themed*.

+ The following example prevents the easy combination of the ```btn``` component with the ```uilist``` component as specificity of ```.btn``` is less than that of ```.uilist a```:

```css
.btn { /* styles */ }
.uilist { /* styles */ }
.uilist a { /* styles */ }
```

Solution : use classes to style the child DOM elements.

```css
.btn { /* styles */ }
.uilist { /* styles */ }
.uilist-item { /* styles */ }
```

+ The "object" is a repeating visual pattern.
+ Visual patterns are abstracted into independent CSS "modules".
+ The modules can be re-used anywhere in our site by assigning them to HTML elements.

+ We need to think of style patterns instead of just styling individual HTML elements.
+ Also we need to think of our website as these code independent components that can be rearranged without affecting surrounding components.

+ OOCSS has 2 main concepts:
	+ Separation of structure from appearance.
  		1. Abstract repeating visual patterns into separate skins that are reusable.
    	2. Name the skin classes logically.
    	3. Add classes to HTML elements.
	+ Separation of containers and content.
    	+ Avoid location dependent styles.
    	+ CSS should be tied up to the HTML or a location in the document.
    	+ Modules should be able to adapt to different containers and be easily themed.
    	+ All elements with the given classes should look the same no matter what.

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
```

should be rewritten as:

```css
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
and add global-width class to the elements with  .header-inner, .main-content, .footer-inner classes.

+ Results in smaller css files that are easier to maintain and scale.
+ Css is predictable.
+ Creating new pages will require very little to no css coding.


- `button strong span .callout` can be written as  `button .callout` -- this way you can move `.callout` around more easily in the future and it's not tightly coupled with the DOM tree.

- `div.content` can be written as `.content`.

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
```

- Assume search-box component needs to be modified to use in the footer or sidebar sections. Instead of creating descendant selectors, create subclasses that contain modified styles.

```css
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

### IDs vs Classes

+ Even though IDs are more efficient than classes, the difference is extremely small, so opt for classes when you can. vid
+ IDs as best to use as JS hooks or as fragment identifiers (for url hash and href attribute) in a page.
+ They are vey heavy in specificity and and cannot be reused.
+ Classes are more flexible for reuse.

+ Avoid using the same class or ID for Css styling and JS. Keep those layers separate.
     + Prefix js classes with js-.
     + Decouples presentation classes with functional classes.
     + Reduces the chances of affecting JS behaviour when making theme or structural changes in the CSS.


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


### Falling back

+ Develop with progressive enhancement in mind.
+ Start with a basic working example, an experience all browsers will be able to provide.
+ add enhancement layers one by one.
+ start with semantic, well structured markup, then add the css layer, followed by the JS layer.
+ This minimises the dependency on CSS3 features and doesn’t sacrifice accessibility for convenience.
+ Use feature detection as a last resort.
+ Modernizr
     + Tests for 40 features in a matter of milliseconds
     + But still, create a custom build to include only the features you will need.
     + Modernizr places classes on the root <html> element specifying whether features are supported. Bleeding edge styles can then easily cascade from (or be removed from) these classes.

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

+ Don’t use universal selector `*`.
+ no control over which elements are reset.
+ Inheritance is lost in css values ? Then we have to write a lot of extra css to define a property for both the parent and the child.
+ Slows down page load time - browser has to run through every element to apply the properties.

+ Eric Meyer Reset css 2.0
	+ We don’t need the entire reset. - just the attributes we are using.
+ Normalize.css
	+ preserves useful default styles - we do not need to redeclare styles for common elements.

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
