class CardAddingsController < ApplicationController

  def create
    form = AddCardForm.new(params[:add_card_form])
    if form.valid?
      form.prefer(service)
      redirect_to board_url(form.project_id_str), notice: 'Card added'
    else
      redirect_to backlog_url(form.project_id_str), alert: 'Something wrong!!!'
    end
  end

  private

    def service
      BoardService.new(
        ProjectRepository.new,
        BoardRepository.new
      )
    end
end
