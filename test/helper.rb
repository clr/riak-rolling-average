$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
ROOT_DIR = File.join(File.dirname(__FILE__),'..')

require 'test/unit'
require File.join(ROOT_DIR,'lib','riak_rolling_average')

Riak.disable_list_keys_warnings = true
