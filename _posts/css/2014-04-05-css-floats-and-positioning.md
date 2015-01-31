---
title: CSS Floats and Positioning
author: NC
category: css
public: true
---

### Positioning

+ An element is
     + either in the normal flow (static, relative).
     + or absolutely positioned (absolute, fixed).
     + or floated.

+ Using a value other than static causes the element to be “positioned”.
+ Set top, right, bottom, left properties for the placement of positioned elements.

#### Static Positioning (default)

+ Represents a box in normal document flow.

#### Relative Positioning

+ Renders in the normal document flow and offset from their normal position via positioning properties.
+ Following elements react as if the element is not offset. As such, offsetting the element can cause it to overlap other boxes.
+ Not used for layouts. Changing one thing effects many things.
+ Used for tweaks.
+ It provides a positioning value for container elements: Everything absolutely positioned in this element should be absolutely positioned relative to me. This is good for grouping things and moving them around.

#### Absolute Positioning

+ Removes the element from normal flow and allows to position using offsets relative to the first positioned (positioned other than static) parent element.
+ Not used for layouts. You end up with elements that are exactly where you want but elements dont react to each other in any way. For example if content is dynamic they may overlap.
+ Approach it as a way to reposition elements in a container where conditions allow it.

#### Fixed Positioning

+ Same with absolute positioning except it positions relative to viewport.
+ Not very well supported across all browsers.
+ Works fixed even when page scrolls.
+ Used for navigation, feedback.
+ You should consider how elements will interact with each other especially when browser resizes.

### Floating

+ Floating allows us to alter the normal document flow. It changes the position of a element by moving it until its leftmost or rightmost outer edge touches the edge of its containing box or another floated box.
+ Floating removes the element from the normal document flow, causing the elements below it shift up accordingly.
+ The floating element is allowed to overlap on nonfloated elements in the normal flow.

### Line boxes

+ There is an exception to the rule "The floating element is allowed to overlap on nonfloated elements in the normal flow."
+ Block level elements will respect this, whereas inline elements move out of the way to avoid overlapping.
+ If a floated element is followed by an element in the flow of the document, the element’s box will behave as if the float didn’t exist. However, the textural content of the box retains some memory of the floated element and moves out of the way to make room. In technical terms, a line box next to a floated element is shortened to make room for the floated element, thereby flowing around the floated box.

![](/img/line-boxes.png)

```css
<div class="news">
     <img src="/img/news-pic.jpg" alt="my pic"/>
     <p>Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text</p>
     <p>Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text</p>
</div>
.news img {
     float: left
}

// To stop line boxes flowing around the outside of a floated box, you need to apply a clear property to the element that contains those line boxes.
.news p {
     clear: both
}
```

### Clearing

```
clear: both    // do not allow any elements to the left or right of me.
```

+ By clearing the element, you can ensure the element does not appear to the left or to the right of any floated element. This has the result of turning a float off and restoring normal document flow to the remaining elements.
+ When you clear an element, the browser adds enough margin to the top of the element to push the element’s top border edge vertically down, past the float.

### Container Collapse / clearfix

+ The container of floating elements sometimes may seem to not to contain these elements. This happens because floated elements are removed from the normal flow.



1. Append a clear div to parent element.
  + Downside: you need to add meaningless markup for the purpose of layout.

    ```html
    <div class="wrapper">
         <h1>header</h1>
         // floated elements here..
         <div class="clear"> </div>
    </div>
    .clear{
         clear:both;
    }
    ```
2. Set parent elements overflow to "auto" or "hidden"
  + Downside: this method can force scroll bars or clipped content under certain circumstances.

3. Float parent element
  + all floats inside it will be contained.
  + Downside:  the next element will be affected by the float. To solve this problem, some people choose to float everything in a layout and then clear floats using the site footer. However, floating can be complicated, and some older browsers may choke on heavily floated layouts.

4. after pseudo class

    ```css
    parent:after{
         content:"";
         visibility:hidden;  // You don’t want the new content to be displayed on the page
         display: block;     // required because cleared elements have space added to their top margin ??
         clear:both;
         height: 0;          // You don’t want the new content to take up any vertical space
    }
    ```
    + Downside: not supported by all browsers IE7+
      + TR - <http://www.tjkdesign.com/articles/clearfix_block-formatting-context_and_hasLayout.asp>
      + TR - <http://www.yuiblog.com/blog/2010/09/27/clearfix-reloaded-overflowhidden-demystified/>
      + TR - <http://nicolasgallagher.com/micro-clearfix-hack/>

5. Nicolas Gallagher solution:

    ```css
    .cf:before,
    .cf:after {
         content: " ";      /* 1 */
         display: table;    /* 2 */
    }

    .cf:after {
         clear: both;
    }

    /**
    * For IE 6/7 only
    * Include this rule to trigger hasLayout and contain floats.
    */
    .cf {
         *zoom: 1;
    }
    ```

### Column Collapse

+ If the containing block is too narrow for all of the floated elements to fit horizontally, the remaining floats will drop down until there is sufficient space.
+ If the floated elements have different heights, it is possible for floats to get stuck on other floats when they drop down.
+ Normally, when people create float-based layouts,they float both columns left and then create a gutter between the columns using margin or padding.
+ When using this approach, the columns are packed tightly into the available space with no room to breathe. Although this wouldn't be a problem if browsers behaved themselves, buggy browsers can cause tightly packed layouts to break, forcing columns to drop below each other.
+ Browser bugs along with various browser-rounding errors can also cause float dropping.
+ To prevent your layouts from breaking, you need to avoid cramming floated layouts into their containing elements. Rather than using horizontal margin or padding to create gutters, you can create a virtual gutter by floating one element left and one element right. If one element inadvertently increases in size by a few pixels, rather than immediately running out of horizontal space and dropping down, it will simply grow into the virtual gutter.

### Display Property

+ Affects how elements behave together on a page.
+ none / block / inline / inline-block

#### block

+ Stretch the full width of their container.
+ Behave as though there is a line break before and after the element.

#### inline

+ Typically found within block-level elements.
+ Only take up the space of the content inside.
+ Do not generate a line break before and after the element.

#### inline-block

+ display element as inline but still be able to control its width with box model properties like margin, padding and border.

#### table-*

+ display element as if it were a table cell or a table row. Allows you to make a table based layout.

#### Display-inline vs Float

+ The other big caveat with inline-block is that because of the inline aspect, the white spaces between elements are treated the same as white spaces between words of text, so you can get gaps appearing between elements. There are work-arounds to this, but none of them are ideal. (the best is simply to not have any spaces between the elements)
+ inline-block also respects vertical align property.
+ TR - <http://stackoverflow.com/questions/15172520/drawback-of-css-displayinline-block-vs-floatleft>
+ TR - <http://updel.com/demos/inline-block/articles.html>

### z-index property

+ Elements must be positioned for z-index to take effect. Use relative if you are not interested in moving the object.
+ It creates a new stacking context. Childrens z-index acts on this new stacking context.
+ TR - <https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Understanding_z_index>


**References**

- [CSS Mastery: Advanced Web Standards Solutions](http://www.amazon.com/CSS-Mastery-Advanced-Standards-Solutions/dp/1430223979)
