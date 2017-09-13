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

		get_total_income_for_current_month
		get_total_income_for_previous_month

		get_total_investment_for_current_month
		get_total_investment_for_previous_month

		get_total_expense_for_current_year
		get_total_expense_for_previous_year

		get_total_income_for_current_year
		get_total_income_for_previous_year

		get_total_investment_for_current_year
		get_total_investment_for_previous_year
	end

	def get_instance_variable
		hash = {}
		hash[:current_month_total_expense] 	= @current_month_total_expense
		hash[:previous_month_total_expense] = @previous_month_total_expense

		hash[:current_month_total_income] 	= @current_month_total_income
		hash[:previous_month_total_income] 	= @previous_month_total_income

		hash[:current_month_total_investment] 	= @current_month_total_investment
		hash[:previous_month_total_investment] 	= @previous_month_total_investment
		
		hash[:current_year_total_income]		= @current_year_total_income
		hash[:previous_year_total_income] 	= @previous_year_total_income
		
		hash[:current_year_total_expense] 	= @current_year_total_expense
		hash[:previous_year_total_expense] 	= @previous_year_total_expense

		hash[:current_year_total_investment] 		= @current_year_total_investment
		hash[:previous_year_total_investment] 	= @previous_year_total_investment

		hash[:current_year_income_month_wise] 	= current_year_income_month_wise
		hash[:current_year_expense_month_wise] 	= current_year_expense_month_wise
		hash[:current_year_investment_month_wise] = current_year_investment_month_wise

		hash[:top_6_expenses]										= top_6_expenses

		hash[:total_no_of_income_record] 				= total_no_of_income_record
		hash[:total_no_of_expense_record] 			= total_no_of_expense_record

		## Category Expenses
		hash[:category_expenses_for_current_month] 		= get_category_expenses_for_current_month
		hash[:category_incomes_for_current_month] 		= get_category_incomes_for_current_month
		hash[:category_investment_for_current_month]	= get_category_investments_for_current_month

		return hash
	end

	private

	## Total Expense for current month and previous month
	def get_total_expense_for_current_month
		transactions = @user.transactions.where("month = ? AND year = ? AND type_id = ?", @month, @year, 1)
		@current_month_total_expense = transactions.present? ? transactions.map(&:amount).sum.to_f.round(2) : 0.0
	end

	def get_total_expense_for_previous_month
		transactions = @user.transactions.where("month = ? AND year = ? AND type_id = ?", @previous_month, @previous_year, 1)
		@previous_month_total_expense = transactions.present? ? transactions.map(&:amount).sum.to_f.round(2) : 0.0
	end

	## Total Income for current and previous month
	def get_total_income_for_current_month
		transactions = @user.transactions.where("month = ? AND year = ? AND type_id = ?", @month, @year, 2)
		@current_month_total_income = transactions.present? ? transactions.map(&:amount).sum.to_f.round(2) : 0.0		
	end

	def get_total_income_for_previous_month
		transactions = @user.transactions.where("month = ? AND year = ? AND type_id = ?", @previous_month, @previous_year, 2)
		@previous_month_total_income = transactions.present? ? transactions.map(&:amount).sum.to_f.round(2) : 0.0
	end

	## Total Investment for current and previous month
	def get_total_investment_for_current_month
		transactions = @user.transactions.where("month = ? AND year = ? AND type_id = ?", @month, @year, 3)
		@current_month_total_investment = transactions.present? ? transactions.map(&:amount).sum.to_f.round(2) : 0.0		
	end

	def get_total_investment_for_previous_month
		transactions = @user.transactions.where("month = ? AND year = ? AND type_id = ?", @previous_month, @previous_year, 3)
		@previous_month_total_investment = transactions.present? ? transactions.map(&:amount).sum.to_f.round(2) : 0.0
	end	

	## Total Income for current year and previous year
	def get_total_income_for_current_year
		transactions = @user.transactions.where("year = ? AND type_id = ?", @year, 2)		
		@current_year_total_income = transactions.present? ? transactions.map(&:amount).sum.to_f.round(2) : 0.0
	end

	def get_total_income_for_previous_year
		transactions = @user.transactions.where("year = ? AND type_id = ?", @previous_year, 2)
		@previous_year_total_income = transactions.present? ? transactions.map(&:amount).sum.to_f.round(2) : 0.0
	end

	## Total Expense for current and previous year
	def get_total_expense_for_current_year
		transactions = @user.transactions.where("year = ? AND type_id = ?", @year, 1)
		@current_year_total_expense = transactions.present? ? transactions.map(&:amount).sum.to_f.round(2) : 0.0
	end

	def get_total_expense_for_previous_year
		transactions = @user.transactions.where("year = ? AND type_id = ?", @previous_year, 1)
		@previous_year_total_expense = transactions.present? ? transactions.map(&:amount).sum.to_f.round(2) : 0.0
	end

	def get_total_investment_for_current_year
		transactions = @user.transactions.where("year = ? AND type_id = ?", @year, 3)
		@current_year_total_investment = transactions.present? ? transactions.map(&:amount).sum.to_f.round(2) : 0.0
	end
	
	def get_total_investment_for_previous_year
		transactions = @user.transactions.where("year = ? AND type_id = ?", @previous_year, 3)
		@previous_year_total_investment = transactions.present? ? transactions.map(&:amount).sum.to_f.round(2) : 0.0
	end

	## Current Year income/expense month wise
	def current_year_income_month_wise
		transactions = @user.transactions.where("year = ? AND type_id = ?", @year, 2)
		return group_by_month_and_sum_of_amount(transactions)		
	end

	def current_year_expense_month_wise
		transactions = @user.transactions.where("year = ? AND type_id = ?", @year, 1)
		return group_by_month_and_sum_of_amount(transactions)		
	end

	def current_year_investment_month_wise
		transactions = @user.transactions.where("year = ? AND type_id = ?", @year, 3)
		return group_by_month_and_sum_of_amount(transactions)		
	end

	def group_by_month_and_sum_of_amount(transactions)
		data = {}
		transactions.group_by{|t| t.month}.each do |month, values|
			data.merge!(month => values.map{|t| t.amount.to_f}.sum.round(2))
		end
		return set_zero_for_empty_month(data)
	end

	def set_zero_for_empty_month(data)
		(1..12).to_a.map{|t| data.merge!(t => 0) unless data[t].present? }
		return Hash[data.sort]
	end

	def top_6_expenses
		transactions = @user.transactions.where("year = ? AND month = ? AND type_id = ?", @year, @month, 1).order('amount DESC').limit(6)
	end

	def total_no_of_income_record
		@user.transactions.where("year = ? AND month = ? AND type_id = ?", @year, @month, 2).count
	end

	def total_no_of_expense_record
		@user.transactions.where("year = ? AND month = ? AND type_id = ?", @year, @month, 1).count
	end

	## Categories Expenses for current month
	def get_category_expenses_for_current_month
		transactions = @user.transactions.where("year = ? and month = ?", @year, @month)
		total_expense_current_month = transactions.expenses.map{|t| t.amount}.sum.to_f.round(2)
		category_expenses = []
		transactions.expenses.group_by{|t| t.category.name}.each do |category, expenses|
			category_expenses << {	'category' => category,
				'percent' => (expenses.flatten.map{|t| t.amount}.sum * 100 / total_expense_current_month).to_f.round(2),
				'amount' => expenses.flatten.map{|t| t.amount}.sum
			}
		end
		return category_expenses
	end

	def get_category_incomes_for_current_month
		transactions = @user.transactions.where("year = ? and month = ?", @year, @month)
		total_income_current_month = transactions.incomes.map{|t| t.amount}.sum.to_f.round(2)
		category_expenses = []
		transactions.incomes.group_by{|t| t.category.name}.each do |category, incomes|
			category_expenses << {	'category' => category,
				'percent' => (incomes.flatten.map{|t| t.amount}.sum * 100 / total_income_current_month).to_f.round(2),
				'amount' => incomes.flatten.map{|t| t.amount}.sum
			}
		end
		return category_expenses
	end

	def get_category_investments_for_current_month
		transactions = @user.transactions.where("year = ? and month = ?", @year, @month)
		total_investment_current_month = transactions.investments.map{|t| t.amount}.sum.to_f.round(2)
		category_investment = []
		transactions.investments.group_by{|t| t.category.name}.each do |category, investments|
			category_investment << {	'category' => category,
				'percent' => (investments.flatten.map{|t| t.amount}.sum * 100 / total_investment_current_month).to_f.round(2),
				'amount' => investments.flatten.map{|t| t.amount}.sum
			}
		end
		return category_investment
	end
end