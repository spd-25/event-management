desc 'convert old tree structure to new one'

def category_params(parent_id = nil)
  { parent_id: parent_id, position: Category.next_position_for(2017, parent_id), year: 2017 }
end

task rebuild_category_structure: :environment do
  begin
    puts
    Category.cat_parents.order(:number).all.each do |category|
      category.update! category_params
      category.categories.order(:number, :name).each do |sub_cat|
        sub_cat.update! category_params(category.id)
      end
    end
    puts "#{Category.count} categories updated"
  rescue ActiveRecord::RecordInvalid => e
    puts e.record.inspect, e.record.errors.full_messages
  end
end

task rebuild_category_structure_check: :environment do
  begin
    puts
    Category.all.each {|cat| raise "not equal for cat #{cat.id}" unless cat.parent == cat.category}
    puts 'all good'
  end
end
