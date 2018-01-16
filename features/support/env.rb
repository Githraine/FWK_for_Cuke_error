# gems
require 'rubygems'
require 'rspec'
require 'page-object'
require 'require_all'
require 'fig_newton'
require 'restclient'
require 'httparty'
require './fast-selenium'
require 'openssl'
#require 'dbi'
require 'eyes_selenium'

# std lib
require 'yaml'
require 'uri'
require 'cgi'

# require_all gem
require_rel 'lib'
require_rel 'pages'
require_rel 'services'
require 'page-object/page_factory'
require 'watir-scroll'



World(PageObject::PageFactory)
