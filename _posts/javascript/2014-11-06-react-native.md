---
title: React Native
author: NC
category: javascript
public: true
---



- React Native is a way to build native apps in JavaScript using React.js for user interface.
- It doesnt use HTML, browser or WebViews.
- There are current solutions which wrap native APIs in JavaScript with imperative mutative APIs. If you introduce this using JS naive this can end up worse because we will be waiting fo js to do somework like garbage collection. Therefore the JS layer should be async. That way we can do anything with JS and this wont effect the actual rendering. When react makes diffs, it batches up all the instructions it wants on the native and throws them into task queue.
- This way all of your application logic including rendering is always rendering in a background thread. All the js runs off the main thread by default.
- The goal is not to have single code base to power all platforms. Not "Write once run anywhere". When you are writing about an Android application you should be thinking about Android pricinples, Android look and feel not IOS principles.
- Our goal is "Learn once, write anywhere". We want to develop consistent set of tools and technologies that let us built applications using same set of principles across platforms.
- Native vs MobileWeb
	- Touch handling is better.
	- Native Components is better.
	- Style and Layout is better.
- React Native is not transpiling js to Objective C. It runs a real JS Engine. It runs jscore which is js engine in IOS.
- Bridge between JS and Obj-C is
	- asynchronous
	- batched
	- serializable

**References**
