require File.expand_path('../helper', __FILE__)

class TestExample < Test::Unit::TestCase
  def setup
    pids = []
    # start some external clients to add values to the Riak server
    5.times do |t|
      pids << fork {
        `bundle exec rake example:create_data_points ROW=#{t} CLIENT=local#{t}`
      }
    end
    pids.each do |pid|
      Process.waitpid(pid)
    end
  end

  def test_concurrent_average
    statistic = StatisticDocument.find('data_point_document_statistic')
    assert_equal 5000,  statistic.count
    assert_equal 49.672, statistic.average.round(3)
  end
end
