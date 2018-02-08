class ExampleJob < ApplicationJob
  queue_as :default

  def perform(*args)
    sleep 10
  end
end
