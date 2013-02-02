module PlaceUtils
  class PlaceTime
    class << self
      def find_available_time(i, time, start_time, end_time)
        time_now = DateTime.now.strftime("%H.%M").to_f
        reverse_time = time.strftime("%H.%M").to_f
        end_time = (Time.parse(end_time.to_s.sub(".",":")) - 60.minutes).strftime("%H.%M").to_f
        range_time = (start_time...end_time)
        if reverse_time == 16.00 && time_now <= 15.00 && end_time <= 23.00
          {:time => (time + i.minutes).strftime("%H:%M").to_sym,
           :available => (i > 0 && is_available?(time+i.minutes, range_time))}
        else
          {:time => (time + i.minutes).strftime("%H:%M").to_sym, :available => is_available?(time+i.minutes, range_time)}
        end
      end

      def is_available?(time, range_time)
        range_time.cover? time.strftime("%H.%M").to_f
      end
    end
  end
end
