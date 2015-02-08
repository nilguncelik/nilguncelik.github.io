---
title: CSS Cascade, Specificity and Inheritance
author: NC
category: css
public: true
---

### Cascade

+ It is very likely that two or more rules will target the same element. CSS handles such conflicts through a process known as the **cascade**.

+ The cascade works in the following order of importance:
     +  Styles flagged as !important
     +  Inline Styles
     +  Styles in the <head> element
     +  External link styles
     +  Styles applied by the browser/user agent

+ Rules are then ordered by how specific the selector is.
+ If two rules are equally specific, the last one defined takes precedence.

### Specificity

+ The specificity of a rule is calculated by adding up the value of each of its selectors.
+ Specificity is not calculated in base 10 but a high, unspecified, base number. This is to ensure that a highly specific selector, such as an ID selector, is never overridden by lots of less specific selectors, such as type selectors. However, if you have fewer than 10 selectors in a specific selector, you can calculate specificity in base 10 for simplicity’s sake.

+ The specificity of a selector is broken down into four constituent levels: a, b, c, and d.
     + If the style is an inline style, a equals 1.
     + b equals the total number of ID selectors.
     + c equals the number of class, pseudo-class, and attribute selectors.
     + d equals the number of type selectors and pseudo-element selectors.


+ If you ever come across a CSS rule that just doesn't seem to be working, you could be suffering from a specificity clash. Try making your selectors more specific by adding the ID of one of its parents.

+ Specificity is very useful when writing CSS, as it allows you to set general styles for common elements and then override them for more specific elements.
+ For instance, say you want most of the text on your site black, except for your intro text, which you want gray. You could do something like this:

```css
     p {color: black;}
     p.intro {color: grey;}
```

+ Try to make sure your general styles are very general while your specific styles are as specific as possible and never need to be overridden. If you find that you have to override general styles several times, it’s simpler to remove the declaration that needs to be overridden from the more general rules and apply it explicitly to each element that needs it.

#### Link Specificity

```css
     a:hover, a:focus, a:active {text-decoration: underline;}
     a:link, a:visited {text-decoration: none;}
```
+ Both rules have the same specificity, so the second rule overrides the first rule. As a result, links will not have underlined decoration on hover or active states.
+ Always apply your link styles in the following order: 'Lord Vader Hates Furry Animals’.
+ This order comes from the fact that a visited hyperlink will always and forever will have decoration:none, because its "visited" style beats out any other state, including "active" and "hover.” Similarly when an unvisited link is hovered the last rule applies. If we were to change the order of the rules hover and active states would override the other properties when the link is actually hovered or active ][Eric Meyer](http://meyerweb.com/eric/css/link-specificity.html)

### over-specific selectors

```css
#container .callout-area ul#callout-one li.callout-list a.callout-link {}
header#banner {}
```

+ over-qualifying selectors makes it more difficult to re-use the contents of rules.
+ They make it very difficult to override or target other associated elements because then you will need a rule more specific than the last.
+ They add code where it isn’t needed.
+ They make the browser work harder.

### !important

+ It can be used to override another stylesheet which you do not have access or permission to edit.
+ It can also be used to hardcode an element's styles to prevent inline Javascript styles from taking precedence.
+ Other than that avoid using *!important*.
     + It breaks CSS cascades.
     + It overrides all specificity.

### Inheritance

+ Inheritance is very useful, as it lets you avoid having to add the same style to every descendant of an element.

```css
body {
    color: black;     // all the descendants of the body element will also have black text
    font-size: 1.4em  // all the descendants of the body element will also have font-size of 1.4 em.
}
```

+ The above code will not change any headings font-size on the page. You may assume that headings do not inherit text size. But it is actually the browser default style sheet setting the heading size. Any style applied directly to an element will always override an inherited style. This is because **inherited styles have a null specificity**.
+ Just as sensible use of the cascade can help simplify your CSS, good use of inheritance can help to reduce the number and complexity of the selectors in your code.

**References**

- [TR - Steven Bradley](http://www.vanseodesign.com/css/css-specificity-inheritance-cascaade/)
- [CSS Mastery: Advanced Web Standards Solutions](http://www.amazon.com/CSS-Mastery-Advanced-Standards-Solutions/dp/1430223979)
- [Lynda](http://www.lynda.com)
- [Treehouse](http://www.treehouse.com)
- [CSS Best Practices | Treehouse Workshop](https://www.youtube.com/watch?v=vQVvbwzM9YU )
