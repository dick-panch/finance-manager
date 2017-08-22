class BalanceSheet
	extend ActiveModel::Naming
	attr_accessor :user

	def initialize(user, year)
		@user 	= user
		@years 				= @user.transactions.group_by{|t| t.year}.keys
		@start_date 	= "1/4/#{year.to_i-1}".to_date
		@end_date 		= "31/3/#{year}".to_date
	end

	def exec	
		transactions = @user.transactions.where("transaction_date >= ? and transaction_date <= ?", @start_date, @end_date)
		@income_transactions = transactions.incomes.group_by{|t| t.category.name }
		@expenses_transactions = transactions.expenses.group_by{|t| t.category.name }
	end

	def get_instance_variable
		hash = {}
		hash[:incomes] 	= @income_transactions
		hash[:expenses]	= @expenses_transactions		
		hash[:years]		= @years
		return hash		
	end
end