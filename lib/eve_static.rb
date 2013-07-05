require "eve_static/version"
require 'bundler'

Bundler.require(:default)

module EveStatic
  autoload :Database, 'eve_static/database.rb'
  autoload :Coerce, 'eve_static/coerce.rb'
  
  module Queries
    autoload :Basic, 'eve_static/queries/basic.rb'
    autoload :Industry, 'eve_static/queries/industry.rb'
  end
end
