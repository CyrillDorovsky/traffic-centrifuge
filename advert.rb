module Advert
  require 'net/http'
  require 'json'

  class << self

    def games
      row_list = { 
        kings_empire:     { 'id' => 45655, kind: 'games', 'title' => 'Kings Empire', 'extended_style'=> 'color:#fff;' },
        world_of_tanks:   { 'id' => 45659, kind: 'games', 'title' => 'World of Tanks Blitz', 'extended_style'=> 'color:#fff;' },
      }
      row_list.each do | title, app |
        row_list[ title ][ :link ] = "http://target.xeclick.com/o/#{ app[ 'id' ] }"
        uri = URI( "http://xeclick.com/o/#{ app[ 'id' ] }.json" )
        begin
          app.merge! JSON.parse( Net::HTTP.get( uri ) )
        rescue; end; end
      row_list
    end

    def apps
      row_list = { 
        lazy:             { 'id' => 45658, kind: 'apps', 'title' => 'Lazy Swipe', image_url: 'apps_images/lazy.jpg'},
        du_battery_saver: { 'id' => 45656, kind: 'apps', 'title' => 'DU Battery Saver', 'extended_style'=> 'color:#fff;' },
        leo_privacy:      { 'id' => 45657, kind: 'apps', 'title' => 'LEO Privacy Guard', 'extended_style'=> 'color:#fff;' }
      }
      row_list.each do | title, app |
        row_list[ title ][ :link ] = "http://target.xeclick.com/o/#{ app[ 'id' ] }"
        uri = URI( "http://xeclick.com/o/#{ app[ 'id' ] }.json" )
        begin
          app.merge! JSON.parse( Net::HTTP.get( uri ) )
        rescue; end; end
      row_list
    end

    def index
      row_list = { 
        lazy:             { 'id' => 45658, kind: 'apps', 'title' => 'Lazy Swipe', image_url: 'apps_images/lazy.jpg'},
        kings_empire:     { 'id' => 45655, kind: 'games', 'title' => 'Kings Empire', 'extended_style'=> 'color:#fff;' },
        world_of_tanks:   { 'id' => 45659, kind: 'games', 'title' => 'World of Tanks Blitz', 'extended_style'=> 'color:#fff;' },
        du_battery_saver: { 'id' => 45656, kind: 'apps', 'title' => 'DU Battery Saver', 'extended_style'=> 'color:#fff;' },
        leo_privacy:      { 'id' => 45657, kind: 'apps', 'title' => 'LEO Privacy Guard', 'extended_style'=> 'color:#fff;' }
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
