require 'ripple'

class DataPointDocument
  include Ripple::Document
  property :value, Integer, :presence => true
end
