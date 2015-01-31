---
title: CSS Metrics
author: NC
category: css
public: true
---

+ A pixel's physical size is dependent on the pixel density.
	+ 5px on a screen of 100 ppi would look bigger than on a screen of 300 ppi.
	+ 16px font size will look smaller on new mobile devices which have small screens with high resolutions and therefore high pixel density.

### Absolute Lengths

+ em,ex,rem

### Relative Lengths

+ in, cm, mm, pt, pc, px( = 0.75pt)

### em

+ 1 em is equal to the computed value of the font-size property of the element on which it is used.
+ If no font-size is defined on any element, it is equal to default font-size which is browser and operating system specific. For web it is ~16px, other devices have their own default font-size.
+ If em is used for font-size, it is relative to the font-size of the parent element. Therefore nested ems multiplied and gets bigger. (CSS3 has rem to prevent this.)
+ If em is used for any property other than font-size, it looks to the element it is applied on, has a value relative to the font-size of the element.
+ em s are commonly used for fonts to make them scalable across different devices.
+ Using media queries and em unit you can change one value (body{font-size}) to scale all the rest of the page. Because they are relative.

### rem

+ rem unit is CSS3 unit which is always based on the size of the root element, skipping parents.

### Percentages

+ They are not exactly relative or absolute.
+ It is hard to calculate their values.
+ If you use them on width, padding and margin, their value is calculated relative to the parent element.
+ Percentages do not work with border-width.

```
margin-bottom: 10%;  // calculated according to the width of the parent element. why width but not height?
1vw   // 1 percent of viewport width
1vh   // 1 percent of viewport height
vmim  // 1 vw or 1vh whichever is smallest
vmax  // 1 vw or 1vh whichever is largest
```

**References**

- [CSS Mastery: Advanced Web Standards Solutions](http://www.amazon.com/CSS-Mastery-Advanced-Standards-Solutions/dp/1430223979)
