Efflux
======

Efflux displays executes system commands and streams the output live to the browser, using Javascript Events. It has both a serverside rails component to make it easy to setup the command streaming and a javascript/css component for displaying the data retrieved from the socket.

It was created to provide an easy way to display log tails and deployment script outputs in maintenence systems for applications.

## Usage

Add the efflux gem to your gemfile

      gem 'efflux'

To use the client side component add the javascript and css files to your project.

Add the following to your application.js

      //= require efflux
      
Add the following to your application.css

      *= require efflux

### Controller Actions

To stream a command you must add a dedicated controller action for the browser to maintain a connection to. In a controller include the `Efflux::Stream` module and call `stream_cmd` from an action inside the controller.

    class MyController < ApplicationController
      include Efflux::Stream
      
      def stream_command
        stream_cmd 'ls -la' 
      end
    end

### Client-side implmentation

Efflux comes with a jQuery plugin to implement the client side functionality. For example:

Given the following html:

    <div class=".command-output"></div>

It could be invoked through javascript like this:

    $('.command-output').efflux({
        url: '/command_stream'
    });

The plugin supports the following options:

* __title__ - A title that will display in the header of the window. (_optional_)
* __url__ - The url to the streaming action. (_required_)
