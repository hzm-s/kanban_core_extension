class BoardRecord < ActiveRecord::Base
  has_many :card_records
end
