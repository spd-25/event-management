require 'support/helpers/session_helpers'
require 'support/helpers/persistence_helpers'
require 'support/helpers/clickable_table_helpers'
RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
  config.include Features::PersistenceHelpers, type: :feature
  config.include Features::ClickableTableHelpers, type: :feature
end
