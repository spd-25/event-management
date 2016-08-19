module CategoriesHelper
  def categories_for_select
    res = {}
    Category.cat_parents.order(:name).each do |category|
      res[category.name] = category.id
      category.categories.order(:name).each do |sub_cat|
        res["--- #{sub_cat.name}"] = sub_cat.id
      end
    end
    res
  end
end
