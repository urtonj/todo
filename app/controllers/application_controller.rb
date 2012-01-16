class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :mobile_device?

  private

  def mobile_device?
  	request.format = :mobile if request.user_agent =~ /iPhone/
  end

  helper_method :mobile_device?

  # def prepare_for_mobile
  # 	puts params
  # 	session[:mobile_param] = params[:mobile] if params[:mobile]
  # 	if mobile_device?
  # 		puts "mobile!"
  # 	end
  # 	request.format = :mobile if mobile_device?
  # end

end
