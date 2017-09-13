class BalanceReport
	extend ActiveModel::Naming
	attr_accessor :user

	def initialize(user, year)
		@user  = user
		@years = @user.transactions.group_by{|t| t.year}.keys
		@year  = year
	end

	def exec
		balance_report
		yearly_total
		my_current_balance
	end

	def get_instance_variable
		hash = {}
		hash[:year] 		= @year
		hash[:years]		= @years
		hash[:results]  = @results
		hash[:total] 		= @total
		hash[:yearly_total] = @yearly_total
		return hash
	end

	private

	def balance_report
		@results = []
		transactions = @user.transactions.where("year = ?", @year).group_by{|t| t.month}
		(1..12).each do |month|
			@results << {
				month: month,
				income: transactions[month].present? ? transactions[month].flatten.collect{|t| t.type_id == 2 ? t.amount : 0.0 }.sum : 0.0,
				expense: transactions[month].present? ? transactions[month].flatten.collect{|t| t.type_id == 1 ? t.amount : 0.0 }.sum : 0.0,
				investment: transactions[month].present? ? transactions[month].flatten.collect{|t| t.type_id == 3 ? t.amount : 0.0}.sum : 0.0
			}
		end
	end

	def yearly_total
		income 			= @results.map{|t| t[:income]}.sum
		expense 		= @results.map{|t| t[:expense]}.sum
		investment 	= @results.map{|t| t[:investment]}.sum
		@yearly_total = income - (expense + investment)
	end

	def my_current_balance
		income 			= @user.transactions.incomes.map{|t| t.amount}.sum
		expense 		= @user.transactions.expenses.map{|t| t.amount}.sum
		investment 	= @user.transactions.investments.map{|t| t.amount}.sum
		@total = income - (expense + investment)
	end
end