class MoveSeminarStatistics < ActiveRecord::Migration[5.1]

  def up
    attrs = LegalStatistic.column_names - %w[id seminar_id created_at updated_at]
    LegalStatistic.transaction do
      Seminar.find_each do |seminar|
        stats = attrs.map { |attr| [attr, seminar.statistic.send(attr)] }.to_h
        seminar.create_legal_statistic! stats
      end
    end
  end

  def down
    # LegalStatistic.delete_all
  end

end
