# @author yanovitchsky
module Karibu
  def self.env
    ENV['KARIBU_ENV'] || "development"
  end
end
