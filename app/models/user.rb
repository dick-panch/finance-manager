class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #:timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable

  ## Friendly ID
 	extend FriendlyId 	
  friendly_id :username, use: :slugged

  ## Relationship
  has_many :categories
  has_many :transactions, dependent: :destroy

  belongs_to :setting, dependent: :destroy
  accepts_nested_attributes_for :setting

  has_many :balances, dependent: :destroy
  
  ## Callback
  after_create :create_default_setting

  ## Callback Methods
  def create_default_setting
  	self.create_setting
  end

  def is_admin?
  	self.role_id == 2
  end
end
