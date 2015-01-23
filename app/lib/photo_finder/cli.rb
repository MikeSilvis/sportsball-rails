class PhotoFinder::Cli
  def self.run(league)
    PhotoFinder::League.new(league).get_photos do |photo_finder|
      next if photo_finder.has_photo?

      photo_array = photo_finder.photos
      puts "Finding Photos for #{league} & team #{photo_finder.team[:name]} #{photo_finder.team[:data_name]} \n "
      photo_array.each_with_index do |photo, index|
        puts "#{index}    #{photo} \n"
        sleep 0.05
        system("open #{photo}")
      end

      puts "Which photo? :"
      chosen_index = gets.chomp[0]
      url = photo_array[chosen_index.to_i] ? photo_array[chosen_index.to_i] : chosen_index
      Thread.new { photo_finder.save_by_url(url) }
    end
  end
end
