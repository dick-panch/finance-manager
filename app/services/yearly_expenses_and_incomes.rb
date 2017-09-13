class YearlyExpensesAndIncomes
	extend ActiveModel::Naming
	attr_accessor :user,  :year

	def initialize(user, transaction_type_id, year=nil)
		@user = user
		@year = year.present? ? year : Date.today.year
		@transaction_type_id = transaction_type_id
	end

	def exec
		@results = {}
		@transactions = @user.transactions.with_year(@year).with_type(@transaction_type_id)		
		@years 				= @user.transactions.group_by{|t| t.year}.keys
		matrix_transaction(@results)
		return @results
	end

	def get_instance_variable
		hash = {}
		hash[:results] 	= @results
		hash[:totals] 	= sum_of_months
		hash[:years] 		= @years
		return hash
	end

	private

	def matrix_transaction(results)
		@transactions.group_by{|t| t.category}.each do |category, transactions|
			results.merge!(category => {}) unless results[category].present?
			transactions.group_by{|t| t.month}.each do |month, month_transactions|
				results[category].merge!(month => {}) unless results[category][month].present?
				results[category].merge!(month => month_transactions.map{|t| t.amount}.sum.to_f.round(2))				
			end
			results[category].merge!('total' => results[category].values.sum.to_f.round(2))
		end
	end

	def sum_of_months(totals={})
		@transactions.group_by{|t| t.month}.each do |month, transactions|
			totals.merge!(month => transactions.map{|t| t.amount}.sum.to_f.round(2))
		end
		return totals
	end
end