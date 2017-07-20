# @author yanovitchsky
module Karibu
  def self.root
    Pathname.new(File.expand_path('../../../', __FILE__))
  end
end
