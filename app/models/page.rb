class Page < ApplicationRecord

  scope :published, -> { where published: true }

  validates :title, :slug, presence: true, uniqueness: true

  before_validation :set_slug

  def set_slug
    return if slug.present?
    self.slug = slug_from_title
  end

  def slug_from_title
    I18n.transliterate(title.downcase).delete('"').gsub(/[^a-z0-9]+/, '-')
  end
end
