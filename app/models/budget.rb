class Budget < ApplicationRecord
	## Relationships
	belongs_to :user
	belongs_to :category

	def category_name
		category.try(:name)
	end

	def is_budget_set?
		amount > 0 || percent_of_income > 0
	end

	def category_total_amount
		category.transactions.where('month = ? and year = ?', month, year).select('amount').map{|t| t.amount}.sum.round(1)
	end
end