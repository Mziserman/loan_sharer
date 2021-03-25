class InFinesController < LoansController
  def show
    super do
      @timetable = LoanCreator::InFine.new(**@params)
    end
  end
end
