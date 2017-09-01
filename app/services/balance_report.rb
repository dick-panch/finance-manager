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
	end

	def get_instance_variable
		hash = {}
		hash[:year] 		= @year
		hash[:years]		= @years
		hash[:results]  = @results
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
end