require 'ripple'

class StatisticDocument
  include Ripple::Document
  property :count,         Integer, :presence => true
  property :average,       Float,   :presence => true
  property :prior_average, Float

  def update_with(value)
    self.prior_average = self.average
    self.count         = (self.count || 0) + 1
    self.average       = ((self.count - 1) * (self.average || 0.0) + value).to_f / self.count
    self.save
    self.reload
  end

  on_conflict do |siblings, c|
    siblings.reject!{|s| s.count == nil || s.average == nil}

    floor = siblings.map(&:count).min - 1
    if floor > 0 && (prior_average = siblings.detect{|s| s.count == (floor + 1)}.prior_average)
      floor_average = floor * prior_average
    else
      floor_average = 0
    end

    self.count    = floor + siblings.map{|s| s.count - floor}.sum
    self.average  = (floor_average + (siblings.map{|s| s.average * s.count - floor_average}.sum)) / self.count
  end
end

