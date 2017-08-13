class Transaction < ApplicationRecord
	## Relationships
	belongs_to :user
	belongs_to :category

	## Friendly ID
 	extend FriendlyId 	
  friendly_id :tran_code, use: :slugged

	## Validations
	validates :description, :category_id, :transaction_date, :amount, :user_id, presence: true

	## Callbacks
	before_save :set_transaction_type

	def tran_code
		"tra#{Time.zone.now.to_i}"
	end

	def payment_type
		Rails.application.secrets.payment_types[payment_type_id]
	end

	def transaction_type
		Rails.application.secrets.transaction_types[transaction_type_id]
	end

	private

	def set_transaction_type
		self.transaction_type_id = category.category_type_id
	end

	def should_generate_new_friendly_id?
  	description_changed?
	end	

end
