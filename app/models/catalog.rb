class Catalog < ApplicationRecord
  validates :title, presence: true
  validates :year, presence: true, uniqueness: true

  has_many :seminars, foreign_key: :year, primary_key: :year, inverse_of: :catalog

  default_scope -> { order :year }

  def self.link_seminars
    pluck('distinct year').each do |year|
      create! title: "Bildungskalender #{year}", year: year
    end
  end
end
