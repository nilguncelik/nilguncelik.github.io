---
title: CSS Architecture
author: NC
category: css
public: true
---

- While starting a new project break design into components.
- Decouple layout from components.
- Find similarities and differences between components.
	- Where can i use nav element?
		- top menu, tab menu, links widget, social buttons
	- Where can i use button class?
		- Tickets sold out, start and subscribe buttons.
		- What do these buttons have in common?
			- color, alignment, font, border.
		- Then I can have classes like button, button-primary, button-secondary, button-ternary.
	- Where can I use a widget structure?
		- HTML Mag News, Resources and Try Yourself boxes.
		- Try Yourself box = widget-banner = widget + red background + white color.

## Menu

- Traditionally ul and li elements are used for creating menus.
	- With HTML5 you can use nav + a ( if you have linear lists) or nav + ul + li + a (if you have tree like menu structure).
	- Using nav will remove the default styling ( margin, padding and list-styles ) of the browser.
	- Using nav + html shiv/shim for ie8 does not have any additonal performance costs.
- Use of href=“javascript:” and href=“javascript:void(0)” are anti-patterns.
	- Browser will not focus or show link cursor.
	- Requires additional styling to make it look like a link.
	- May cause problems if you use same structure for tab menus. ( Needs clarification ? )
	- Alternatively you can create a class, and assign a click handler to that class which return false to stop propagation.


## OOCSS
### Single Responsibility Principle

- Every class should be defined for a single job and should be used only for that job.
- We dont want a swiss knife.
- reusable code blocks.
- different classes can be used together. ( having up to 3-4 for classes for a single element is ok.)


### Selectors

- Always try to use low specificity:
```
.nav ul li a span  =>  .nav span
```
- The larger number of selectors are the harder it is to override them later.
- Instead of making a train of selectors use namespaces.


### BEM


### Scalable FrontEnd Architecture

- Pyramid structure from general to more specific
	- settings(for sass, renk kodlari, degiskenler)
	- tools(mixins and functions)
	- global ( ex. normalize css, reset, body, \*)
		- box-sizing : border-table
	- layout ( page, wrapper, header, footer, single column, multi-column )
		- page-wrap 'e relative veriyorum ki absolute dedigim yerler hızlıca set olsun.
	- elements ( a, table, h1 , styling for elements without classes )
		- a elementlerine padding : mobile icin
	- components (menu, widget, media for ex main-navigation, main-navigation links)
	- auxilary ( is-error, is-hidden)

- normalize css
	- makes all element look similar
- reset css (meyer)
	- removes all css. you will need to write your own styles thereafter.

.media{
	@extend .cf
}
- cf nin tum ozelliklerini .media ya aktar.


### Extentions

- Perfect Pixel
- Page Ruler
- Color Picker
- SweetCSS
- animation : animate.css magic.css

- grunt vs gulp
- grunt dosya bagli, gulp ram de tutuyor.
- adobe snap svg. butun svg leri animate ettirebiliyorsun.
- github codylindley tools
