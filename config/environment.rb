# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# Rails.logger = Logger.new(STDOUT)
# Rails.logger = Log4r::Logger.new("Application Log")
# config.log_level = :debug


$categorynames = ['Knowledge', 'Skills', 'Ability']

$colors = ['red', 'yellow', 'green']

$graph_labels = ['Totals','Knowledge', 'Skills', 'Ability']

