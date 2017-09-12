class Category < ApplicationRecord
	## Friendly ID
 	extend FriendlyId 	
  friendly_id :name, use: :slugged

	## Relationships
	belongs_to :user, optional: true
	has_many :budgets, dependent: :destroy
	has_many :transactions
	## Scopes
	scope :main, -> {where('categories.user_id IS NULL')}

	# Validations
	validates :name, :category_type_id, presence: true
	validates :name, uniqueness: {scope: :user_id}

	def category_type
		Rails.application.secrets.category_types[category_type_id]
	end
end
