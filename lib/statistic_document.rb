require 'ripple'

class StatisticDocument
  include Ripple::Document
  property :client_average, Float,   :presence => true
  property :client_count,   Integer, :presence => true
  attr_reader :average, :count

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

  def compute!
    mapred = Riak::MapReduce.new(Ripple.client)
    Client.all_ids(self.key).each do |key|
      mapred.add [self.class.bucket_name, key]
    end
    mapred.map(map_javascript, :keep => false)
    mapred.reduce(reduce_javascript, :keep => true)
    results = mapred.run
    @average = results[0][0]
    @count   = results[0][1]
  end

  private
  def map_javascript
    <<-MAP
    function(riakObject){
      average_match = riakObject.values[0].data.match(/\"client_average\":([\\d.]+)/);
      count_match   = riakObject.values[0].data.match(/\"client_count\":([\\d]+)/);
      if(average_match && count_match){
        return [[parseFloat(average_match[1]), parseInt(count_match[1])]];
      } else {
        return [null];
      }
    }
    MAP
  end

  def reduce_javascript
    <<-REDUCE
    function(values){
      var sum = 0.0;
      var count = 0;
      for(i=0; i<values.length; i++){
        value = values[i];
        if(value){
          sum = sum + (value[0] * value[1]);
          count = count + value[1];
        }
      }
      if(count > 0) {
        return [[(sum / count), count]];
      } else {
        return [];
      }
    }
    REDUCE
  end
end

# in order to prevent read-your-write corruption in a failure scenario, pr + pw > N
# and in this case N = 3, so:
StatisticDocument.bucket.props = StatisticDocument.bucket.props.merge(:pr => 2, :pw => 2)
