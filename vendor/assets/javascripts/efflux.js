(function() {
  var Efflux,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  $.fn.extend({
    efflux: function(options) {
      return this.each(function(index, elem) {
        return new Efflux(elem, options);
      });
    }
  });

  $(function() {
    return $('.spec-terminal').efflux({
      url: '/command_stream',
      title: 'rspec'
    });
  });

  Efflux = (function() {
    Efflux.prototype.e_source = void 0;

    Efflux.prototype.socket_open = false;

    Efflux.prototype.lines = 0;

    Efflux.prototype.title = '';

    Efflux.prototype.run_time = 0;

    Efflux.prototype.container = void 0;

    Efflux.prototype.running = false;

    function Efflux(elem, options) {
      this.format_runtime = __bind(this.format_runtime, this);
      this.update_timer = __bind(this.update_timer, this);
      this.get_status = __bind(this.get_status, this);
      this.build_console = __bind(this.build_console, this);
      this.data_received = __bind(this.data_received, this);
      this.socket_error = __bind(this.socket_error, this);
      this.socket_open = __bind(this.socket_open, this);
      this.e_source = new EventSource(options.url);
      this.e_source.onerror = this.socket_error;
      this.e_source.onopen = this.socket_open;
      this.e_source.addEventListener('command.data', this.data_received);
      this.container = $(elem);
      this.title = options.title || '';
      this.build_console();
    }

    Efflux.prototype.socket_open = function(e) {
      this.running = true;
      return this.clock_timer = setTimeout(this.update_timer, 1000);
    };

    Efflux.prototype.socket_error = function(e) {
      e.target.close();
      this.running = false;
      clearTimeout(this.clock_timer);
      return this.update_timer();
    };

    Efflux.prototype.data_received = function(e) {
      var auto_scroll, console_height, scroll_height, scroll_top;
      this.lines++;
      scroll_top = this.container.find('.console').scrollTop();
      console_height = this.container.find('.console').outerHeight();
      scroll_height = this.container.find('.console')[0].scrollHeight;
      auto_scroll = scroll_height - scroll_top === console_height || scroll_top === 0;
      this.container.find('.console pre').append(e.data);
      this.container.find('.console').stop();
      if (auto_scroll) {
        return this.container.find('.console').animate({
          scrollTop: this.container.find('.console')[0].scrollHeight
        }, 500);
      }
    };

    Efflux.prototype.build_console = function() {
      var status, _ref;
      status = (_ref = this.running) != null ? _ref : {
        'Running': 'Finished'
      };
      return this.container.html("<div class=\"console-frame\"> <div class=\"statusbar\"> <div class=\"title\">" + this.title + " [Starting] -  00m:00s</div> <button type=\"button\" class=\"fullscreen\"/> </div> <div class=\"console\"><pre></pre> </div> </div>");
    };

    Efflux.prototype.get_status = function() {
      if (this.running) {
        return 'Running';
      } else {
        return 'Finished';
      }
    };

    Efflux.prototype.update_timer = function() {
      this.run_time++;
      this.container.find('.title').html("" + this.title + " [" + (this.get_status()) + "] - " + (this.format_runtime()));
      if (this.running) {
        return setTimeout(this.update_timer, 1000);
      }
    };

    Efflux.prototype.format_runtime = function() {
      var minutes, seconds;
      seconds = this.run_time;
      minutes = 0;
      if (seconds > 60) {
        minutes = seconds / 60;
        seconds = seconds - (minutes * 60);
      }
      return "" + (this.pad(minutes, 2)) + "m:" + (this.pad(seconds, 2)) + "s";
    };

    Efflux.prototype.pad = function(val, length, padChar) {
      var numPads;
      if (padChar == null) {
        padChar = '0';
      }
      val += '';
      numPads = length - val.length;
      if (numPads > 0) {
        return new Array(numPads + 1).join(padChar) + val;
      } else {
        return val;
      }
    };

    return Efflux;

  })();

}).call(this);
