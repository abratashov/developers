# == Schema Information
#
# Table name: reviews
#
#  id              :integer          not null, primary key
#  reviewable_id   :integer
#  food            :integer
#  service         :integer
#  pricing         :integer
#  ambiance        :integer
#  reviewable_type :string(255)
#  title           :string(255)
#  content         :text
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_reviews_on_reviewable_id_and_reviewable_type  (reviewable_id,reviewable_type)
#  index_reviews_on_user_id                            (user_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :review do
    reviewable_id 1
    reviewable_type "MyString"
    content "MyText"
  end
end
