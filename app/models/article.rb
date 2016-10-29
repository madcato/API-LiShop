class Article < ActiveRecord::Base
  belongs_to :list
  # list_id, name, qty, category, type, shop, prize, checked
  validates :list_id, presence: true, numericality: true
  validates :name, presence: true
  validates :qty, presence: true, numericality: true
  validates :checked, presence: true, numericality: true
  
  self.inheritance_column = 'articleType'
  
  def objectId
    read_attribute(:id).to_s
  end
  
  def as_json(options={})
    options.merge!({:except => [:id]})
    result = super.as_json(options)
    resul = result.merge({:objectId => self.objectId})
  end
end

