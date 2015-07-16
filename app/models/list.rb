class List < ActiveRecord::Base
  has_many :api_keys
  has_many :articles
end
