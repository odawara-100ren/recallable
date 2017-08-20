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
      val = self.recall(clazz)
      $(this).val(val) if val

  bindEvents: ->
    instance = this
    for i in [0...target_number]
      $(".recallable_#{i}").on "focus", ->
        index = Recallable.elementToIndex(this)
        # fat arrow の場合
        timer[index] = setInterval( =>
          unless printed[index] == $(this).val()
            printed[index] = $(this).val()
            instance.remember("recallable_#{index}", printed[index])
        , 2000)
      ##  thin arrow の場合
      # $(".recallable_#{i}").on "focus", ->
      #   index = Recallable.elementToIndex(this)
      #   self = this
      #   timer[index] = setInterval(->
      #     unless printed[index] == $(self).val()
      #       printed[index] = $(self).val()
      #       instance.writeCookie("#{index}: #{printed[index]}")
      #   , 2000)
      $(".recallable_#{i}").on "blur", ->
        index = Recallable.elementToIndex(this)
        # blurのタイミングでもrememberする
        # TODO: 関数化
        unless printed[index] == $(this).val()
          printed[index] = $(this).val()
          instance.remember("recallable_#{index}", printed[index])
        clearInterval(timer[index])
  # 記憶する
  remember: (clazz, val)->
    console.log(val)
    @setExpireMin(clazz, val, 1)

  setExpireMin: (clazz, value, expire_min)->
    unless expire_min
      alert("expire_minが指定されていません。")
      return
    data = {
      expire: ((new Date).getTime() + expire_min * 60) * 1000,
      value: value
    }
    localStorage.setItem(@getRecallKey(clazz), JSON.stringify(data))

  getRecallKey: (clazz)->
    "#{document.location.host}#{document.location.pathname}:#{clazz}"

  # 思い出す
  recall: (clazz)->
    # 暫定
    console.log("read cookie and set values.")
    val = JSON.parse(localStorage.getItem(@getRecallKey(clazz))).value
    if val
      console.log("Recalled: #{val}")
      return val
    else
      console.log("記憶しているデータがありません")

  @elementToIndex = (tag)->
     clazz = $(tag).attr("class")
     m = clazz.match(/recallable_([0-9]+)/)
     parseInt(m[1])

this.Recallable = Recallable
