class Game < ApplicationRecord
  has_many :user_games
  has_many :users, through: :user_games
  has_one_attached :cover_image

  normalizes :name, with: lambda(&:strip)
  validates :name, presence: true
  normalizes :developer, with: lambda(&:strip)
  validates :developer, presence: true
  validates :release_date, presence: true
  validate :prevent_dupe, on: %i[create]
  validate :acceptable_cover_image

  scope :unreleased_games, -> { where("release_date > ?", Date.today) }
  scope :recently_added, -> { order(created_at: :desc) }

  def formatted_release
    release_date.strftime("%m/%d/%Y")
  end

  def release_year
    release_date.year
  end

  def display_cover_image
    cover_image.attached? ? cover_image : "no-img.png"
  end

  def avg_score
    game_scores = user_games.where.not(score: nil).pluck(:score)
    return "N/A" if game_scores.empty?

    game_scores.sum.fdiv(game_scores.size).round(1)
  end

  def self.sorted_list
    order(Arel.sql("LOWER(name)"), :release_date)
  end

  def self.find_by_name(name)
    where("LOWER(name) = ?", name.to_s.strip.downcase)
  end

private

  def prevent_dupe
    potential_dupes = Game.find_by_name(name)
    return if potential_dupes.empty?

    potential_dupes.each do |pd|
      if strip_downcase(pd.developer) == strip_downcase(developer) && pd.release_date == release_date
        errors.add(:base, "This game has already been added")
      end
    end
  end

  def acceptable_cover_image
    return unless cover_image.attached?

    errors.add(:cover_image, "file is too large (max 5MB)") unless cover_image.blob.byte_size <= 5.megabytes

    acceptable_types = %w[image/jpeg image/png]
    return if acceptable_types.include?(cover_image.content_type)

    errors.add(:cover_image, "must be a JPEG, or PNG")
  end
end
