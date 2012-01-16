class StaticController < ApplicationController
    def home
        @tasks = Task.all(:order => "position")#, :conditions => ["completed_at >  => Date.yesterday})#{
        render "home"
    end
end
