class ApplicationController < ActionController::Base
  def health
    if Redis.new.get('unhealthy_status').present?
      head 500
    else
      render plain: 'OK', status: :ok
    end
  end
end
