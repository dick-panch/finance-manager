class Balance < ApplicationRecord
	## relationships
	belongs_to :user

	# Scopes
	scope :with_year, -> (year) { where('balances.year = ?', year) }
end
