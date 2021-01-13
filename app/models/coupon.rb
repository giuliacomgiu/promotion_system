class Coupon < ApplicationRecord
  belongs_to :promotion

  enum status: { active: 0, archived: 1 }
end
