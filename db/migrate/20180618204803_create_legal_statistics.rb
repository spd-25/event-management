class CreateLegalStatistics < ActiveRecord::Migration[5.1]

  AGE_RANGES_DEPR = %w[50_65 gt_65].freeze
  AGE_RANGES = %w[unknown lt_16 16_17 18_24 25_34 35_49 50_64 65_75 gt_75].freeze

  def change
    create_table :legal_statistics do |t|
      t.references :seminar, foreign_key: true

      # t.string :number # deprecated
      # t.string :title # deprecated
      t.string  :section
      t.integer :topic
      t.integer :event_type
      t.boolean :law_accepted, default: true
      # t.string  :type # deprecated
      t.string  :published # deprecated
      t.string  :zip
      t.string  :location
      t.string  :start_date
      t.string  :start_time
      t.string  :end_date
      t.string  :end_time
      t.integer :hours
      t.string  :partner
      t.integer :ebg, default: 1
      t.string  :certificate # deprecated
      t.integer :target_group, default: 9
      t.integer :not_local, default: 0 # deprecated

      (AGE_RANGES + AGE_RANGES_DEPR).each do |range|
        t.integer "age_#{range}_f", default: 0
        t.integer "age_#{range}_m", default: 0
      end

      t.timestamps
    end
  end

end
