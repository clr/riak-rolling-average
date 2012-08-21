require 'ripple'

class DataPointDocument
  include Ripple::Document
  property :value, Integer, :presence => true
  after_save :update_statistics

  def update_statistics
    id = 'data_point_document_statistic'
    statistic = StatisticDocument.find(id) || StatisticDocument.new
    statistic.key = id
    statistic.update_with self.value
  end
end
