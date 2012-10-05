class StaticController < ApplicationController
  def home
    @tasks = Task.where("completed_at > ? or completed_at is null", Date.today.beginning_of_day).order(:position)
  end
end
