class StaticController < ApplicationController
    def home
        @tasks = Task.all
        render "home"
    end
end
