require 'spec_helper'

describe PlaceAdministrator do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: place_administrators
#
#  id         :integer          not null, primary key
#  place_id   :integer
#  name       :string(255)
#  email      :string(255)
#  phone      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_place_administrators_on_place_id  (place_id)
#

