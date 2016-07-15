---
layout: post
title: 'Something About Parsing JSON Using Go'
date: '2016-09-05'
author: Simon
tags:
- JSON
- go
- golang
---


### Problem

Go requires exported properties to start with a capital letter but most APIs use JSON that is all in cammelCase so
using ```json.Unmarshal``` will always result in all empty properties. ie

```json
{  
  "name" : "some name",  
  "age" : 1  
}  
```


### Solution

`json:"cammelCasePropertyName"` adding a clause to the type's property. ie:  

```go
type Sample struct {  
    Name string `json:"name"`  
    Age  int    `json:"age"`  
}  
```

will create the correct mapping of JSON property to  Struct property


### Better Solution
goto [https://gobyexample.com/json](https://gobyexample.com/json) instead....
