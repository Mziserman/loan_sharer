class BulletsController < LoansController
  def show
    super do
      @timetable = LoanCreator::Bullet.new(**@params)
    end
  end
end
