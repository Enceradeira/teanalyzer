require File.expand_path('./../triad', __FILE__)

class Teanalyzer
  def self.calculate word
    triads = Triad.from_word(word)
    efforts = triads.map {|t| t.effort}
    efforts.reduce(:+) / triads.length unless triads.length == 0
  end
end