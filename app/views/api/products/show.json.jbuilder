breadcrumb = Category.find_by(name: @product.category).path.arrange_serializable

json.product @product

json.breadcrumb breadcrumb
json.comments @comments