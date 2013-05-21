class ExploreController < ApplicationController

  def index

    unless current_city.present?
      @css_class_cities = "index_cities"
      render :choose_city and return
    end

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
     when "available"
      :tonight_available
   end
    result = Place.send(method, 6, params)
    render :json => {result: result.map{|e| Place.for_mustache(e, params.update(image_url: :main_url)) },
                     total:  result.total}
  end


  def choose_city
    @css_class_cities = "index_cities"
  end

  def update_city
    if params[:city].present?
      cookies[:city] = params[:city]
    end
    redirect_to root_path
  end

  protected
  def set_breadcrumbs_front

  end


  private
  def find_page
    structure = Structure.with_position(::PositionType.index).first
    setting_meta_tags structure
  end

end
