###
  QuoDatePicker
  (c) 2011, 2012 Iñigo Gonzalez Vazquez (@haas85)
  http://ingonza.com
###

quoDatePicker = ((quo) ->
    launcherInput = {}
    window.mq = {}
    names = {days:['Mon','Tue','Wed','Thu','Fri','Sat','Sun'], months:['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']}
    selectedDate = {}
    init = ()->
        quo('input.quoDatePicker').tap onFieldTap
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
    showDatePicker = (input) ->
        launcherInput = input
        removePicker()
        picker = document.createElement('div')
        picker.id = "quoDatePicker"
        picker.innerHTML = '<div class="dateContainer"><div class="actualDate"></div><div class="dcontainer"><p id="plusd" class="plusdate datebutton">+</p><input class="tdays dateinput
            " size="2" maxlength="2" type="number" max="31" min="1" format="[0-9]*"/><span>/</span><div style="clear:both"></div><p id="minusd" class="minusdate datebutton">-</p></div><div class="mcontainer"><p id="plusm" class="plusdate datebutton">+</p><input class="tmonths dateinput" size="2" maxlength="2" type="number" max="12" min="1" format="[0-9]*"/><span>/</span><div style="clear:both"></div><p id="minusm" class="minusdate datebutton">-</p></div><div class="ycontainer"><p id="plusy" class="plusdate datebutton">+</p><input class="tyears dateinput" size="4" maxlength="4" type="number" max="9999" min="00" format="[0-9]*"/><div style="clear:both"></div><p id="minusy" class="minusdate datebutton">-</p></div><div class="accept">OK</div></div>'
        input.parentNode.insertBefore picker
        setSize()
        setPosition input
        datebutton = quo '.datebutton'
        accept = quo '.accept'
        datebutton.off 'tap'
        accept.off 'tap'
        datebutton.on 'tap', onButtonTap
        accept.on 'tap', setDate
        re = new RegExp "[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]","i"
        if not input.value.match re
            selectedDate = new Date()
        else
            selectedDate.setDate input.value.split('/')[0]
            selectedDate.setMonth parseInt input.value.split('/')[1] - 1
            selectedDate.setYear input.value.split('/')[2]
        showDate()
    setSize = ->
        if not window.quomobile
            buttonwidth = (400 / 3) - 3
            inputwidth = buttonwidth - 20
            quo('.datebutton').style 'width',"#{buttonwidth}px"
            quo('input.dateinput').style 'width',"#{inputwidth}px"
        else
            containerWidth = Quo.environment().screen.width - 60
            $$('.dateContainer').style 'width', "#{containerWidth}px"
            buttonwidth = (containerWidth/3) - 3;
            $$('.datebutton').style 'width', "#{buttonwidth}px"
            $$('input.dateinput').style 'width', "#{buttonwidth - 20}px"
    setPosition = (input) ->
        bgr = quo '#quoDatePicker'
        if window.quomobile
            pickwin = bgr.children '.dateContainer'
            pickwin.style 'margin-left', "#{(bgr[0].offsetWidth - pickwin[0].offsetWidth)/2}px"
            pickwin.style 'margin-top', "#{(bgr[0].offsetHeight - pickwin[0].offsetHeight)/2}px"
        else
            margLeft = input.offsetLeft
            margTop = input.offsetTop
            bodywidth = quo('body')[0].offsetWidth
            pickerwidth = quo('#quoDatePicker .dateContainer')[0].offsetWidth
            if margLeft+pickerwidth < bodywidth
                bgr.style 'margin-left', margLeft
            else
                bgr.style 'margin-left', bodywidth - pickerwidth
    onFieldTap = ->
        showDatePicker this
    onButtonTap = ->
        id = this.id
        switch id
            when "plusd" then changeDate("PLUS",'DAY')
            when "minusd" then changeDate("MINUS",'DAY')
            when "plusm" then changeDate("PLUS",'MONTH')
            when "minusm" then changeDate("MINUS",'MONTH')
            when "plusy" then changeDate("PLUS",'YEAR')
            when "minusy" then changeDate("MINUS",'YEAR')
    changeDate = (action,type) ->
        if type == 'DAY'
            switch action
                when 'PLUS' then selectedDate.setDate selectedDate.getDate() + 1
                when 'MINUS' then selectedDate.setDate selectedDate.getDate() - 1
        else if type == 'MONTH'
            switch action
                when 'PLUS' then selectedDate.setMonth selectedDate.getMonth() + 1
                when 'MINUS' then selectedDate.setMonth selectedDate.getMonth() - 1
        else if type == 'YEAR'
            switch action
                when 'PLUS' then selectedDate.setFullYear selectedDate.getFullYear() + 1
                when 'MINUS' then selectedDate.setFullYear selectedDate.getFullYear() - 1
        showDate()
    showDate = ->
        quo('.tdays')[0].value = selectedDate.getDate()
        quo('.tmonths')[0].value = selectedDate.getMonth() + 1
        quo('.tyears')[0].value = selectedDate.getFullYear()
        quo('.actualDate').html("#{names['days'][selectedDate.getDay()]}, #{names['months'][selectedDate.getMonth()]} #{selectedDate.getDate()}, #{selectedDate.getFullYear()}")
    pad = (num) ->
        str = '' + num
        str = '0' + str until str.length == 2
        str
    unpad = (num) ->
        if num[0] == '0'
            num[1]
        else
            num
    setDate  = ->
        days = quo('.tdays')[0]
        months = quo('.tmonths')[0]
        years = quo('.tyears')[0]
        if not isNaN days.value and days.value isnt "" and not isNaN months.value and months.value isnt "" and not isNaN years.value and years.value isnt ""
            launcherInput.value = "#{pad(days.value)}/#{pad(months.value)}/#{years.value}"
            removePicker()
    removePicker = ->
        prev = document.querySelectorAll '#quoDatePicker'
        if prev.length isnt 0
            prev[0].parentNode.parentNode.removeChild prev[0].parentNode
    {
        init:init,
    }
)(Quo)

quoDatePicker.init()