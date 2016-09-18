module RLine
  class Middleware
    def initialize(*middleware)
      @middleware = middleware.flatten
    end

    def call(token)
      @middleware.reduce(token) do |result, middleware|
        middleware.call(result)
      end
    end
  end
end
