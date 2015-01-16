module Karibu
  module Controller
    module ClassMethods
      attr_accessor :__filters__
      def before_filter(filter_method, *methods_to_filter)
        self.__filters__[filter_method] ||= []
        self.__filters__[filter_method] += methods_to_filter  
      end

      # dsl to define method hooks to call before or after a method
      # execute_method [:test, :toto], before: :find_name, after: :find_number
      def invoke(filters, options={})
        filtered_options_keys = options.keys.reject{|key| key == :before || key == :after } 
        raise "invalid option(s) #{filtered_options_keys.join(',')}" unless filtered_options_keys.size == 0
        
        # move everything to array
        filters = [filters] unless filters.class == Array
        options[:before] = (options[:before].nil?) ? [] : (options[:before].class == Array) ? options[:before] : [options[:before]]
        options[:after] = (options[:after].nil?) ? [] : (options[:after].class == Array) ? options[:after] : [options[:after]]
      
        # checks if methods exist
        methods_involved = filters + options[:before] + options[:after]
        methods_involved.each do |method|
          raise NoMethodError.new("undefined method #{method} for class #{self}") unless self.methods(false).include?(method)
        end

        options[:before].each do |m|
          self.__filters__[m] ||= {}
          self.__filters__[m][:before] ||= []
          self.__filters__[m][:before] = (self.__filters__[m][:before] + filters).uniq
        end

        options[:after].each do |m|
          self.__filters__[m] ||= {}
          self.__filters__[m][:after] ||= []
          self.__filters__[m][:after] = (self.__filters__[m][:after] + filters).uniq
        end

        (options[:before] + options[:after]).uniq.each do |m|
          unless self.methods(false).include?("old_#{m}")
            self.define_singleton_method("new_#{m}") do |*args|
              __filters__[m][:before].each {|f| self.send(f, *args)} unless __filters__[m][:before].nil?
              self.send("old_#{m}", *args)
              __filters__[m][:after].each {|f| self.send(f, *args)} unless __filters__[m][:after].nil?
            end
            self.instance_eval "alias old_#{m} #{m}"
            self.instance_eval "alias #{m} new_#{m}"
          end
        end

      end
    end
    
    module InstanceMethods
      
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
      receiver.__filters__ = {}
    end
  end
end