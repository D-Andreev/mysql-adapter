zombie = require 'zombie'

module.exports =  ->
  @browser = new zombie
  @visit = (url, callback) ->
    @browser.visit url, callback
