class DayDiscount < ActiveRecord::Base
  attr_accessible :week_day_id, :from_time, :to_time, :discount, :title, :description

  belongs_to :week_day

  translates :title, :description

  include Utils::Models::Base
  include Utils::Models::Translations


end
# == Schema Information
#
# Table name: day_discounts
#
#  id          :integer          not null, primary key
#  week_day_id :integer
#  from_time   :decimal(4, 2)
#  to_time     :decimal(4, 2)
#  discount    :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_day_discounts_on_week_day_id  (week_day_id)
#
