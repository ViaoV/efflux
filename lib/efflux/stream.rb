require 'open3'
module Efflux
    module Stream
        include ActionController::Live
        def stream_cmd(cmd)
            response.headers["Content-Type"] = "text/event-stream"
            Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr| 
                output = ""
                last_output = Time.current
                while line = stdout.gets
                    output += console_to_html(line)
                    if last_output < 1.seconds.ago 
                        response.stream.write "event: command.data\n" 
                        response.stream.write "data: #{output}\n\n"
                        last_output = Time.current
                        output = ""
                    end
                end
                response.stream.write "event: command.data\n" 
                response.stream.write "data: #{output}<br/><div class=\"command-finished\">Command Finished at: #{Time.current}</div>\n\n"
            end
        rescue IOError => e
            response.stream.close
        ensure
            response.stream.close
        end

        def console_to_html(string)
            string.gsub!("\n", '<br/>')
            if string =~ /\[[0-9]{1,2}/
                string.gsub!('[32m', '<span class="foreground-green">')
                string.gsub!('[0m','</span>')
                string = %Q{<span class="foreground-green">#{string}</span>}
            end
            return string
        end
    end
end
