# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# user = CreateAdminService.new.call
# puts 'CREATED ADMIN USER: ' << user.email

# Category.delete_all
# ActiveRecord::Base.connection.reset_pk_sequence!(Category)
#
# categories = {
#   195 => {
#     name: 'Management & Verwaltung',
#     subs: {
#       196 => 'Verwaltung und Sekretariat',
#       197 => 'Personalführung und Leitungstätigkeit',
#       198 => 'Recht & Betriebswirtschaftliches/Finanzen',
#       199 => 'PC Kurse',
#       200 => 'Zertifikatskurse',
#     }
#   },
#   201 => {
#     name: 'Persönliche Kompetenzen – Potenziale, Methoden, Kommunikation, Gesundheitsförderung',
#     subs: {
#       202 => 'Allgemeines',
#       203 => 'Zertifikatskurse',
#     }
#   },
#   204 => {
#     name: 'Umgang mit Kindern & Jugendlichen',
#     subs: {
#       205 => 'Allgemeines und Grundlagen',
#       206 => 'Auffälligkeiten, Störungsbilder, Erkrankungen',
#       207 => 'Zertifikatskurse',
#     }
#   },
#   208 => {
#     name: 'Umgang mit Menschen im Alter und/oder mit Behinderung',
#     subs: {
#       209 => 'Recht',
#       210 => 'Expertenstandards',
#       211 => 'Das große Q wie Qualität',
#       212 => 'Dokumentation',
#       213 => 'Erkrankungen/Krankheitsbilder',
#       214 => 'Demenz',
#       215 => 'Pflege, Begleitung, Betreuung, Beschäftigung',
#       216 => 'Sterben und Tod',
#       217 => 'Zusätzliche Betreuungs- und Aktivierungskräfte',
#       218 => 'Zertifikatskurse',
#     }
#   },
#   219 => 'Schuldnerberatung',
#   220 => {
#     name: 'Weiterbildung für Betreuer/innen',
#     subs: {
#       221 => 'Grundlagen der Betreuungsarbeit',
#       222 => 'Einzelfragen der Betreuungsarbeit',
#       223 => 'Zertifikatskurse',
#     }
#   },
#   224 => 'Praktikerforen'
# }
#
# categories.each do |id, cat|
#   if cat.is_a? String
#     Category.create! id: id, name: cat
#   else
#     category = Category.create! id: id, name: cat[:name]
#     cat[:subs].each do |sub_id, sub_name|
#       Category.create! id: sub_id, name: sub_name, category: category
#     end
#   end
# end
#
# PgSearch::Multisearch.rebuild(Category)
User.create!(
  username:              'micha',
  email:                 'test@example.com',
  name:                  'Micha',
  role:                  'admin',
  password:              '12341234',
  password_confirmation: '12341234'
)
# Alchemy::Seeder.seed!
