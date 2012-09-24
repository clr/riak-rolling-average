require 'ripple'

class StatisticDocument
  include Ripple::Document
  property :client_average, Float,   :presence => true
  property :client_count,   Integer, :presence => true

  def update_with(value)
    key = "#{self.key}_#{Client.id}"
    proxy = StatisticDocument.find(key) || StatisticDocument.new
    proxy.key = key
    proxy.client_average ||= 0.0
    proxy.client_count   ||= 0
    proxy.client_average = (proxy.client_average * proxy.client_count + value).to_f / (proxy.client_count + 1)
    proxy.client_count   = proxy.client_count + 1
    proxy.save
  end

  def count
    self.class.find(Client.all_ids(self.key)).reject(&:nil?).map(&:client_count).inject(0, &:+)
  end

  def average
    self.class.find(Client.all_ids(self.key)).reject(&:nil?).map{|h| h.client_count * h.client_average}.inject(0, &:+).to_f / self.count
  end
end

# in order to prevent read-your-write corruption in a failure scenario, pr + pw > N
# and in this case N = 3, so:
StatisticDocument.bucket.props = StatisticDocument.bucket.props.merge(:pr => 2, :pw => 2)
