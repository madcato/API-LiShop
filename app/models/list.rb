class List < ActiveRecord::Base
  has_many :api_keys
  has_many :articles
  
  validate :paymentIdentifier, presence: true
  validate :receipt, presence: true
end
