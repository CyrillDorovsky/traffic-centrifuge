class RequestIdMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    env['request_id'] = env['HTTP_X_REQUEST_ID'] || SecureRandom.uuid
    env['request_started_at'] = Time.now

    @app.call(env)
  end
end
