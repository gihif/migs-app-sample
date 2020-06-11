class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  def health
    if Redis.new.get('unhealthy_status').present?
      head 500
    else
      render plain: 'OK', status: :ok
    end
  end
end
