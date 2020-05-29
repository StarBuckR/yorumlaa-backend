json.comments @comments.each_with_index.to_a do |(comment, index)|
    json.comment comment

    average_rating = 0
    @ratings.each do |rating|
        rating.ratings.each do |value|
            average_rating = (average_rating + value["rating_value"]).to_f / 2.to_f
        end
    end

    json.rating average_rating
end