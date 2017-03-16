class PromiseLike
  def initialize(arg)
    @arg = arg
    @error = nil
  end

  def then
    begin
      if error.nil?
        yield @args
      else
        return error
      end
    rescue => e
      @error = error
    end
  end
end
