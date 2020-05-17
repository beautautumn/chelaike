require('babel-register')
require('babel-polyfill')
require('ignore-styles').default(['.css', '.scss', '.less', '.swf', '.png'])
const jQuery = require('jquery')

global.document = require('jsdom').jsdom('<body></body>')
global.window = document.defaultView
global.navigator = window.navigator
global.matchMedia = window.matchMedia = () => ({
  matches: false,
  addListener() {},
  removeListener() {},
})
global.URL = window.URL
global.location = window.location
global.FormData = window.FormData
global.localStorage = global.sessionStorage = window.sessionStorage = window.localStorage = {
  getItem() {},
  removeItem() {},
}
global.jQuery = window.jQuery = jQuery(global.window)
