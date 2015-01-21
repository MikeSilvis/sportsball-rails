namespace :photo_finder do
  desc 'Gets photos for a specific league'
  task get: :environment do
    PhotoFinder::Cli.run
  end
end
