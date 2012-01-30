class StaticController < ApplicationController
    def home
    	time = Date.yesterday.end_of_day
        @tasks = Task.where("completed_at > :time or completed_at is null", :time => time).order("position")
        render "home"
    end
end
