class Expose

  def self.aminata
    run
  end

  class << self
    def run
      p "aminata is running"
    end
  end

  # def self.run
  #   puts "aminata is running"
  # end

  # private_class_method :run
end


# Expose.send(:private_class_method, :run)
Expose.aminata
# Expose.run