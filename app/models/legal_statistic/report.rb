# frozen_string_literal: true

class LegalStatistic < ApplicationRecord
  class Report
    def initialize(year)
      @year = year
      # @catalog = Catalog.find_by(year: year)
    end

    # def seminars
    #   @catalog.seminars.where(canceled: false).order(:number).includes(:legal_statistic)
    # end

    def stats
      # @catalog.seminars.where(canceled: false).order(:number).includes(:legal_statistic)
      LegalStatistic.joins(:seminar).where(seminars: { canceled: false, year: @year }).order('seminars.number')
    end

    def attr_name(attr)
      LegalStatistic.human_attribute_name attr
    end

    def headers
      {
        :title                           => [],
        :number                          => [],
        'Veranstaltungszeitraum'         => %i[start_date start_time end_date end_time],
        'Veranstaltungsdauer'            => %i[hours days],
        'Veranstaltungsart/ Anerkennung' => %i[event_type law_accepted_str],
        'Veranstaltungsort'              => %i[zip location],
        'Kooperation'                    => LegalStatistic::PARTNER_FIELDS,
        'Thema'                          => [:topic],
        'EBG'                            => [:ebg],
        'Zielgruppe'                     => [:target_group],
        'Teilnehmende'                   => LegalStatistic::RANGE_FIELDS.map(&:to_sym) #+ [:sum_attendees]
      }
    end

    def fields
      headers.flat_map { |title, subtitles| subtitles.empty? ? title : subtitles }
    end

    def header_names
      res = {}
      headers.each do |title, subtitles|
        title = attr_name(title) if title.is_a?(Symbol)
        res[title] = subtitles.map do |subtitle|
          subtitle.is_a?(Symbol) ? attr_name(subtitle) : subtitle
        end
      end
      res
    end

    def headers_as_excel
      first_row = []
      second_row = []
      header_names.each do |title, sub_titles|
        first_row << title
        second_row << nil if sub_titles.size.zero?
        (sub_titles.size - 1).times { first_row << nil } if sub_titles.size > 1
        sub_titles.each { |subtitle| second_row << subtitle }
      end
      [first_row, second_row]
    end
  end
end
