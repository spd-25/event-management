
ActiveRecord::Base.send :include, Address::ActsAsAddressable
ActiveRecord::Base.send :include, Contact::ActsAsContactable
