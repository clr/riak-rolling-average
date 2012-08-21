require File.expand_path('../helper', __FILE__)

class TestExample < Test::Unit::TestCase
  def setup
    pids = []
    start_time = Time.now

    # start some external clients to add values to the Riak server
    2.times do |t|
      pids << fork {
        `bundle exec rake example:create_data_points_#{t} --trace`
      }
    end
    pids.each do |pid|
      Process.waitpid(pid)
    end
    puts "Processed data import in #{Time.now - start_time} seconds."
  end

  def test_concurrent_average
    statistic = StatisticDocument.find('data_point_document_statistic')
    assert_equal 2000,    statistic.count
    assert_equal 49.46, statistic.average
#    assert_equal 49.6724, statistic.average
  end
end
