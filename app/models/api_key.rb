class ApiKey < ActiveRecord::Base
  belongs_to :list
  # list_id:integer api_key:string email:string owner:boolean
  validates :list_id, presence: true, numericality: true
  validates :api_key, presence: true
  validates :email, presence: true
  validates_format_of :email, :with => /.+@.+\..+/i
  validates :owner, presence: true
  validates :owner, :inclusion => {:in => [true, false]}
  
  
  before_validation :generateUniqueApiKey
  
  def generateUniqueApiKey
    self.api_key ||= generate_unique_secure_token()
  end

  def generate_unique_secure_token
    SecureRandom.base64(24)
  end
end
