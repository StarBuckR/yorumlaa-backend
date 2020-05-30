json.products @products.each_with_index.to_a do |(product, index)|
    json.product product
    json.images product.images.map{|img| ({ image: url_for(img) })}
    overall_average = 0

    @ratings[index].each do |rating|
        overall_average = (overall_average.to_f + rating.last) / 2.to_f # last weird but it gives value
    end
    json.ratings do
        json.overall overall_average
        json.particularly @ratings[index]
    end
end