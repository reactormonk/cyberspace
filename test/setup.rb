# Add PROJECT/lib to $LOAD_PATH
$LOAD_PATH.unshift(File.expand_path("#{__FILE__}/../../lib"))

# Ensure baretest is required
require 'baretest'

# Some defaults on BareTest (see Kernel#BareTest)
BareTest do
  require_baretest "0.4.1" # minimum baretest version to run these tests
  require_ruby     "1.9.1" # minimum ruby version to run these tests
  use              :support # Use :support in all suites
end
