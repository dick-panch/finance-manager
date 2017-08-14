class DashboardReport
	extend ActiveModel::Naming
	attr_accessor :user, :month, :year, :previous_month, :previous_year

	def initialize(user)
		@user 	= user
		@month  = Date.today.month
		@year 	= Date.today.year		
		@previous_month = (Date.today - 1.month).to_date.month
		@previous_year = (Date.today - 1.month).to_date.year
	end

	def exec
		get_total_expense_for_current_month
		get_total_expense_for_previous_month
		get_total_expense_for_current_year
		get_total_expense_for_previous_year						

		get_total_income_for_current_month
		get_total_income_for_previous_month
		get_total_income_for_current_year
		get_total_income_for_previous_year
	end

	def get_instance_variable
		hash = {}
		hash[:current_month_total_expense] 	= @current_month_total_expense
		hash[:previous_month_total_expense] = @previous_month_total_expense
		hash[:current_month_total_income] 	= @current_month_total_income
		hash[:previous_month_total_income] 	= @previous_month_total_income
		hash[:current_year_total_income]		= @current_year_total_income
		hash[:previous_year_total_income] 	= @previous_year_total_income
		hash[:current_year_total_expense] 	= @current_year_total_expense
		hash[:previous_year_total_expense] 	= @previous_year_total_expense
		return hash
	end

	private

	def get_total_expense_for_current_month
		transactions = @user.transactions.where("month = ? AND year = ? AND transaction_type_id = ?", @month, @year, 1)
		@current_month_total_expense = transactions.present? ? transactions.map(&:amount).sum.to_f.round(2) : 0.0
	end

	def get_total_expense_for_previous_month
		transactions = @user.transactions.where("month = ? AND year = ? AND transaction_type_id = ?", @previous_month, @previous_year, 1)
		@previous_month_total_expense = transactions.present? ? transactions.map(&:amount).sum.to_f.round(2) : 0.0
	end

	def get_total_income_for_current_month
		transactions = @user.transactions.where("month = ? AND year = ? AND transaction_type_id = ?", @month, @year, 2)
		@current_month_total_income = transactions.present? ? transactions.map(&:amount).sum.to_f.round(2) : 0.0		
	end

	def get_total_income_for_previous_month
		transactions = @user.transactions.where("month = ? AND year = ? AND transaction_type_id = ?", @previous_month, @previous_year, 2)
		@previous_month_total_income = transactions.present? ? transactions.map(&:amount).sum.to_f.round(2) : 0.0
	end

	def get_total_income_for_current_year
		transactions = @user.transactions.where("year = ? AND transaction_type_id = ?", @year, 2)		
		@current_year_total_income = transactions.present? ? transactions.map(&:amount).sum.to_f.round(2) : 0.0
	end

	def get_total_income_for_previous_year
		transactions = @user.transactions.where("year = ? AND transaction_type_id = ?", @previous_year, 2)
		@previous_year_total_income = transactions.present? ? transactions.map(&:amount).sum.to_f.round(2) : 0.0
	end

	def get_total_expense_for_current_year
		transactions = @user.transactions.where("year = ? AND transaction_type_id = ?", @year, 1)
		@current_year_total_expense = transactions.present? ? transactions.map(&:amount).sum.to_f.round(2) : 0.0
	end

	def get_total_expense_for_previous_year
		transactions = @user.transactions.where("year = ? AND transaction_type_id = ?", @previous_year, 1)
		@previous_year_total_expense = transactions.present? ? transactions.map(&:amount).sum.to_f.round(2) : 0.0
	end
end