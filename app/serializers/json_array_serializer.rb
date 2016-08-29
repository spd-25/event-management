class JsonArraySerializer
  include Enumerable
  include Virtus.model

  def self.array_of(klass)
    @klass = klass
    raise 'class must respond to dump' unless klass.respond_to?(:dump)
    attribute :items, Array[klass]
  end

  def self.dump(data)
    data.map { |item| @klass.dump(item) }
  end

  def self.load(data)
    case data
    when nil, '' then new
    when String  then new(items: JSON.parse(data))
    when Array   then new(items: data)
    end
  end

  def each(&block)
    @items.each(&block)
  end

  def inspect
    @items.inspect
  end
end
