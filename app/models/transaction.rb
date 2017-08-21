class Transaction < ApplicationRecord
	## Relationships
	belongs_to :user
	belongs_to :category

	extend ImportTransaction

	## Friendly ID
 	extend FriendlyId 	
  friendly_id :tran_code, use: :slugged

  ## Temp. Fields
  attr_accessor :file
	## Validations
	validates :description, :category_id, :transaction_date, :amount, :user_id, presence: true

	## Callbacks
	before_save :set_transaction_type
	before_save :set_month_and_year

	## Scopes
	scope :expenses, -> {where('transactions.transaction_type_id = ?', 1)}
	scope :incomes, -> {where('transactions.transaction_type_id = ?', 2)}


	def tran_code
		"tra#{Time.zone.now.to_i}"
	end

	def payment_type
		Rails.application.secrets.payment_types[payment_type_id]
	end

	def transaction_type
		Rails.application.secrets.transaction_types[transaction_type_id]
	end

	def self.search(params)
		q = {}
		month = params[:month].present? ? params[:month].to_i : Date.today.month
		year 	= params[:year].present? ? params[:year].to_i : Date.today.year
		q.merge!(month: "month = #{month}", year: "year = #{year}")
		q.merge!(type: "transaction_type_id = #{params[:type_id]}") if params[:type_id].present?
		q.merge!(category: "category_id = #{params[:category_id]}") if params[:category_id].present?
		where(q.values.join(' and '))
	end

	def self.import(file, user)
		import_general_transactions(file, user)
	end

	private

	## Callback Methods -----------------------------------------
	def set_transaction_type
		self.transaction_type_id = category.category_type_id
	end

	def set_month_and_year
		self.month = self.transaction_date.month
		self.year = self.transaction_date.year
	end

	## Friendly ID Method ---------------------------------------
	def should_generate_new_friendly_id?
  	description_changed?
	end	

end
