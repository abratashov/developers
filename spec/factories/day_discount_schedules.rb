# == Schema Information
#
# Table name: day_discount_schedules
#
#  id          :integer          not null, primary key
#  place_id    :integer
#  day_type_id :integer
#  is_running  :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_day_discount_schedules_on_day_type_id  (day_type_id)
#  index_day_discount_schedules_on_place_id     (place_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :day_discount_schedule do
  end
end
