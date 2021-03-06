class ExploreController < ApplicationController

  layout :choose_layout

  def index
    unless current_city.present?
      @css_class_cities = "index_cities"
      set_cities_to_gon
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
    result = Place.send(method, 6, params.merge!(city: current_city))
    render :json => {result: result.map{|e| Place.for_mustache(e, params.update(image_url: :main_url)) },
                     total:  result.total}
  end


  def choose_city
    @css_class_cities = "index_cities"
  end

  def update_city
    if params[:city].present?
      cookies[:city] = {
          :value => params[:city],
          :expires => 7.day.from_now,
          :domain => request.domain
      }
      path = "http://" + params[:city] +"." + request.domain
    else
      path = root_path
    end
    redirect_to path
  end

  protected
  def set_breadcrumbs_front

  end


  private
  def find_page
    if current_city
      page = City.find(current_city)
    else
      page = Structure.with_position(::PositionType.index).first
    end
    setting_meta_tags page
  end

  def set_cities_to_gon
    gon.cities = City.visible.map{|city| {latitude: city.latitude, longitude: city.longitude,
                                          slug: city.slug, title: city.title}}

  end

  def choose_layout
    return "choose_city" unless current_city.present?
    'application'
  end

end
