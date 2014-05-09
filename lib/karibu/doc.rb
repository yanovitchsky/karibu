module Karibu
  class Doc

    @@docs = ::Hamster.list # list of docs for karibu
    
    attr_accessor :root, :description, :args

    #
    # Serve all documentation for a karibu service
    #
    #
    # @return [String] formatted string of documentation
    # 
    def self.serve_doc
      @@docs.map{|x| x.format}.join('\n')
    end


    #
    # create a new doc and store it in a global doc
    #
    # @param [String] klass_method <route for registering a class and method (class#method)>
    # 
    # @yield block to apply for doc registration
    #
    def initialize(klass_method, &block)
      @root = klass_method
      @args = {}
      instance_eval &block
      @@docs = @@docs.cons(self)
    end


    #
    # description of a method
    #
    #
    # @return [String] description
    # 
    def desc description
      @description = description
    end

    #
    # register and argument and its option 
    # ex: arg 'c', type: Integer, desc: "number of stripes"
    #
    #
    # @return [Hash] hash containing the argument options
    # 
    def arg argument_name, argument_options=nil
      raise "need args type" if argument_options[:type].nil?
      @args[argument_name] = argument_options
    end

    
    
    #
    # describe return type of route
    #
    # @param [String] description string describing the return object
    # @param [Constant] type type of class to return
    #
    # raise 
    # @return [Hash] hash containing return
    # 
    def returns(description, type)
      raise "description should not be nil "if description.nil?
      raise "type should not be nil" if type.nil?
      @return = {desc: description, type: type}
    end

  
    #
    # format the doc for viewing
    # ex : Message.echo(x:String, c:Integer)                    # permits name for someone, x:String(name of string), c:Integer(number of stripes)
    #
    #
    # @return [String] formatted string
    # 
    def format
      msg = ""
      klass, method = @root.split('#')
      msg += "#{klass.capitalize}.#{method}("
      args_holder = [] 
      args.each do |key, value|
        args_holder << "#{key}:#{value[:type]}"
      end
      msg += args_holder.join(', ')
      msg +=")"
      20.times { msg += " "}
      msg += "# "
      msg += "#{@description}, "
      desc_holder = [] 
      args.each do |key, value|
        desc_holder << "#{key}:#{value[:type]}(#{value[:desc]})" if value[:desc]
      end
      msg += desc_holder.join(', ')
      msg += ", "
      msg += "returns #{@return[:desc]} of type #{@return[:type]}"
    end
  end
end
