module Advert
  require 'net/http'
  require 'json'

  class << self

    def apps
      row_list = { 
        lazy:             { 'id' => 45658, 'title' => 'Lazy Swipe', image_url: 'apps_images/lazy.jpg'},
        kings_empire:     { 'id' => 45655, 'title' => 'Kings Empire' },
        world_of_tanks:   { 'id' => 45659, 'title' => 'World of Tanks Blitz' },
        du_battery_saver: { 'id' => 45656, 'title' => 'DU Battery Saver' },
        leo_privacy:      { 'id' => 45657, 'title' => 'LEO Privacy Guard' }
      }
      row_list.each do | title, app |
        row_list[ title ][ :link ] = "http://target.xeclick.com/o/#{ app[ 'id' ] }"
        uri = URI( "http://xeclick.com/o/#{ app[ 'id' ] }.json" )
        begin
          app.merge! JSON.parse( Net::HTTP.get( uri ) )
        rescue; end; end
      row_list
    end

  end
end
