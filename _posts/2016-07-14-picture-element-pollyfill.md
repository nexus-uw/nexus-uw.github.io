---
layout: post
title: How to support <picture> elements created by Angular (or other similar JS Frameworks) in IE11 or Safari browsers from before March 2016
date: '2016-07-14'
author: Simon
tags:
- IE11
- <picture>
- angular2
---

Sometimes  a project requires a very pretty content page filled with overlapping background images and floating text blocks that is not particularly easy to implement responsively using HTML. The relatively new <picture> element is a great tool for this problem (having significantly taller mobile images so that the there is white space to for the content to go above the photo's subject) but it is not supported on all browsers (ref: 1,2,3).


Luckily there a great polyfill, [picturefill](https://scottjehl.github.io/picturefill/) so there is no need for weird hacks.


Including both *picturefill.min.js* *plugins/mutation/pf.mutation.min.js* on the page will allow last year's browser to display your lovely mobile images.



<picture>
  <source media="(min-width: 650px)" srcset="/assets/bread-doge.png">
  <source media="(min-width: 465px)" srcset="/assets/close-doge.jpeg">
  <img src="/assets/cool-doge.png" alt="doge pictures" width="465px">
</picture>






### References
1 [https://developer.mozilla.org/en-US/docs/Web/HTML/Element/picture#Browser_compatibility]()  
2 [https://responsiveimages.org/]()  
3 [http://caniuse.com/#feat=picture]()     
