# -*- encoding : utf-8 -*-
require 'active_support/inflector'
require 'active_support/core_ext'

require 'colorize'

require 'hashr'
require 'curb'
require 'yajl'

require File.join(File.dirname(__FILE__),"notes-client/notes_client")
require File.join(File.dirname(__FILE__),"notes-client/notes_array")
require File.join(File.dirname(__FILE__),"notes-client/notes_object")
require File.join(File.dirname(__FILE__),"notes-client/objects/note")
