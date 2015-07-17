class List < ActiveRecord::Base
  has_many :api_keys, :dependent => :delete_all
  has_many :articles, :dependent => :delete_all
  
  validate :paymentIdentifier, presence: true
  validate :receipt, presence: true
end
