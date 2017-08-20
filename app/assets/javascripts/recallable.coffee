class Recallable
  'use strict'
  target_number = 0
  timer = []
  printed = []

  constructor: ->
    self = this
    $(".recallable").each (i)->
      target_number += 1
      clazz = "recallable_#{i}"
      $(this).addClass(clazz)
      str = self.recall(clazz)
      $(this).val(str) if str

  bindEvents: ->
    instance = this
    for i in [0...target_number]
      $(".recallable_#{i}").on "focus", ->
        index = Recallable.elementToIndex(this)
        timer[index] = setInterval(=>
          instance.remember(this, index)
        , 2000)
      $(".recallable_#{i}").on "blur", ->
        index = Recallable.elementToIndex(this)
        instance.remember(this, index)
        clearInterval(timer[index])

  remember: (self, index) ->
    unless printed[index] == $(self).val()
      printed[index] = $(self).val()
      @_remember("recallable_#{index}", printed[index])

  _remember: (clazz, str)->
    # 暫定(1日)
    # TODO: ここはconfigで設定できるようにしたい。
    expire_min = 60 * 24
    data = {
      expire: @now() + expire_min * 60 * 1000,
      value: str
    }
    # console.log(str)
    localStorage.setItem(@_getRecallKey(clazz), JSON.stringify(data))

  _getRecallKey: (clazz)->
    "#{document.location.host}#{document.location.pathname}:#{clazz}"

  recall: (clazz)->
    @_recall(clazz) # or console.log("記憶しているデータがありません")

  _recall: (clazz)->
    json = JSON.parse(localStorage.getItem(@_getRecallKey(clazz)))
    if json and json.expire and (json.expire > @now()) and json.value
      json.value
    else
      null

  now: ->
    (new Date).getTime()

  @elementToIndex = (tag)->
     clazz = $(tag).attr("class")
     m = clazz.match(/recallable_([0-9]+)/)
     parseInt(m[1])

this.Recallable = Recallable
