class YearlyExpenses
	extend ActiveModel::Naming
	attr_accessor :user,  :year

	def initialize(user)
		@user = user
		@year = Date.today.year
	end

	def exec
		@results = {}
		@transactions = @user.transactions.where("year = ? and transaction_type_id = ?", @year, 1)
		matrix_transaction(@results)
		return @results
	end

	def get_instance_variable
		hash = {}
		hash[:results] 	= @results
		hash[:totals] 	= sum_of_months
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