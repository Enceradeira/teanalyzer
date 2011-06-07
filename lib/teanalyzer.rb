require File.expand_path('./../core/triad', __FILE__)

class Teanalyzer
  private
  public
  # returns the total effort required to type a text
  def self.calculate_total(text)
    triads = Triad.from_text(text)
    efforts = triads.map { |t| t.effort }
    return efforts.reduce(:+)
  end

  # returns the normalized effort required to type a text
  def self.calculate text
    triads = Triad.from_text(text)
    efforts = triads.map { |t| t.effort }
    efforts.reduce(:+) / triads.length unless triads.length == 0
  end
end