require './config/application.rb'

image_loc = File.join(AppRoot, "test", "samples", "biomancer.jpg")
card = CardParser.new(file_loc: image_loc).parse!

puts "#{card.name} - #{card.mana_cost}"
