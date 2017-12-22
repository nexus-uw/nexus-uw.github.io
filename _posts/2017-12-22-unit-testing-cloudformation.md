---
layout: post
title: 'Unit Testing CloudFormation Templates'
date: '2017-12-22'
author: Simon
tags:
- CloudFormation
- unit testing
- nodejs
---

Below is a quick mocha/jasmine test suite for validating all CloudFormation templates in a directory

```javascript
const fs = require('fs')
const cf = new (require('aws-sdk').CloudFormation)({ region: 'us-east-1' })
const PATH = './Path/to/folder/containing/templates'

describe('CloudFormation Templates', () => {
  fs.readdirSync(PATH).forEach(filename => {
    it(`should validate ${filename}`, () => cf.validateTemplate({
      TemplateBody: fs.readFileSync(PATH + '/' + filename).toString()
    }).promise())
  })
})
```

This can be helpful in quickly failing a CI/CD pipeline before trying to deploy an invalid* template.