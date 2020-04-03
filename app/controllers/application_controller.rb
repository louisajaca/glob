class ApplicationController < ActionController::Base

  before_action :init_blog

  private

  def init_blog
    @blog = Blog.new
  end
end
