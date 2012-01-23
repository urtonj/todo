class StaticController < ApplicationController
    def home
    	#{Date.yesterday.to_formatted_s(:db)}
        @tasks = Task.where("to_timestamp(completed_at) > #{Date.yesterday} or completed_at is null").order("position")
        render "home"
    end
end
