class Movie < ActiveRecord::Base

    def self.all_ratings
       
        ratingArray = Array.new
        self.select("rating").uniq.each {|x| ratingArray.push(x.rating)}
        ratingArray.sort.uniq
        
    end

end