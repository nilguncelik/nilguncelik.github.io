---
title: HTML5 Geolocation
author: NC
category: html
public: true
---


#### How to detect where the user is from browser:

1. Browsers HTML5 feature

	```javascript
	if ("geolocation" in navigator) {   // geolocation supported
	     navigator.geolocation.getCurrentPosition(function(position) {   // shows the popup at the top of the page.
	          var latitude = position.coords.latitude;
	          var longitude = position.coords.longitude;
	          $.post('session_coordinates', { latitude: latitude, longitude: longitude }, function(){
	               // do stuff
	          })
	     });
	}
	```
2. Convert IP to a location using a service

3. Buy a GeoIP database and bring it local.
	- maxmind.com (There is a free version)
	- nginx has a geoip plugin. you should point the geoip database to this plugin.
	- The server sets a request header or sets an environment variable. Letting server doing is much more faster than doing it in application layer.



**References**

- <https://www.codeschool.com/screencasts/groupon-geolocation>
