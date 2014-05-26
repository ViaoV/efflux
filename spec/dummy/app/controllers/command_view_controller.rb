class CommandViewController < ApplicationController
    include Efflux::Stream
    def console_command
    end
    def stream_command
        stream_cmd 'for i in {1..50}; do echo "test\ntest\ntest"; sleep 1; done'
    end
end
