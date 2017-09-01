class Transaction < ApplicationRecord
	## Relationships
	belongs_to :user
	belongs_to :category

	extend ImportTransaction
	include MyBalance

	## Friendly ID
 	extend FriendlyId 	
  friendly_id :tran_code, use: :slugged

  ## Temp. Fields
  attr_accessor :file
	## Validations
	validates :description, :category_id, :transaction_date, :amount, :user_id, presence: true

	## Callbacks
	before_save :set_transaction_type, :set_month_and_year, :update_my_balance, :set_type_id

	## Scopes
	scope :expenses, -> {where('transactions.type_id = ?', 1)}
	scope :incomes, -> {where('transactions.type_id = ?', 2)}
	scope :investments, -> {where('transactions.type_id = ?', 3)}


	def tran_code
		"tra#{Time.zone.now.to_i}"
	end

	def payment_type
		Rails.application.secrets.payment_types[payment_type_id]
	end

	def transaction_type
		Rails.application.secrets.transaction_types[transaction_type_id]
	end

	def type
		Rails.application.secrets.transaction_types[category_type_id]
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

	protected

	## Boolean Methods
	def is_debited?
		self.transaction_type_id == 2
	end

	def is_credited?
		self.transaction_type_id == 1
	end

	## Friendly ID Method ---------------------------------------
	def should_generate_new_friendly_id?
  	description_changed?
	end	

	private

	## Callback Methods -----------------------------------------
	def set_transaction_type
		# Here set static condition category.category_type_id == 3 because 3 for investment
		# but investment is one type of expense so that it's debit so for debit it's 2
		self.transaction_type_id = category.category_type_id == 3 ? 2 : category.category_type_id
	end

	def set_month_and_year
		self.month = self.transaction_date.month
		self.year = self.transaction_date.year
	end

	def update_my_balance
		balance_update(self) if self.amount_changed?
	end

	def set_type_id
		self.type_id = self.category.category_type_id
	end
end
