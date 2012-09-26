###
  QuoDatePicker
  (c) 2011, 2012 Iñigo Gonzalez Vazquez (@haas85)
  http://ingonza.com
###

quoTimePicker = ((quo) ->
    launcherInput = {}
    window.mq = {}
    init = ()->
        quo('input.quoTimePicker').tap onFieldTap
        window.quomobile = false
        if matchMedia
            mq = window.matchMedia "(max-width: 980px)"
            mq.addListener widthChange
            widthChange mq
    widthChange = (mq) ->
        if mq.matches
            window.quomobile = true
        else
            window.quomobile = false
    showTimePicker = (input) ->
        launcherInput = input
        removePicker()
        picker = document.createElement('div')
        picker.id = "quoTimePicker"
        picker.innerHTML = '<div class="tcontainer"><div class="hcontainer"><p id="plush" class="plustime timebutton">+</p><input class="thours timeinput" size="2" maxlength="2" type="number" max="23" min="00" format="[0-9]*"/><span>:</span><div style="clear:both;"></div><p id="minush" class="minustime timebutton">-</p></div><div class="mcontainer"><p id="plusm" class="plustime timebutton">+</p><input class="tminutes timeinput" size="2" maxlength="2" type="number" max="59" min="00" pattern="[0-9]*"/><div style="clear:both;"></div><p id="minusm" class="minustime timebutton">-</p></div><div class="accept">OK</div></div>'
        input.parentNode.insertBefore(picker,input.nextSibling)
        setSize()
        setPosition(input)
        tbuttons = quo('.timebutton')
        accept = quo('.accept')
        tbuttons.off 'tap'
        accept.off 'tap'
        tbuttons.on 'tap', onButtonTap
        accept.on 'tap', setTime
        re = new RegExp "[0-9][0-9]:[0-9][0-9]","i"
        if not input.value.match re
            quo('.thours')[0].value = 0
            quo('.tminutes')[0].value = 0
        else
            quo('.thours')[0].value = unpad(input.value.split(":")[0])
            quo('.tminutes')[0].value = unpad(input.value.split(":")[1])
    setSize = ->
        if not window.quomobile
            buttonwidth = (350 / 2) - 3
            inputwidth = buttonwidth - 20
            quo('.timebutton').style 'width',"#{buttonwidth}px"
            quo('input.timeinput').style 'width',"#{inputwidth}px"
        else
            containerWidth = Quo.environment().screen.width / 2
            $$('.tcontainer').style 'width', "#{containerWidth}px"
            buttonwidth = (containerWidth/2) - 3;
            $$('.timebutton').style 'width', "#{buttonwidth}px"
            $$('input.timeinput').style 'width', "#{buttonwidth - 20}px"
    setPosition = (input) ->
        bgr = quo '#quoTimePicker'
        if window.quomobile
            pickwin = bgr.children '.tcontainer'
            pickwin.style 'margin-left', "#{(bgr[0].offsetWidth - pickwin[0].offsetWidth)/2}px"
            pickwin.style 'margin-top', "#{(bgr[0].offsetHeight - pickwin[0].offsetHeight)/2}px"
        else
            margLeft = input.offsetLeft
            margTop = input.offsetTop
            bodywidth = quo('body')[0].offsetWidth
            pickerwidth = quo('#quoTimePicker .tcontainer')[0].offsetWidth
            if margLeft+pickerwidth < bodywidth
                bgr.style 'margin-left', "#{margLeft}px"
            else
                bgr.style 'margin-left', "#{bodywidth - pickerwidth}px"
    onFieldTap = ->
        showTimePicker this
    onButtonTap = ->
        id = this.id
        switch id
            when "plush" then changeTime("PLUS",quo('.thours')[0], 23)
            when "minush" then changeTime("MINUS",quo('.thours')[0], 23)
            when "plusm" then changeTime("PLUS",quo('.tminutes')[0], 59)
            when "minusm" then changeTime("MINUS",quo('.tminutes')[0],59 )
    changeTime = (action,elem,maxval) ->
            if action == "PLUS"
                if elem.value < maxval
                    elem.value++
                else
                    elem.value = 0
            else
                if action == "MINUS"
                    if elem.value > 0
                        elem.value--
                    else
                        elem.value = maxval
    pad = (num) ->
        str = '' + num
        str = '0' + str until str.length == 2
        str
    unpad = (num) ->
        if num[0] == '0'
            num[1]
        else
            num
    setTime  = ->
        hours = quo('.thours')[0]
        minutes = quo('.tminutes')[0]
        if not isNaN hours.value and hours.value isnt "" and not isNaN minutes.value and minutes.value isnt ""
            launcherInput.value = "#{pad(hours.value)}:#{pad(minutes.value)}"
            removePicker()
    removePicker = ->
        prev = document.querySelectorAll '#quoTimePicker'
        if prev.length isnt 0
            prev[0].parentNode.removeChild prev[0]
    {
        init:init,
    }
)(Quo)

quoTimePicker.init()
