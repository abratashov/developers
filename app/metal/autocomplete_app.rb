# -*- encoding : utf-8 -*-
class AutocompleteApp
  def self.call(env)
    params = Rack::Request.new(env).params
    if params['q'].present?
      entries = Autocomplete.search(params['q'])

      if entries.empty?
        entries = Autocomplete.search(params['q'].tr_lang)
      end

      if entries.size < 5
        words = params['q'].split(/\s+/)
        words.each_with_index do |w, i|
          next if i.zero?
          w_entries = Autocomplete.search(w)
          w_entries.each do |w_e|
            entries << words.dup.tap{|ws| ws[i] = w_e }.join(' ')
          end
        end
      end

      res = {:suggestions => entries, :query => params['q']}
      [200, {"Content-Type" => "application/json"}, res.to_json]
    else
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end
  end


end