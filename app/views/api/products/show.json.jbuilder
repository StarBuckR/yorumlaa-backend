breadcrumb = Category.find_by(name: @product.category).path.arrange_serializable

json.breadcrumb breadcrumb

json.images @product.images.map{|img| ({ image: url_for(img) })}

json.ratings @ratings

json.product @product

user_average = 0
json.comments @all_ratings do |comment|

    comment.ratings.each do |rating|
        user_average = (user_average + rating["rating_value"]).to_f / 2.to_f
    end

    json.average_rating user_average
    json.comment comment
end