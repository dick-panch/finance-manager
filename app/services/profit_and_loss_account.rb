class ProfitAndLossAccount
	extend ActiveModel::Naming
	attr_accessor :user

	def initialize(user, params)
		@user 	= user
		@years 	= @user.transactions.group_by{|t| t.year}.keys
		@params = params
	end

	def exec
		@year 	 = @params[:year] || Date.today.year
		case @params[:period_type]
		when 'monthly'
			@month = @params[:month].to_i || Date.today.month
			execute_monthly_profit_n_loss_report
		when 'quarterly'
			@quarter 	= @params[:quarter] || 1
			execute_quarterly_profit_n_loss_report
		when 'yearly'
			execute_yearly_profit_n_loss_report
		when 'custom'
			execute_custom_profit_n_loss_report
		end
	end

	def get_instance_variable
		hash = {}
		hash[:incomes] 	= @income_transactions
		hash[:expenses]	= @expenses_transactions
		hash[:investments] = @investments_transactions
		hash[:month] 		= Date::MONTHNAMES[@month] if @month.present?
		hash[:year] 		= @year
		hash[:years]		= @years
		return hash
	end

	private

	def execute_monthly_profit_n_loss_report
		transactions 							= @user.transactions.with_month_year(@month, @year)
		@income_transactions 			= transactions.incomes.group_by{|t| t.category.name }
		@expenses_transactions 		= transactions.expenses.group_by{|t| t.category.name }
		@investments_transactions = transactions.investments.group_by{|t| t.category.name }
	end

	def execute_quarterly_profit_n_loss_report
		transactions 							= get_quarterly_transactions
		@income_transactions 			= transactions.incomes.group_by{|t| t.category.name }
		@expenses_transactions 		= transactions.expenses.group_by{|t| t.category.name }		
		@investments_transactions = transactions.investments.group_by{|t| t.category.name }
	end

	def execute_yearly_profit_n_loss_report
		transactions 							= @user.transactions.where('year = ?', @year)
		@income_transactions 			= transactions.incomes.group_by{|t| t.category.name }
		@expenses_transactions 		= transactions.expenses.group_by{|t| t.category.name }
		@investments_transactions = transactions.investments.group_by{|t| t.category.name }
	end

	def execute_custom_profit_n_loss_report
		start_date 		= @params[:daterange].split('-')[0].strip.to_date
		end_date 			= @params[:daterange].split('-')[1].strip.to_date
		transactions 	= @user.transactions.where('transaction_date >= ? and transaction_date <= ?', start_date, end_date)
		@income_transactions 			= transactions.incomes.group_by{|t| t.category.name }
		@expenses_transactions 		= transactions.expenses.group_by{|t| t.category.name }		
		@investments_transactions = transactions.investments.group_by{|t| t.category.name }
	end

	def get_quarterly_transactions
		case @params[:quarter].to_s
		when '1'
			transactions = @user.transactions.where('month >= 1 and month <= 3 and year = ?', @year)
		when '2'
			transactions = @user.transactions.where('month >= 4 and month <= 6 and year = ?', @year)
		when '3'
			transactions = @user.transactions.where('month >= 7 and month <= 9 and year = ?', @year)
		when '4'
			transactions = @user.transactions.where('month >= 10 and month <= 12 and year = ?', @year)
		else
			transactions = @user.transactions.where('month >= 1 and month <= 3 and year = ?', @year)
		end
		return transactions		
	end

end