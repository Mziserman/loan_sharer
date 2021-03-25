class StandardsController < LoansController
  def show
    super do
      @timetable = LoanCreator::Standard.new(**@params)
    end
  end
end
