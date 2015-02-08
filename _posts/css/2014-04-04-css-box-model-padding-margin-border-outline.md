---
title: CSS Box Model Padding, Margin, Border, Outline
author: NC
category: css
public: true
---

+ An elements width/height is sum of its **content width/height + padding + border + margin** (margins sometimes collapse and not added to the total width/height).
+ **Padding** is often used to create a gutter around content so that it does not appear flush to the side of the background.
+ **Margin** is transparent and cannot be seen. It is generally used to control the spacing between elements.

### box-sizing property

+ *box-sizing* property allows you to define which box model to use.
+ It has value `content-box` by default.
+ `box-sizing: border-box`
     + it prevents padding and border property to change the elements overall width/height.
     + Any padding or border specified on the element is laid out and drawn inside this specified width and height.
     + The content width and height are calculated by subtracting the border and padding widths of the respective sides from the specified 'width' and 'height' properties.

```css
-webkit-box-sizing: border-box; /* Safari/Chrome, other WebKit */
-moz-box-sizing: border-box;    /* Firefox, other Gecko */
box-sizing: border-box;         /* Opera/IE 8+ */
```

+ `$.css("width")` vs `$.outerWidth( [includeMargin ] )`:
     + `$.css("width")`
        + gives content width.
        + checks box-sizing so that it can decide whether it needs to subtract out the padding and border width.
        + works since jQuery 1.8.
     + `$.outerWidth( [includeMargin ] )`
        + returns current computed width for the element, including padding and border.


### outline property

+ It's similar to border property except that:
     1. It always goes around all the sides, you can't specify particular sides.
     2. It's not a part of the box model, so it won't effect the position of the element or adjacent elements.
+ Because of this, outlines can be useful when fixing bugs, because they won’t alter the layout of your page.
+ Outlines are supported by most modern browsers including IE 8 but are not supported in IE 7 and below.



### Margin Exceptional Behaviors

1. Overconstraints
  + If parent is too small to contain child, child overflows to padding area or outside of the parent.
  + Overflow property of the parent controls childs behavior.

2. Vertical margin collapse
  + If margins of two sibling elements touch each other, larger of the two is used as the total margin.
  + If margin of parent and child touches i.e. the parent does have border and padding, margins also collapse.
  + If an element is empty with a margin but no border or padding, the top margin is touching the bottom margin, and they collapse together.
  + If this empty element is touching the margin of another element than 3 margins will collapse to one margin.


+ Margin collapsing only happens with the vertical margins of block boxes in the normal flow of the document. Margins between inline boxes, floated, or absolutely positioned boxes never collapse.

+ Most problems with margin collapsing can be fixed by
     + adding a small amount of padding or a thin border with the same color as the background of one of the elements.
     + relatively or absolutely positioning one of the elements.
     + Floating left or right one of the elements.




### Box Model of Inline elements

+ Inline boxes are laid out in a line horizontally.
+ Their horizontal spacing can be adjusted using horizontal padding, borders, and margins.
+ However, vertical padding, borders, and margins will have no effect on the height of an inline box.
+ Similarly, setting an explicit height or width on an inline box will have no effect.
+ The horizontal box formed by a line is called a "line box", and a line box will always be tall enough for all the line boxes it contains.
+ There is only one way to change the height of inline boxes: changing the line height property.




### Anonymous Block Boxes and Line Boxes

+ If you add some text at the start of a block-level element like a div, a block-level element is created even if it has not been explicitly defined:

```html
<div>
     some text
     <p> Some more text </p>
</div>
```

+ "some text" is treated as a block level element. In this situation, the box is described as an anonymous block box, since it is not associated with a specifically defined element.
+ A similar thing happens with the lines of text inside a block-level element. Say you have a paragraph that contains three lines of text. Each line of text forms an anonymous line box. You cannot style anonymous block or line boxes directly, except through the use of the :first-line pseudo element.
+ It is useful to understand that everything you see on your screen creates some form of box.



### Overflow

+ If you dont declare a specific height on an element, the contents of the element forms the height.
+ If you have an element with a defined width and height on it, content no longer fits within that element is considered to be overflow.
+ visible, auto, hidden, scroll
+ Default is visible
     + If you use "auto" be aware that scroll changes the width of the element.



**References**

- [CSS Mastery: Advanced Web Standards Solutions](http://www.amazon.com/CSS-Mastery-Advanced-Standards-Solutions/dp/1430223979)
- [Lynda](http://www.lynda.com)
- [Treehouse](http://www.treehouse.com)
- [CSS Best Practices | Treehouse Workshop](https://www.youtube.com/watch?v=vQVvbwzM9YU )
