---
title: CSS Solutions to Common Problems
author: NC
category: css
public: true
---

### Horizontal Centering

+ For block elements
     + Define a width.
     + Define margin: 0 auto.
+ For inline or inline-block elements
     + text-align: center

### Column Height problem

1. Set explicit height to every single parent of the element and element itself to 100%.
     + Downside : If content overflows, the overflow part is visible and but the element does not contain it.

2. Set min-height:
     + Downside: If you set padding on the element, it causes problems.

    ```css
    element{
         min-height:100%;
    }
    ```
3. 2 column layout fix:

    ```css
    <article>
         <div id="col1"></div>
         <div id="col2"></div>
    </article>
    #col1,#col2{
         padding-bottom: 1000em;
         margin-bottom: -1000em;
    }
    article{
         overflow: hidden;
    }
    ```
4. Faux column fix:
     + Give parent a background with gradient.


### Vertical Centering

+ Applying the position: absolute; effectively moves the element out into position mode and responds to the pushing and pulling of auto margins and no specific location.

    ```css
    .exactMiddle {
         width: 100px;
         height: 100px;
         position: absolute;
         top: 0;
         right: 0;
         bottom: 0;
         left: 0;
         margin: auto;
    }
    ```
+ The downsides of this method include its lack of support in IE6 and IE7, and the absence of a scroll bar if the browser is resized to be smaller than the centered object.
+ TR - <http://blog.themeforest.net/tutorials/vertical-centering-with-css/>

### Vertical Centering of text

+ If the text is on a single line, like a horizontal navigation item, you can set the line-height to be that of the element's physical height.

    ```css
    #horizNav li {
         height: 32px;
         line-height: 32px;
    }
    ```

### Fallbacks for Middle Mouse Clicks

+ One of the most frustrating accessibility and usability flaws of the modern web stems from the remapping of hyperlink click functions. Elements that appear to be hyperlinks may have their single click functionality remapped via Javascript, breaking middle mouse click (open in new tab) functionality. If they can be opened in a new tab, their href of a single hash sends you back to the same page.

+ A modern example of a popular website that is contributing to this problem is the Twitter web app. Middle mouse clicking of names or user avatars yields completely different results throughout the web app.

    ```html
    <!-- The old way, breaking the web -->
    <a href="#"></a>

    <!-- If you can't deliver a page on mouse click, it's not a hyperlink -->
    <span class="link" role="link"></span>
    ```

+ Another alternative is the use of "hashbangs", that remap normal URLs to hash links and fetch pages via AJAX.
+ Libraries that provide hashbang functionality should be able to display the page normally when middle mouse clicked, or load the content from that page into a designated area when clicked normally. But tread carefully, there are plenty of people who believe hashbangs are breaking the web.
+ TR - <http://www.tbray.org/ongoing/When/201x/2011/02/09/Hash-Blecch>

### Pure CSS tooltip

```css
<p>
     <a href="http://www.andybudd.com/" class="tooltip"> Andy Budd<span> (This website rocks) </span></a> is a web developer based in Brighton England.
</p>
a.tooltip {
     position: relative;
}
a.tooltip span {
     display: none;
}
a.tooltip:hover span {
     display: block;
     position: absolute;
     top: 1em;
     left: 2em;
     padding: 0.2em 0.6em;
     border:1px solid #996633;
     background-color:#FFFF66;
     color:#000;
}
```

### Creating links that look like buttons

+ You can do this by setting the display property of the anchor to block and then changing the width, height, and other properties to create the style and hit area you desire.

    ```css
    a {
         display: block;
         width: 6.6em;
         line-height: 1.4;
         text-align: center;
         text-decoration: none;
         border: 1px solid #66a300;
         background-color: #8cca12;
         color: #fff;
    }
    ```
+ With the link now displaying as a block-level element, clicking anywhere in the block will activate the link.
+ Block-level elements expand to fill the available width. If the width of their parent elements are greater than the required width of the link, you need to apply the desired width to the link. Otherwise you can apply width property to the parent.
+ If you were to set a height instead of line-height, you would have to use padding to push the text down and fake vertical centering. However, text is always vertically centered in a line box, so by using line-height, the text will always sit in the middle of the box. There is one downside, though. If the text in your button wraps onto two lines, the button will be twice as tall as you want it to be. The only way to avoid this is to size your buttons and text in such a way that the text won’t wrap.
+ Keep in mind that, links should only ever be used for GET requests, and never for POST, PUT or DELETE requests.



### Suckerfish pure CSS drop-downs

```css
<ul class="nav">
     <li><a href="/home/">Home</a></li>
     <li><a href="/products/">Products</a>
          <ul>
               <li><a href="/products/silverback/">Silverback</a></li>
               <li><a href="/products/fontdeck/">Font Deck</a></li>
          </ul>
     </li>
     <li><a href="/services/">Services</a>
          <ul>
               <li><a href="/services/design/">Design</a></li>
               <li><a href="/services/development/">Development</a></li>
               <li><a href="/services/consultancy/">Consultancy</a></li>
          </ul>
     </li>
     <li><a href="/contact/">Contact Us</a></li>
</ul>

ul.nav, ul.nav ul {
     margin: 0;
     padding: 0;
     list-style-type: none;
     float: left;
     border: 1px solid #486B02;
     background-color: #8BD400;
}

ul.nav li {
     float: left;
     width: 8em;
     background-color: #8BD400;
}
ul.nav li ul {
     width: 8em;
     position: absolute;
     left: -999em;
}
.nav li:hover ul {
     left: auto;
}
ul.nav a {
     display: block;
     color: #2B3F00;
     text-decoration: none;
     padding: 0.3em 1em;
     border-right: 1px solid #486B02;
     border-left: 1px solid #E4FFD3;
}
ul.nav li li a {
     border-top: 1px solid #E4FFD3;
     border-bottom: 1px solid #486B02;
     border-left: 0;
     border-right: 0;
}
/*remove unwanted borders on the end list items*/
ul.nav li:last-child a {
     border-right: 0;
     border-bottom: 0;
}
ul a:hover,ul a:focus {
     color: #E4FFD3;
     background-color: #6DA203;
}
```

+ TR - <http://htmldog.com/articles/suckerfish/dropdowns/>




**References**

- [CSS Mastery: Advanced Web Standards Solutions](http://www.amazon.com/CSS-Mastery-Advanced-Standards-Solutions/dp/1430223979)
- [Lynda](http://www.lynda.com)
- [Treehouse](http://www.treehouse.com)
- [CSS Best Practices | Treehouse Workshop](https://www.youtube.com/watch?v=vQVvbwzM9YU )
