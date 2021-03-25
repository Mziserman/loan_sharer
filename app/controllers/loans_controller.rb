class LoansController < ApplicationController
  def show
    begin
      @params = fix_params_type(permitted_params)
      yield
      @terms = @timetable.lender_timetable.terms
    rescue ArgumentError => e
      @params = {initial_values:{}}
      @terms = []
    end
  end

  def hash
    Base64.urlsafe_encode64(permitted_params.to_json)
  end

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

  def fix_params_type(params)
    {}.tap do |h|
      h[:period] = params[:period].to_sym unless params[:period].nil?
      h[:amount] = params[:amount].to_f unless params[:amount].nil?
      h[:annual_interests_rate] = params[:annual_interests_rate].to_f unless params[:annual_interests_rate].nil?
      h[:starts_on] = Date.parse(params[:starts_on]) unless params[:starts_on].nil?
      h[:duration_in_periods] = params[:duration_in_periods].to_i unless params[:duration_in_periods].nil?
      if params[:initial_values].present?
        h[:initial_values] = {}.tap do |ivh|
          ivh[:paid_capital] = params[:initial_values][:paid_capital].to_f unless params[:initial_values][:paid_capital].nil?
          ivh[:paid_interests] = params[:initial_values][:paid_interests].to_f unless params[:initial_values][:paid_interests].nil?
          ivh[:accrued_delta_interests] = params[:initial_values][:accrued_delta_interests].to_f unless params[:initial_values][:accrued_delta_interests].nil?
          ivh[:due_interests] = params[:initial_values][:due_interests].to_f unless params[:initial_values][:due_interests].nil?
          ivh[:starting_index] = params[:initial_values][:starting_index].to_i unless params[:initial_values][:starting_index].nil?
        end
      end
    end
  end

  def encrypt_params
    URI.encode({
      p: params[:period],
      a: params[:amount],
      r: params[:annual_interests_rate],
      d: params[:duration_in_periods],
      pc: params.dig(:initial_values, :paid_capital),
      pi: params.dig(:initial_values, :paid_interests),
      ac: params.dig(:initial_values, :accrued_delta_interests),
      di: params.dig(:initial_values, :due_interests),
      si: params.dig(:initial_values, :starting_index),
    }.to_json)
  end

  def decrypt_params
    JSON.parse(
      Base64.decode64(params.permit(:hash))
    )
  end
end

# exemple : http://localhost:3000/loans/bullet?period=month&amount=1000&annual_interests_rate=10&starts_on=2021-03-25T16:00:43+01:00&duration_in_periods=12&initial_values[due_interests]=100&initial_values[accrued_delta_interests=0]=100&&initial_values[paid_interests]=100&initial_values[paid_capital]=100
