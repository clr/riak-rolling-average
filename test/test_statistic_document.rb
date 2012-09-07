require File.expand_path('../helper', __FILE__)

class TestStatisticDocument < Test::Unit::TestCase
  def test_updating_simple_values
    # clear out all data
    DataPointDocument.destroy_all

    DataPointDocument.create(:value => 10)
    DataPointDocument.create(:value => 5)
    DataPointDocument.create(:value => 12)

    # this is an eventually consistent system after all :-)
    sleep 5

    statistic = StatisticDocument.new('data_point_documents')
    statistic.compute!

    assert_equal 3,  statistic.count
    assert_equal 9.0, statistic.average
  end
end
