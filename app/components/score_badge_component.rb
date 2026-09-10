# frozen_string_literal: true

class ScoreBadgeComponent < ViewComponent::Base
  def initialize(score:)
    @score = score
  end

  def color_class
    return "score-badge-na" unless numeric_score

    case numeric_score
    when 8..10 then "score-badge-high"
    when 5..8 then "score-badge-mid"
    else "score-badge-low"
    end
  end

  def display_score
    numeric_score || "N/A"
  end

private

  def numeric_score
    @score == "N/A" || @score.nil? ? nil : @score.to_f
  end
end
