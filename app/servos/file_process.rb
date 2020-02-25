class FileProcess
  class << self
    def type_request type
      case type
      when "orphan"
        get_orphan_count
      when "close_to_sun"
        get_cts
      when "by_year"
        get_by_year
      end
    end

    def get_orphan_count
      $planet_data.select {|data| data["TypeFlag"] == 3}.count
    end

    def get_cts
      $planet_data.select{|x| x["DistFromSunParsec"] != ""}.min_by{|x| x["DistFromSunParsec"]}["PlanetIdentifier"]
    end

    def get_by_year
      year_data = {}
      data_p = $planet_data.select{ |x| x["DiscoveryYear"] != "" && x["RadiusJpt"] != "" }.each do |data|
        begin
          year_data[data["DiscoveryYear"]] ||= {}
          year_data[data["DiscoveryYear"]]["small"] ||= 0
          year_data[data["DiscoveryYear"]]["medium"] ||= 0
          year_data[data["DiscoveryYear"]]["large"] ||= 0
          year_data[data["DiscoveryYear"]]["small"]+= 1 if data["RadiusJpt"] <= 1
          year_data[data["DiscoveryYear"]]["medium"]+= 1 if data["RadiusJpt"] <= 2 && data["RadiusJpt"] > 1
          year_data[data["DiscoveryYear"]]["large"]+= 1 if data["RadiusJpt"] > 2
        rescue StandardError => e
        return e
        end
      end
      year_data
    end
  end
end
