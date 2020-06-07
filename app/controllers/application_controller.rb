class ApplicationController < ActionController::Base
  def health
    render plain: 'OK', status: :ok
  end
end
