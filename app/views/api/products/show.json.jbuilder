breadcrumb = Category.find_by(name: @product.category).path.arrange_serializable

json.images @product.images.map{|img| ({ image: url_for(img) })}
 
json.product @product

json.breadcrumb breadcrumb
json.comments @comments