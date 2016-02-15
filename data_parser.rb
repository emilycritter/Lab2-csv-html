require 'csv'
require 'erb'

# ==================== read
the_html = File.read("report.template.html")

# Methods
def parse_data file_name
	parse_data_cont file_name, []
end
def parse_data_cont file_name, rows
  CSV.foreach(file_name, headers: true) do |row|
    rows << row.to_hash
  end
  rows
end


def formatted_number(n)
  a,b = sprintf("%0.2f", n).split('.')
  a.gsub!(/(\d)(?=(\d{3})+(?!\d))/, '\\1,')
  "$#{a}.#{b}"
end


def add_pilot ary_of_hsh
  ary_of_hsh.each do |hsh|
    case hsh["Destination"]
      when 'Earth'; hsh.merge!({"Pilot"=>"Fry"})
      when 'Mars'; hsh.merge!({"Pilot"=>"Amy"})
      when 'Uranus'; hsh.merge!({"Pilot"=>"Bender"})
      else; hsh.merge!({"Pilot"=>"Lela"})
    end
  end
  ary_of_hsh
end

def add_bonus ary_of_hsh
  ary_of_hsh.each do |hsh|
    hsh.merge!({"Bonus"=>"#{hsh["Money"].to_f*0.1}"})
  end
end

theme_color = '#60BBB2'
def darken_color(hex_color, amount)
  hex_color = hex_color.gsub('#','')
  rgb = hex_color.scan(/../).map {|color| color.hex}
  rgb[0] = (rgb[0].to_i * amount).round
  rgb[1] = (rgb[1].to_i * amount).round
  rgb[2] = (rgb[2].to_i * amount).round
  "#%02x%02x%02x" % rgb
end

def lighten_color(hex_color, amount)
  hex_color = hex_color.gsub('#','')
  rgb = hex_color.scan(/../).map {|color| color.hex}
  rgb[0] = [(rgb[0].to_i + 255 * amount).round, 255].min
  rgb[1] = [(rgb[1].to_i + 255 * amount).round, 255].min
  rgb[2] = [(rgb[2].to_i + 255 * amount).round, 255].min
  "#%02x%02x%02x" % rgb
end

def ary_to_hex_ary (hex, ary)
  percent = (1.00 / (ary.count + 1).to_f).round(2)
  light = lighten_color(hex, 0.2)
  new_ary = []
  ary.each_with_index do |hsh, i|
    dark = darken_color(light, percent*(i+1))
    hsh = hsh.merge({color: "#{dark}"})
    new_ary.push(hsh)
  end
  new_ary
end

def pie_chart_prep ary_of_hsh, hsh_values, label, new_ary, theme_color
	new_ary = ary_of_hsh.map {|hsh| {value: hsh[hsh_values].to_f, label: "#{hsh[label]}"}}
	new_ary = ary_to_hex_ary(theme_color, new_ary)
	return new_ary
end


records = parse_data 'planet_express_logs.csv' # Parse data
add_pilot records # Add pilot key
add_bonus records # Add bonus key


# Get weekly revenue
total_rev = (records.map {|records| records["Money"].to_f}).reduce(:+)
total_rev = formatted_number(total_rev)

# Get number of crates
total_crates = (records.map {|records| records["Crates"].to_i}).reduce(:+)

# Get bonuses paid
total_bonus = (records.map {|records| records["Bonus"].to_f}).reduce(:+)
total_bonus = formatted_number(total_bonus)

# Create hashes with pilot summary values
pilot_ary = []
records.each do |hsh|
  pilot_new = {}
  pilot_new["Pilot "] = hsh["Pilot"]
  if pilot_ary.any? {|h| h["Pilot "] == hsh["Pilot"]}
  else
    pilot_new = {}
    pilot_new["Pilot "] = hsh["Pilot"]
    pilot_new["Delivery Total"] = records
      .select {|records| records["Pilot"] == hsh["Pilot"]}
      .map {|records| records["Money"].to_f}
      .reduce(:+)

    pilot_new["Bonus Total"] = records
      .select {|records| records["Pilot"] == hsh["Pilot"]}
      .map {|records| records["Bonus"].to_f}
      .reduce(:+)

    pilot_new["Delivery Count"] = records
      .select {|records| records["Pilot"] == hsh["Pilot"]}
      .map {|records| records["Pilot"]}
      .count
    pilot_ary << pilot_new
  end
end
# puts pilot_ary.inspect
# pilot_ary.each do |hsh|
#   puts "'string', '#{hsh[:name]}'"
# end
# pilot_ary.each do |hsh|
#   puts hsh.values.inspect
# end

pilot_pie_title = "Sales by Pilot"
pilot_pie = pie_chart_prep(pilot_ary, "Delivery Total", "Pilot ", [], theme_color)

# Create hashes with planet summary values
planet_ary = []
records.each do |hsh|
  planet_new = {}
  planet_new["Destination "] = hsh["Destination"]
  if planet_ary.any? {|h| h["Destination "] == hsh["Destination"]}
  else
    planet_new = {}
    planet_new["Destination "] = hsh["Destination"]
    planet_new["Delivery Total"] = records
      .select {|records| records["Destination"] == hsh["Destination"]}
      .map {|records| records["Money"].to_f}
      .reduce(:+)

    planet_new["Bonus Total"] = records
      .select {|records| records["Destination"] == hsh["Destination"]}
      .map {|records| records["Bonus"].to_f}
      .reduce(:+)

    planet_new["Delivery Count"] = records
      .select {|records| records["Destination"] == hsh["Destination"]}
      .map {|records| records["Pilot"]}
      .count
    planet_ary << planet_new
  end
end
# puts planet_ary.inspect
# planet_ary.each do |hsh|
#   puts "'string', '#{hsh[:name]}'"
# end
# planet_ary.each do |hsh|
#   puts hsh.values.inspect
# end

planet_pie_title = "Sales by Planet"
planet_pie = pie_chart_prep(planet_ary, "Delivery Total", "Destination ", [], theme_color)

# format dollar values
records.each do |hsh|
  hsh["Money"] = formatted_number(hsh["Money"]) if hsh.has_key?("Money")
  hsh["Bonus"] = formatted_number(hsh["Bonus"]) if hsh.has_key?("Bonus")
end
pilot_ary.each do |hsh|
  hsh["Delivery Total"] = formatted_number(hsh["Delivery Total"]) if hsh.has_key?("Delivery Total")
  hsh["Bonus Total"] = formatted_number(hsh["Bonus Total"]) if hsh.has_key?("Bonus Total")
end


# ==================== replace
new_html = ERB.new(the_html).result(binding)

# ==================== write
File.open('report.html', 'wb') do |file|
  file.write new_html
  file.close
end

# open file when run
system 'open report.html'
