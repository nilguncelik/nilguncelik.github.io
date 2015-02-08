---
title: CSS Images
author: NC
category: css
public: true
---

### `<img src>` vs background-image

+ `<img src>`:
    + has a tendency to lead to unmaintainable markup often invoving tables for layout.
    + Use it if image is part of content, and it is OK that some screen readers will not display it.
+ background-image:
    + Use it if image is decorative and is not content.
    + If you plan to change the image with media queries, use background images.
         + With image tags you should request all images and show/hide them based on the media query which wastes bandwidth.
+ TR - <http://stackoverflow.com/questions/492809/when-to-use-img-vs-css-background-image>

### background-image

+ Set dimensions of the div the same as the image:

```css
#branding {
     width: 700px;
     height: 200px;
     background-image:url(/img/branding.gif)
     background-repeat: no-repeat;
}
```
Adding a bullet to a headline:

```css
h1 {
     padding-left: 30px;
     background-image: url(/img/bullet.gif);
     background-repeat: no-repeat;
     background-position: left center;
}
```

#### image replacement

+ If you apply a background image to an empty element, screen readers or other environments that has css turned off will not be able to see the content.
+ For those people, you can add a text inside the empty element and use text-indent:-9999 property to hide it from users who have css turned on.

### background-position:

```
background-position: left center;
background-position: 20px 20px;   // top-left corner of image will be 20px from the top-left corner of the image.
background-position: 20% 20p%;    // you are positioning a point 20 percent from the top left of the image, 20 percent from the top left of the parent element.
background-position:  0% 50p%;    // == left center
```

+ CSS3 allows to add multiple background images to an element.

### Optimising images

+ Not only compress your images (choosing the most appropriate format and setting such as PNG/JPG/GIF), but also optimise them.  //TODO how?
+ There’s  (meta data and the like) information in images, even if they are compressed.
+ Removing this information doesn’t degrade the visual quality of the image and can save more file size than removing a Javascript library, plugin or a whole file of CSS.
+ [kraken.io](https://kraken.io/)  (commertial)

+ If you are building a fixed width design ensure you only use images that are the size of the space they display in.
+ If you are building a responsive design, where possible, use a "mobile first" technique and swap in alternate images for larger viewports.

### SVG

+ Where possible, provide SVG versions of logos and icons.
+ A vector based image can scale to any size/resolution as it is defined as a set of mathematical values. A bitmap on the other hand is “fixed" as a series of “dots" in set positions. As such, bitmap images (JPG/GIF) are far more wasteful and don’t scale well. However, as photos are bitmap they are completely unavoidable in many instances.
+ SVGs are a fraction of the size of a normal bitmap image.
+ The downside is that support for SVG graphics in browsers is limited (IE8 and below and Android 2-2.3 are notable absentees)
+ If you do need to support IE8 you can always fork your code with Modernizr. This will let you serve an SVG file for browsers that can use it and a PNG for those that don’t.
+ TR - <http://benfrain.com/beginner-and-designers-guide-to-using-modernizr-to-solve-cross-browser-challenges/>

### Icon fonts

+ Like SVG graphics they provide a scalable way of providing images.
+ They can be any size, any colour and enjoy text shadows, webkit-gradients & box-shadows - all configurable through CSS alone.
+ With an icon font, each icon becomes a font glyph, so a number of icons can be a single font file. This provides the ability to remove large numbers of images from a site and replace them with a single asset (a web font).
+ Opera Mobile and IE8 have problems.
+ reference: <http://benfrain.com/front-end-code-what-matters-a-beginners-guide/>

### Handling dynamic sized images

1. Setting height and width.
     + It will squish some images.
2. Overflow crop method

    ```html
    <div class="crop">
         <img src="leopard.jpg"/>
    </div>

    .crop{
         height: 300px;
         width: 400px;
         overflow: hidden;
    }
    ```
    + Still not a good solution

3. making one side auto.

    ```css
    // for landscape oriented images
    .crop img{
         height: auto;
         width: 400px;
    }
    // for portrait oriented images
    .crop img{
         height: 300px;
         width: auto;
    }
    ```

+ We can’t handle both type of images.
+ Resize images to a square which is smaller than width and height of all of your images.
+ Resize them server side.

### Liquid and Elastic images

+ TR - <http://clagnut.com/sandbox/imagetest/>
+ If you choose to use a liquid or an elastic layout, fixed-width images can have a drastic effect on your design. When the width of the layout is reduced, images will shift in relation to it and may interact negatively with each other. Images will create natural minimum widths, preventing some elements from reducing in size. Other images will break out of their containing elements, wreaking havoc on finely tuned designs. Increasing the width of the layout can also have dramatic consequences, creating unwanted gaps and unbalancing designs. There are a few ways to avoid such problems.
+ For images that need to span a wide area, such as those found in the site header or branding areas, consider using a background image rather than an image element. As the branding element scales, more or less of the background image will be revealed:

    ```html
    #branding {
         height: 171px;
         background: url(/img/branding.png) no-repeat left top;
    }
    <div id="branding"></div>
    ```
+ If the image needs to be on the page as an image element, try setting the width of the container element to 100% and the overflow property to hidden. The image will be clipped on the right-hand side so that it fits inside the branding element but will scale as the layout scales:

    ```html
    #branding {
         width: 100%;
         overflow: hidden;
    }
    <div id="branding">
        <img src="/img/branding.png" width="1600" height="171" />
    </div>
    ```
+ For regular content images, you will probably want them to scale vertically as well as horizontally to avoid clipping. You can do this by adding an image element to the page without any stated dimensions. You then set the percentage width of the image, and add a max-width the same size as the image to prevent pixelization.
  + For example, say you wanted to create a news story style with a narrow image column on the left and a larger text column on the right. The image needs to be roughly a quarter of the width of the containing box, with the text taking up the rest of the space. You can do this by simply setting the width of the image to 25% and then setting the max-width to be the size of the image, in this case 200 pixels wide:

        ```css
        .news img {
             width: 25%;
             max-width: 200px;
             float: left;
             display: inline;
             padding: 2%;
        }
        .news p {
             width: 68%;
             float: right;
             display: inline;
             padding: 2% 2% 2% 0;
        }
        ```
  + As the news element expands or contracts, the image and paragraphs will also expand or contract, maintaining their visual balance. However, the image will never get larger than its actual size.

### Responsive images

+ 1-1 image rendering gives the best result. But
     + Chromebook Pixel Screen 4.1 mPx
     + Nexus 4 screen 0.9 mPx
     + IPhone 5 screen 0.7 mPx
+ Best size of images is very different on each of these devices.
+ Try to use svg, canvas, icon fonts, css gradient and borders where possible.

#### How to deliver an image that is 21mPx and 4MB to different devices?

1. Deliver high resolution but highly compressed images. Give same image to all devices.
     + Highly compressing an image results in 2x image that will look better than an uncompressed 1x image and a smaller file size.
     + But browser spends some time for decompressing the image.
     + On a 1x device it needs to scale by 50% to fit into the available pixels.
     + You can also see some color bending and some gradients using this approach.
     + Lower pixel devices will get a bigger image than they need but not too much more data since it is low quality.
     + In higher pixel count devices, we will get the right size. Although they will get a sligtly lower quality image than they would normaly want.
     + This is better than serving only low pixel or high pixel count art to all devices.
2. Request different images based on devicePixelRatio and device width.
     + These images can be the same image in different size but also different images based on the layout and layout size.
     + Start with a high resolution image.
     + Create multiple copies of the image at different sizes. For each image you should tune quality parameters. You will need 1x, 2x (at least), 1.3, 3x.
     + Client should only request the right image.



### Css Sprites

+ Assume we have two photos replaced one below another, each have 100px height.

```css
// first image
.logo {
     background : url(logo.png);
     height: 100px;
}
// for second image
.logo {
     background : url(logo.png);
     height: 100px;
     background-position: 0 -100px;
}
```

+ background-position: x y
     + x: x axes shift
     + y: y axes shift
     + defaults to 0 0



### Image Base64 encoding

+ Way of directly embedding images into CSS.
+ Supported by IE8+.
+ TR - <http://davidbcalhoun.com/2011/when-to-base64-encode-images-and-when-not-to/>



### CSS parallax effect

+ TODO




**References**

- [CSS Mastery: Advanced Web Standards Solutions](http://www.amazon.com/CSS-Mastery-Advanced-Standards-Solutions/dp/1430223979)
- [Lynda](http://www.lynda.com)
- [Treehouse](http://www.treehouse.com)
- [CSS Best Practices | Treehouse Workshop](https://www.youtube.com/watch?v=vQVvbwzM9YU )
