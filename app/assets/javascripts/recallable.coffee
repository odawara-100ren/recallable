class Recallable
  'use strict'
  timer = null
  printed = null

  constructor: ->
    $(".recallable").each (i)->
      $(this).addClass("recallable_#{i}")

  bindEvents: ->
    $(".recallable").on "focus", ->
      timer = setInterval(->
        unless printed == $("#asdf").val()
          printed = $("#asdf").val()
          console.log(printed)
      , 2000)
    $(".recallable").on "blur", ->
      clearInterval(timer)

this.Recallable = Recallable
