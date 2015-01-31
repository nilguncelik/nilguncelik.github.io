---
title: CSS Responsive Design
author: NC
category: css
public: true
---


+ It allows changing css properties based on different media-queries.

```
media_query_list: <media_query> [, <media_query> ]*
media_query: [[only | not]? <media_type> [ and <expression> ]*] | <expression> [ and <expression> ]*
expression: ( <media_feature> [: <value>]? )
media_type: all | aural | braille | handheld | print | projection | screen | tty | tv | embossed
media_feature: width | min-width | max-width | height | min-height | max-height | device-width | min-device-width | max-device-width | device-height | min-device-height | max-device-height | aspect-ratio | min-aspect-ratio | max-aspect-ratio | device-aspect-ratio | min-device-aspect-ratio | max-device-aspect-ratio | color | min-color | max-color | color-index | min-color-index | max-color-index | monochrome | min-monochrome | max-monochrome | resolution | min-resolution | max-resolution | scan | grid
```

#### user-posture

+ A TV is usually viewed from about 10 feet away, while the average smartphone viewing distance is about 12 inches.
+ The official specs describe the Glass display as a "25 inch HD screen viewed from 8 feet away.
+ User-posture or in this case viewing distance has an obvious impact on legibility for things like font and image sizes or contrast.

#### input-type

+ d-pad (TV), touch, voice

#### viewport meta tag

+ When mobile browers first came along, the content on the web wasn't designed for narrow small screen devices.
+ It was designed for windows that were around 1000 pixels wide and wider that were tall with easy scrolling.
+ To shoehorn this content into a tiny mobile screen (since rendering a web page designed for 1000 pixels across and a 320 pixel wide screen would mean you'd be scrolling a lot) mobile browsers lied about the window width or applied an initial zoom to your site.
+ They made the window act as if it were 980 pixels wide, even though the original iPhone was only 320 pixels across. This enabled sites that were designed for a 1024 by 768 screen, i.e., that were around 980 pixels wide, to fit on the mobile screen. Although sometimes you needed to a do a lot of zooming to read the text.
+ So what they were doing is that they were zooming out. This is called *viewport*. Viewport in a mobile device is usually bigger than actual screen.
+ Unfortunately if your site did not happen to match that 980 pixel width, you were either going to overflow or underflow the screen. Either wasting space or forcing the user to zoom.
+ In order to control this, Apple provided a viewport meta tag to be added to your HTML to control the default for **how big should my screen act on this page**.

    ```html
    <meta name="viewport" content="width=700" >
    ```
+ The default is 980.
+ Setting a viewport tells the browser how wide the content is intended to be, and then the browser scales to make that size fit on the device's screen.

    ```html
    <meta name="viewport" content="width=916" >
    ```
+ Now the mobile browser will automatically scale out width to fit on no matter what size screen the user has or whatever device width the user has.
+ With this tag set, the width will scale to fill the width of a horizontal tablet, width of a vertical tablet (leaves space below) or vertical mobile phone ( leaves a lot of empty space below. )

    ```html
    <meta name="viewport" content="height=500" />
    ```
+ *height* also works but most pages are designed to work to scroll up and down not sideways, so this is rarely used.
+ Viewport metatag is only used by mobile browsers not desktop browsers.

#### width=device-width

+ Using fixed width will always scale your page, but there is no fixed width that will serve rich user experience
     + if it is good for big screens, small screen readers will have to zoom.
     + otherwise big screen readers will see very big text and images without getting much of their big screens.
+ The second way to use viewport is if your page knows how to adapt to width (for example, if it knows how to wrap the contents based on screen width) you can simply set the window width to device-width which tells the browser -my website knows how to adapt your width.
+ This is really the best approach to build applications that scale their own layout and make intelligent decisions about how to do, rather than just trying to scale a fixed layout to fit the screen.

    ```html
    <meta name="viewport" content="width=device-width" >
    ```
+ width=device-width asks mobile device to set its screen width to actual device width. You ensure that the entire viewport will be visible within the screen.

#### initial-scale

```html
<meta name="viewport" content="width=device-width,initial-scale=1.0" >
```
+ initial-scale changes the default zoom factor (A lot devices have zoom of 50%). If you change this the user will probably have to zoom.
+ Device is showing the page 100%. Do not zoom in & out any position of it.
+ It is important to use it in IOS. Without this, when you use landscape mode, it changes the viewport size instead of rescaling:
  - IOS Portrait  device width x height = 320 x 356
  - IOS Landscape device width x height = 320 x 139 (initial-scale not set)
  - IOS Landscape device width x height = 480 x 208 (initial-scale=1.0) (IOS also increases font size)

#### device pixel ratio

+ width=device-width => device-width is not actual number of pixels on the screen.
  - iphone 3  device-width= 320 (x480)
  - iphone 4  device-width= 640 (x960) => Apple call this retina display. Have higher pixel density.

+ Both have similar number of actual pyhsical pixel on screen but different number of *device independent pixels*.
+ device pixel ratio is the approximate number of device pixels for every "formatted pixel".

|                           |Galaxy S4 (1080 x 1920 pixels), Portrait 1080 pixel width | Nexus 7 (1280x800),Portrait 800 pixel width |
|---------------------------|----------------------------------------------------------|---------------------------------------------|
|device pixel resolution :  |                                                         3|                                         1.3 |
| calculated device-width : |                                                       360|                                         601 |

| model            |resolution| device pixel ratio| device width| device independent pixels per inch|
|------------------|----------|-------------------|-------------|-----------------------------------|
| Nexus 7          |  1280x800|               1.3x|      601x906|                                166|
| iPhone 5         |  640x1136|                 2x|      320x240|                                163|
| Chromebook Pixel | 2560x1700|                 2x|     1280x850|                              119.5|
| Nexus 4          |  768x1280|                 2x|      384x592|                                160|
| Galaxy S4        | 1080X1920|                 3x|      360x640|                                147|

+ device independent pixels per inch     ~ 160 in most mobile devices




**References**

- [Udacity - Mobile Web Development](https://www.udacity.com/course/cs256)
