##################### A inclure dans karibu resource pour rajouter des fonctionnalites a une classe exposee. #####################

module Karibu
  class Resource
    
    # @@exposed_methods = []
    # @@before_callbacks = []
    # @@after_callbacks = []
    # @@middlewares = []

    def expose(methods)
      raise "Methods to expose are missing" if methods.nil?
      @exposed_methods ||= []
      if methods.class == Array
        methods.each do |method|
          @exposed_methods << method.to_sym
        end
      else
        @exposed_methods << methods.to_sym
      end
    end

    # def before_exec 
      
    # end

    # def after_exec
      
    # end

    def add_middleware name, *args, &block
      @middlewares ||= []
      @middlewares << [name, args, block]
      @middlewares = @middlewares.uniq
    end


    @exposed_methods.each do |method|
      klass = @middlewares.first.name
      klass.new(args, block)
    end


  end
end