# == Schema Information
#
# Table name: reservations
#
#  id            :integer          not null, primary key
#  first_name    :string(255)
#  last_name     :string(255)
#  phone         :string(255)
#  email         :string(255)
#  special_notes :text
#  time          :datetime
#  user_id       :integer
#  place_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  persons       :integer
#  is_sms_send   :boolean          default(FALSE)
#  phone_code_id :integer
#
# Indexes
#
#  index_reservations_on_place_id  (place_id)
#  index_reservations_on_user_id   (user_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reservation do
    first_name "MyString"
    last_name "MyString"
    phone "MyString"
    email "MyString"
    special_notes "MyText"
  end
end
