class GeoCoord
  attr_reader :lat
  attr_reader :long
	
  def initialize(coord_as_string)
    match = /^([-+]?[0-9]+(?:\.[0-9]*)?),([-+]?[0-9]+(?:\.[0-9]*)?){1}$/.match(coord_as_string.strip)
    raise ArgumentError.new('Invalid coordinate string format') if match.nil?
    
    @lat = match[1].to_f
    @long = match[2].to_f
  end

  def ==(o)
    o.class == self.class && o.lat == lat && o.long == long 
  end
end	
