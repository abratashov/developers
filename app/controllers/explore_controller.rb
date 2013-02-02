class ExploreController < ApplicationController

  def index
    params.merge!(city: current_city)
    places = Place.best_places(6, params)
    new_place = Place.new_places(6, params)
    tonight_available = Place.tonight_available(6, params)
    @tabs = {best: places, new: new_place, available: tonight_available}
  end

  def get_more
    method = case params[:type]
     when "best"
      :best_places
     when "new"
      :new_places
     when "tonight"
      :tonight_available
   end
    result = Place.send(method, 6, params)
    render :json => {result: result.map{|e| Place.for_mustache(e, params.update(image_url: :main_url, time: @time)) },
                     total:  result.total}
  end


  def change_city

  end


end
