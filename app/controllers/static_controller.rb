class StaticController < ApplicationController
    def home
        @tasks = Task.where("completed_at > #{Date.yesterday.to_formatted_s(:db)} or completed_at is null").order("position")
        render "home"
    end
end
