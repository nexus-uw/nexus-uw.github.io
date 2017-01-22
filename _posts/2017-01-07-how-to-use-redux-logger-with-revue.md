---
layout: post
title: 'How to use redux logger with revue'
date: '2017-01-07'
author: Simon
tags:
  vue.js
  redux
  revue
  logging
---

<explain what the problem is>

<include screenshot of failed logging>

<explain how to solve>

<insert code sample>
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

/**
 * redux store for this app.
 * do not modify directly. use redux responsibly
 */
const reduxStore = createStore(
  combineReducers({ requests, elements })
  , applyMiddleware(logger) // todo: do not include this when running in production
);

export const store = new Revue(Vue, reduxStore);
```
<include screenshot of successful logging>

