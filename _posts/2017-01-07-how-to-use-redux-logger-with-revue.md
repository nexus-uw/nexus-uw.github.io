---
layout: post
title: 'How to Use Redux Logger with Revue'
date: '2017-01-07'
author: Simon
tags:
  vue.js
  redux
  revue
  logging
---
When using revue to connect an app's redux state to the internals of vuejs change detection, the state is transformed from plain objects, to Vue's observe objects. This is great, since it gets everything working transparently, but leaves a lot to be desired when logging changes to the redux state (using redux-logger).

This leaves our chrome console looking like:

![](/assets/before.png)



By creating custom action + state transformers for redux-logger, the observe objects can be converted back into plain objects. These plain objects reflect what the developer expects to be in the state and are much easier to read in the console.

```typescript

import { requests, elements } from '../reducers';
import Vue = require('vue');

import Revue = require('revue');

import {
  createStore,
  applyMiddleware,
  combineReducers
} from 'redux';

import * as createLogger from 'redux-logger';

// unwrap the observe that vue wraps our state+actions with so that we can inspect our state in using the redux logger
function unwrap(ob) {
  if (!ob) {
    // handle undefined/null
    return ob;
  }
  return Object.keys(ob).reduce((result, key) => {
    const value = ob[key];
    if (Array.isArray(value)) {
      result[key] = value.map(unwrap);
    } else if (typeof value === 'object') {
      result[key] = unwrap(value);
    } else {
      result[key] = value;
    }
    return result;
  }, {});
}

const logger = createLogger({
  actionTransformer: (action) => unwrap(action),
  stateTransformer: (state) => unwrap(state)
});

const reduxStore = createStore(
  combineReducers({ requests, elements })
  , applyMiddleware(logger)
);

export const store = new Revue(Vue, reduxStore);
```

By using the above typescript snippet, the console logging appears like this:

![](/assets/after.png)
