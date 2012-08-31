require File.expand_path('../helper', __FILE__)

class TestExample < Test::Unit::TestCase
  def test_concurrent_average
    # clear out all data
    DataPointDocument.destroy_all

    pids = []
    # start some external clients to add values to the Riak server
    5.times do |t|
      pids << fork {
        `bundle exec rake example:create_data_points ROW=#{t}`
      }
    end
    pids.each do |pid|
      Process.waitpid(pid)
    end
    statistic = StatisticDocument.new('data_point_documents')
    statistic.compute!

    assert_equal 5000,  statistic.count
    assert_equal 49.672, statistic.average.round(3)
  end
end
