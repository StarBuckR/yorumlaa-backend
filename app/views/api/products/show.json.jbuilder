breadcrumb = Category.find_by(name: @product.category).path.arrange_serializable

json.breadcrumb breadcrumb

json.images @product.images.map{|img| ({ image: url_for(img) })}

overall_average = 0
@ratings.each do |rating|
    overall_average = (overall_average.to_f + rating.last) / 2.to_f
end

json.ratings do 
    json.overall overall_average
    json.particularly @ratings
end

json.product @product

json.comments @comments.each_with_index.to_a do |(comment, index)|
    json.comment comment

    average_rating = 0
    @all_ratings.each do |rating|
        rating.ratings.each do |value|
            average_rating = (average_rating + value["rating_value"]).to_f / 2.to_f
        end
    end

    json.rating average_rating
end