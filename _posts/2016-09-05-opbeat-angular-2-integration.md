---
layout: post
title: How to Integrate Opbeat Into an Angular 2 App
date: '2016-09-05'
author: Simon
tags:
- opbeat
- angular 2
- error reporting
---

[Opbeat](https://opbeat.com/) is a paid service for select performance monitoring and reporting runtime errors in Javascript applications. While they do support an Angular 1 integration, Angular 2 will not be supported until its API stabilizes ([ref](https://github.com/opbeat/opbeat-js/issues/30#issuecomment-230262392)).

Until that magical day occurs, a hard coded solution is available (as shown below).

```js
import {
  ExceptionHandler,
  Injectable
} from '@angular/core';

// cant import the source  directly using webpack, so we have to
// include the built source file on the page to expose _opbeat
// on the window
declare let _opbeat;

// Firefox tracking protection will block the opbeat script from loading,
// so sub it out
if (!(<any>window)._opbeat) {
  (<any>window)._opbeat = function noop() { };
}

/**
 * maintain default error logging BUT also send errors off to opbeat
 */
@Injectable()
export class OpBeatErrorHandler extends ExceptionHandler {
  private static opBeatStarted = false;
  call(error, stackTrace = null, reason = null) {
    if (!OpBeatErrorHandler.opBeatStarted) {
      startOpbeat();
      OpBeatErrorHandler.opBeatStarted = true;
    }
    sendErrorToOpbeat(error);
    console.error('ERROR', error);
    if (stackTrace) {
      console.error('STACK TRACE', stackTrace);
    }
    if (reason) {
      console.error('REASON', stackTrace);
    }
  }
}

@NgModule({
  providers: [
    { provide: ExceptionHandler, useClass: OpBeatErrorHandler }
  ]
})
export class OpBeatErrorHandlerModule { }

/**
 * internal helper functions
 */

function startOpbeat() {
  _opbeat('config', {
    orgId: 'your orgId',
    appId: 'your appId'
  });
}

function sendErrorToOpbeat(e) {
  _opbeat('captureException', e);
}
```


now all that remains, is to add ```OpBeatErrorHandlerModule``` to the ```imports``` of the main module.
