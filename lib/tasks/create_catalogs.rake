desc 'generate catalogs from seminars'
task generate_catalogs: :environment do
  puts
  catalogs = Seminar.pluck('distinct year').map do |year|
    { title: "Bildungskalender #{year}", year: year }
  end
  Catalog.create! catalogs
  puts "#{Catalog.count} catalogs created"
end
