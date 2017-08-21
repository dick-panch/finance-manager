require 'csv'
module ImportTransaction
	def import_general_transactions(file=nil, user)		
		if file.present? && file.content_type.to_s == 'text/csv'			
			begin
				CSV.foreach(file.path, headers: true).each do |row|				
	  			transaction = user.transactions.create({
	  				description: row['description'],
	  				transaction_date: row['date'].to_s.to_date,
	  				amount: row['amount'].to_f.round(2),
						is_paid: row['is_income'].to_s == '0' ? true : false,
						is_received: row['is_income'].to_s == '1' ? true : false,
						category_id: get_category(row['category'], user, row['is_income']),
						payment_type_id: get_payment_type(row['payment_type'])
	  			})
				end
				result = {notice: 'Successfully imported your transactions'}
			rescue StandardError => e
				result = {error: 'Sorry, we encoutered a problem.'}
			end
		elsif file.present? ## When ContentType IS NOT CSV
			result = {error: "Invalid File Type. Upload only CSV"}
		else
			result = {error: "File can't be blank"}
		end
		return result
	end

	private

	def get_category(name=nil, user, type)
		return 13 unless name.present? ## 13 for Other Category / Owner of that category is admin.		
		category = Category.where('lower(name) = ? and (user_id IS NULL or user_id = ?)', name.downcase, user.id).last
		if category.present?
			return category.id
		else
			category_type_id = type.to_s == '0' ? 1 : 2 ## 1 for Expense and 2 for Income
			category = user.categories.create(name: name, category_type_id: category_type_id)
			return category.id
		end
	end

	def get_payment_type(name)
		payment_type_id = Rails.application.secrets.payment_types.invert[name]
		unless payment_type_id.present?
			payment_type_id = Rails.application.secrets.payment_types.invert['Other']
		end
	end
end