class Setting < ApplicationRecord
	## Relationship
	has_one :user, dependent: :destroy
end
