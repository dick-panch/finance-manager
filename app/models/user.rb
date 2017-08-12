class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #:timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable

  ## Relationship
  has_many :categories

  def is_admin?
  	self.role_id == 2
  end
end
