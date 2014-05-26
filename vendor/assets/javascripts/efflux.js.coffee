$.fn.extend
    efflux: (options) ->
        return @each  (index, elem)->
            new Efflux(elem, options)





$ ->
    $('.spec-terminal').efflux
        url: '/command_stream'
        title: 'rspec'








class Efflux
    e_source: undefined
    socket_open: false
    lines: 0
    title: ''
    run_time: 0
    container: undefined
    running: false
    constructor: (elem, options) ->
        @e_source = new EventSource(options.url)
        @e_source.onerror = @.socket_error
        @e_source.onopen = @.socket_open
        @e_source.addEventListener 'command.data', @.data_received
        @container = $(elem)
        @title = options.title || ''
        @build_console()
    socket_open: (e) =>
        @running = true
        @clock_timer = setTimeout(@update_timer, 1000)
    socket_error: (e) =>
        e.target.close()
        @running = false
        clearTimeout @clock_timer
        @update_timer()
    data_received: (e) =>
        @lines++
        scroll_top = @container.find('.console').scrollTop()
        console_height = @container.find('.console').outerHeight()
        scroll_height = @container.find('.console')[0].scrollHeight
        auto_scroll = (scroll_height - scroll_top == console_height || scroll_top == 0)
        @container.find('.console pre').append(e.data)
        @container.find('.console').stop()
        if auto_scroll
            @container.find('.console').animate({
                scrollTop: @container.find('.console')[0].scrollHeight
            }, 500)
    build_console: () =>
        status = (@running) ? 'Running' : 'Finished'
        @container.html "
        <div class=\"console-frame\">
        <div class=\"statusbar\">
        <div class=\"title\">#{@title} [Starting] -  00m:00s</div>
            <button type=\"button\" class=\"fullscreen\"/>
        </div>
        <div class=\"console\"><pre></pre>
        </div>
        </div>
        "
    get_status: =>
        if @running
            return 'Running'
        else
            return 'Finished'
    update_timer: () =>
        @run_time++
        @container.find('.title').html "#{@title} [#{@get_status()}] - #{@format_runtime()}"
        setTimeout @update_timer, 1000 if @running
    format_runtime: =>
        seconds = @run_time
        minutes = 0
        if seconds > 60
            minutes = seconds / 60
            seconds = seconds - (minutes * 60)
        return "#{@pad(minutes,2)}m:#{@pad(seconds,2)}s"
    pad: (val, length, padChar = '0') ->
        val += ''
        numPads = length - val.length
        if (numPads > 0) then new Array(numPads + 1).join(padChar) + val else val




