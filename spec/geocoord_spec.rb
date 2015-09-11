require 'geocoord'

RSpec.describe GeoCoord do
  context "given valid geocoordinate in string format" do
    it "parses it correctly" do
      coord = GeoCoord.new("12.2,13.4")
      expect(coord.lat).to eq 12.2 
      expect(coord.long).to eq 13.4 
    end
    it "allows integer coordinates" do
      coord = GeoCoord.new("1,13.4")
      expect(coord.lat).to eq 1 
      expect(coord.long).to eq 13.4 
    end
    it "allows negative and positive values" do
      coord = GeoCoord.new("+1,-13.4")
      expect(coord.lat).to eq 1 
      expect(coord.long).to eq -13.4 
    end
    it "allows whitespace in the beginning and the end" do
      coord = GeoCoord.new("+1,-13.4 ")
      expect(coord.lat).to eq 1 
      expect(coord.long).to eq -13.4 
    end
  end
  context "invalid string formats are rejected" do
    it "raises if longitude is missing 12.2," do
      expect { GeoCoord.new("12.2,") }.to raise_error(ArgumentError, "Invalid coordinate string format")
    end
    it "raises if latitude is missing ,13.3" do
      expect { GeoCoord.new(",13.3") }.to raise_error(ArgumentError, "Invalid coordinate string format")
    end
  end
  it "correctly implements the == operator" do
    expect(GeoCoord.new("12.3,14.4")).to eq GeoCoord.new("12.3,14.4")
  end
end
      
    
