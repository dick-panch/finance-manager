class ReportService
	extend ActiveModel::Naming
	attr_accessor :user

	def initialize(user)
		@user 			= user
		@year 			= Date.today.year		
	end

	def exec
		get_total_income_for_current_year_month_wise
		get_total_expense_for_current_year_month_wise
	end

	def get_instance_variable
		hash = {}
		hash[:incomes] 	= Hash[@incomes.sort]
		hash[:expenses]	= Hash[@expenses.sort]
		return hash
	end

	private

	def get_total_income_for_current_year_month_wise
		@incomes = @user.transactions.where("year = ? AND transaction_type_id = ?", @year, 2).group_by{|t| t.month}
		(1..12).each do |month|
			@incomes.merge!(month => @incomes[month].present? ? @incomes[month].map{|t| t.amount.to_f}.sum : 0.0)
		end		
	end

	def get_total_expense_for_current_year_month_wise
		@expenses = @user.transactions.where("year = ? AND transaction_type_id = ?", @year, 1).group_by{|t| t.month}
		(1..12).each do |month|
			@expenses.merge!(month => @expenses[month].present? ? @expenses[month].map{|t| t.amount.to_f}.sum : 0.0) 
		end
	end

end