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
			@month = @params[:month] || Date.today.month
			execute_monthly_profit_n_loss_report
		when 'quarterly'
			@quarter 	= @params[:quarter] || 1			
		when 'yearly'
		when 'custom'
			@start_date = @params[:start_date]
			@end_date 	= @params[:end_date]
		end
	end

	def get_instance_variable_for_monthly
		hash = {}
		hash[:incomes] 	= @income_transactions
		hash[:expenses]	= @expenses_transactions
		hash[:month] 		= Date::MONTHNAMES[@month]
		hash[:year] 		= @year
		return hash
	end

	def get_instance_variable_for_quarterly
		hash = {}
		return hash
	end

	def get_instance_variable_for_yearly
		hash = {}
		return hash
	end

	def get_instance_variable_for_custom
		hash = {}
		return hash
	end

	private

	def execute_monthly_profit_n_loss_report
		transactions = @user.transactions.where('month = ? and year = ?', @month, @year)
		@income_transactions = transactions.incomes.select('id, description, amount')
		@expenses_transactions = transactions.expenses.group_by{|t| t.category.name }
	end

end