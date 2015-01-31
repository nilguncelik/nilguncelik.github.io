---
title: CSS Selectors and Properties
author: NC
category: css
public: true
---

### Adjacent Sibling Selector

```
h2 + p   // All paragraphs after h2 are selected.
```

### Attribute Selector

+ `[att=value]`
The attribute has to have the exact value specified.

+ `[att~=value]`
The attribute’s value needs to be a whitespace separated list of words (for example, class="title featured home"), and one of the words is exactly the specified value.

+ `[att|=value]`
The attribute’s value is exactly "value" or starts with the word "value" and is immediately followed by "-", so it would be "value-".

+ `[att^=value]`
The attribute’s value starts with the specified value.

+ `[att$=value]`
The attribute’s value ends with the specified value.

+ `[att*=value]`
The attribute’s value contains the specified value.

```
a[href^="http:"]                       // select all external links (assuming your internal links are relative)
a[href^="mailto:"]                     // select email links
a[href$=".pdf"] or a[href$=".doc"]     // select by document type
a[href$=".rss"], a[href$=".rdf"]       // select rss feeds
```

### Text property

```
font-style         // normal, oblique, italic
font-variant       // small-caps
font-weight        // bold
font-size
line-height
font-family
color
letter-spacing
word-spacing
text-align         // left, right, center, justified (stretches the lines so that each line has equal width (like in newspapers and magazines))
white-space        // nowrap

font: font-style font-variant font-weight font-size/line-height font-family;
```

### Background property

```
background-color
background-image       // url(<path to image relative to this css file>)
background-repeat      // no-repeat, repeat-x, repeat-y
background-position    // center center, left/right bottom/top, -120px 100px, 50% 50%

background : color image repeat position;
```

### Border property

```
border-width
border-style           // solid, dashed, dotted, double, groove, outset, inset, ridge
border-color

border: width style color;
```

#### border-radius (CSS3)

```css
.box {
     -moz-border-radius: 1em;
     -webkit-border-radius: 1em;
     border-radius: 1em;
}
```

#### border-image (CSS3)

+ It allows you to slice up the specified image into nine separate sectors, based on some simple percentage rules, and the browser will automatically use the correct sector for the corresponding part of the border.

### box-shadow (CSS3)

```
img {
     -webkit-box-shadow: 3px 3px 6px #666;
     -moz-box-shadow: 3px 3px 6px #666;
     box-shadow: 3px 3px 6px #666;
}

box-shadow: horizontal offset   vertical offset   blur radius   colour;
```

+ horizontal offset:  positive value will move the shadow to right, negative value will remove the shadow to left.
+ vertical offset:    positive value will move the shadow down, negative value will remove the shadow to up.
+ blur radius:        determines how blurry the shadow should be. 0-> a shadow with sharp edges. As value gets larger the blurer the shadow will appear.


+ By default box shadows are created as drop shadows outside of the element. To create an inner shadow use inset as the last or first argument.
+ Multiple shadows can be defined by separating them using comma. Then the first one will be on the top and the last one will be at the bottom.

### Pseudo classes

```
:link             // link elements that are unvisited
:visited          // link elements that are visited
:active           // links are active when they are clicked
:hover
:focus
li:first-child    // li elements that are first child element of its parent element are
selected. It doesn’t match the first child of a list item.
li:last-child     // li elements that are last child element of its parent element
li:only-child
:nth-child()
:nth-of-type()
li:nth-child(even)  // even numbered elements
li:nth-child(odd)   // odd numbered elements
li:nth-child(an+b)  // each a’th element starting from b’th element.
li:nth-child(2n)    // even
li:nth-child(2n+1)  // odd
```

### Pseudo classes

```
:after
:before
:first-letter
:first-line
```

#### :before (CSS2), ::before (CSS3) pseudo classes

+ ::before creates a pseudo-element that is the first child of the element matched. Often used to add cosmetic content to an element, by using the **content** property.
+ content property is required.
+ This element is inline by default.
+ Supported by IE8+.

#### :after (CSS2), ::after (CSS3) pseudo classes

+ The CSS ::after pseudo-element matches a virtual last child of the selected element. Typically used to add cosmetic content to an element, by using the content CSS property.
+ content property is required.
+ This element is inline by default.
+ Supported by IE8+.
+ [TR - http://css-tricks.com/pseudo-element-roundup/](http://css-tricks.com/pseudo-element-roundup/)

### opacity property

```css
.alert {
     background-color: #000;
     border-radius: 2em;
     opacity: 0.8;
     filter: alpha(opacity=80); /*proprietary IE code*/
}
```

+ CSS opacity is inherited by the contents of the element you’re applying it to, as well as the background. If there is text within .alert element, it will show through. With lower opacities, the content of your box can start to get unreadable.
+ To solve the issue one can use RGBa:

```css
.alert {
     background-color: rgba(0,0,0,0.8);
     border-radius: 2em;
}
```


**References**

- [Mozilla Css Reference](https://developer.mozilla.org/en/CSS_Reference)
- [CSS Mastery: Advanced Web Standards Solutions](http://www.amazon.com/CSS-Mastery-Advanced-Standards-Solutions/dp/1430223979)
