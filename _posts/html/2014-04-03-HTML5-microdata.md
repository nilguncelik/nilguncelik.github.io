---
title: HTML5 Microdata
author: NC
category: html
public: true
---

```html
<section itemscope itemtype="http://data-vocabulary.org/Person">

	Hello, my name is <span itemprop="name">John Doe</span>, I am a <span itemprop="title">graduate research assistant</span> at the <span itemprop="affiliation">University of Dreams</span>.

	My friends call me <span itemprop="nickname">Johnny</span>. You can visit my homepage at <a href="http://www.JohnnyD.com" itemprop="url">www.JohnnyD.com</a>.

	<section itemprop="address" itemscope itemtype="http://data-vocabulary.org/Address">
		I live at <span itemprop="street-address">1234 Peach Drive</span> <span itemprop="locality">Warner Robins</span>, <span itemprop="region">Georgia</span>.
￼  </section>

</section>
```

corresponds to following data structure:

	Type = http://data-vocabulary.org/Person
	name = John Doe
	title = graduate research assistant
	affiliation = University of Dreams
	nickname = Johnny
	url = http://www.johnnyd.com/
	address =
		Type= http://data-vocabulary.org/Address
		street-address = 1234 Peach Drive
		locality = Warner Robins
		region = Georgia


**References**
