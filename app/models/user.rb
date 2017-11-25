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
  has_many :budgets, dependent: :destroy

  ## Callback
  after_create :create_default_setting

  ## Scopes
  scope :my_users, -> {where('users.role_id = ?', 1)}
  ## Callback Methods
  def create_default_setting
  	self.create_setting
  end

  def is_admin?
  	self.role_id == 2
  end

  def role
    Rails.application.secrets.roles[role_id]
  end
end
