class Address < JsonObjectSerializer

  attribute :title,  String
  attribute :street, String
  attribute :zip,    String
  attribute :city,   String

  attribute :location, GeoLocation

  def self.dump(options)
    return options if options.is_a? Hash
    atts = options.attributes.to_h
    atts[:location] = options.location.attributes if options.location
    atts
  end

  def to_s
    "#{street}\n#{zip} #{city}"
  end

  def full_address
    "#{title}\n#{to_s}"
  end

  def gmaps_search_link
    ['https://maps.google.de?q=', street, zip, city].join(' ')
  end

  module ActsAsAddressable
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods

      def acts_as_addressable(options = {})
        field_name = options[:field_name] || :address
        prefix = options.has_key?(:prefix) ? options[:prefix] : true
        serialize field_name, ::Address

        ::Address.attribute_set.each do |attribute|
          delegate attribute.name, to: field_name, prefix: prefix
          delegate "#{attribute.name}=", to: field_name, prefix: prefix
        end
      end
    end
  end

end

