require 'test/unit'

PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$LOAD_PATH << File.join(PROJECT_ROOT, 'bin')

require 'util'
require 'rule'
require 'check'
require 'and'
require 'or'
require 'has'
require 'not'

