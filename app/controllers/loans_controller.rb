class LoansController < ApplicationController
  def standard
    @timetable = LoanCreator::Standard.new(**fix_params_type)
    render :show
  end

  def in_fine
    @timetable = LoanCreator::InFine.new(**fix_params_type)
    render :show
  end

  def linear
    @timetable = LoanCreator::Linear.new(**fix_params_type)
    render :show
  end

  def bullet
    @timetable = LoanCreator::Bullet.new(**fix_params_type)
    render :show
  end

  private

  def permitted_params
    params.permit(
      :period,
      :amount,
      :annual_interests_rate,
      :starts_on,
      :duration_in_periods,
      initial_values: [
        :paid_capital,
        :paid_interests,
        :accrued_delta_interests,
        :due_interests,
        :starting_index
      ]
    )
  end

  def fix_params_type
    {}.tap do |h|
      h[:period] = permitted_params[:period].to_sym unless permitted_params[:period].nil?
      h[:amount] = permitted_params[:amount].to_f unless permitted_params[:amount].nil?
      h[:annual_interests_rate] = permitted_params[:annual_interests_rate].to_f unless permitted_params[:annual_interests_rate].nil?
      h[:starts_on] = DateTime.parse(permitted_params[:starts_on]) unless permitted_params[:starts_on].nil?
      h[:duration_in_periods] = permitted_params[:duration_in_periods].to_i unless permitted_params[:duration_in_periods].nil?
      if permitted_params[:initial_values].present?
        h[:initial_values] = {}.tap do |ivh|
          ivh[:paid_capital] = permitted_params[:initial_values][:paid_capital].to_f unless permitted_params[:initial_values][:paid_capital].nil?
          ivh[:paid_interests] = permitted_params[:initial_values][:paid_interests].to_f unless permitted_params[:initial_values][:paid_interests].nil?
          ivh[:accrued_delta_interests] = permitted_params[:initial_values][:accrued_delta_interests].to_f unless permitted_params[:initial_values][:accrued_delta_interests].nil?
          ivh[:due_interests] = permitted_params[:initial_values][:due_interests].to_f unless permitted_params[:initial_values][:due_interests].nil?
          ivh[:starting_index] = permitted_params[:initial_values][:starting_index].to_i unless permitted_params[:initial_values][:starting_index].nil?
        end
      end
    end
  end
end

# exemple : http://localhost:3000/loans/bullet?period=month&amount=1000&annual_interests_rate=10&starts_on=2021-03-25T16:00:43+01:00&duration_in_periods=12&initial_values[due_interests]=100&initial_values[accrued_delta_interests=0]=100&&initial_values[paid_interests]=100&initial_values[paid_capital]=100
