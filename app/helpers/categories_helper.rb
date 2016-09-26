module CategoriesHelper
  def categories_for_select
    res = {}
    Category.cat_parents.order(:number).each do |category|
      res[category.display_name] = category.id
      category.categories.order(:number, :name).each do |sub_cat|
        res["--- #{sub_cat.display_name}"] = sub_cat.id
      end
    end
    res
  end
end
