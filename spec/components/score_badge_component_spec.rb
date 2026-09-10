require "rails_helper"

RSpec.describe ScoreBadgeComponent, type: :component do
  it "renders a high-score badge for a score of 8 or above" do
    render_inline(described_class.new(score: 9.0))

    expect(page).to have_css(".score-badge-high", text: "9.0")
  end

  it "renders a mid-score badge for a score between 5 and 8" do
    render_inline(described_class.new(score: 6.5))

    expect(page).to have_css(".score-badge-mid", text: "6.5")
  end

  it "renders a low-score badge for a score below 5" do
    render_inline(described_class.new(score: 2.0))

    expect(page).to have_css(".score-badge-low", text: "2.0")
  end

  it "renders N/A when there is no score" do
    render_inline(described_class.new(score: "N/A"))

    expect(page).to have_css(".score-badge-na", text: "N/A")
  end
end