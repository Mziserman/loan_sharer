class LinearsController < LoansController
  def show
    super do
      @timetable = LoanCreator::Linear.new(**@params)
    end
  end
end
