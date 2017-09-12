class BudgetService
  extend ActiveModel::Naming
  attr_accessor :user, :month, :year

  def initialize(user, params)
    @user   = user
    @years  = @user.transactions.group_by{|t| t.year}.keys
    @month  = params[:month].present? ? params[:month] : Date.today.month
    @year   = params[:year].present? ? params[:year] : Date.today.year
  end

  def exec
    my_budgets   
  end

  def get_instance_variable
    hash = {}
    hash[:years] = @years
    hash[:month] = @month
    hash[:year]  = @year
    hash[:budgets] = @budgets
    return hash   
  end

  private

  def my_budgets
    @budgets = @user.budgets.includes(:category).where('month = ? and year = ?', @month, @year).order('categories.name ASC')
  end
end