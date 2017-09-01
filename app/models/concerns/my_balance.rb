module MyBalance
	def balance_update(transaction)
		user 	= transaction.user
		balance = user.balances.find_by(month: transaction.month, year: transaction.year)
		total_incomes = user.transactions.where("month = ? and year = ?", transaction.month, transaction.year).incomes.map{|t| t.amount}.sum.to_f.round(2)
		total_expenses = user.transactions.where("month = ? and year = ?", transaction.month, transaction.year).expenses.map{|t| t.amount}.sum.to_f.round(2)
		total_investments = user.transactions.where("month = ? and year = ?", transaction.month, transaction.year).investments.map{|t| t.amount}.sum.to_f.round(2)

		if balance.present?
			balance.update({
				amount: (total_incomes - (total_expenses + total_investments))
			})
		else
			user.balances.create({
				month: transaction.month,
				year: transaction.year,
				amount: (total_incomes - (total_expenses + total_investments))
			})
		end
	end
end