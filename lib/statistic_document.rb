require 'ripple'

class StatisticDocument
  attr_reader :average, :count

  def initialize(bucket_name)
    @bucket_name = bucket_name
  end

  def compute!
    mapred = Riak::MapReduce.new(Ripple.client)
    mapred.add @bucket_name
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
      match = riakObject.values[0].data.match(/\"value\":([\\d]+)/);
      if(match){
        return [[parseInt(match[1]), 1]];
      } else {
        return [null];
      }
    }
    MAP
  end

  def reduce_javascript
    <<-REDUCE
    function(values){
//    ejsLog('map_reduce.log', values);
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
