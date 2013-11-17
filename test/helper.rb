require 'test/unit'

PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$LOAD_PATH << File.join(PROJECT_ROOT, 'bin')

require 'util/util'
require 'util/rule'
require 'util/check'
require 'util/and'
require 'util/or'
require 'util/has'
require 'util/not'

