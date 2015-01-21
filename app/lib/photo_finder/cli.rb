class PhotoFinder::Cli
  def self.run
    PhotoFinder::League.new('nhl').get_photos do |photo_finder|
      photo_array = photo_finder.photos
      puts "Finding Photos for NHL & team #{photo_finder.team[:name]} \n "
      photo_array.each_with_index do |photo, index|
        puts "#{index}    #{photo}"
        #`open #{photo}`
      end

      puts "Which photo? :"
      chosen_index = gets.chomp[0]
      photo_finder.save(chosen_index)
    end
  end
end
