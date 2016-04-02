# Week 2 Lab - HTML Report from CSV
## Creating an HTML Report from parsing CSV, including a Chart.
###### Due Monday, February 15, 2016  Ruby Fundamentals

## Objectives
###### Learning Objectives
After completing this assignment, you should…
* Understand data design
* Deeply understand ruby styles, variables, and loops

###### Performance Objectives
After completing this assignment, you be able to effectively use
* ruby on the command line
* data, erb
* comma seperated values (CSV)
* Charts

## Details
###### Deliverables
* A link to a github repository with at least the following:
```
  * planet_express_logs.csv
  * data_parser.rb
  * report.erb
  * styles.css
```
###### Requirements
* I should be able to run `ruby data_parser.rb` and have report.html generated
* The HTML file should have some styles, use normalize
* The HTML should have a pie chart using Google charts, like so:
![alt text][logo]

[logo]: http://i.imgur.com/8trAn2j.png "Chart"

###### Optional Ideas
1. Use Material Design Light to style your report
2. Use Bootstrap to style your report
3. Use SASS locally

## Normal Mode
Good news Rubyists!

We have a week of records tracking what we shipped at Planet Express. I need you to answer a few questions for Hermes.

1. How much money did we make this week?
2. How much of a bonus did each employee get? (bonuses are paid to employees who pilot the Planet Express)
3. How many trips did each employee pilot?
Different employees have favorite destinations they always pilot to

* Fry - pilots to Earth (because he isn't allowed into space)
* Amy - pilots to Mars (so she can visit her family)
* Bender - pilots to Uranus (teeheee...)
* Leela - pilots everywhere else because she is the only responsible one
They get a bonus of 10% of the money for the shipment as the bonus

And so: We need sections on the HTML with:

1. h1 with the total money we made this week
2. List of all Shipments (create a table with the shipments listed)
3. List of all employees and their number of trips and bonus
4. Pie chart of the Money each employee delivered
5. A gif, preferably related to Fry, Amy, Bender, and/or Leela

## Difficult Mode
* How much money did we make broken down by planet? ie.. how much did we make shipping to Earth? Mars? Saturn? etc.

## Epic Mode
* No methods can be longer than 10 lines long
* Define a class "Parse", with a method `parse_data`, with an argument `file_name`
* Make `data_parser.rb executable` with a command line argument of the file name `./data_parser.rb planet_express_logs.csv > report.html`

## Notes
File name: `planet_express_logs.csv`

```Destination,Shipment,Crates,Money
Earth,Hamburgers,150,30000
Moon,Tacos,33,44500
Earth,Movies,34,5000
Mars,BBQ Sauce,999,15000
Uranus,Whiskey,1000,345600
Jupiter,Books,10,3451
Pluto,Beer,100,2344
Uranus,Pizza,66,10000
Saturn,Pizza,26,1000
Mercury,Pizza,36,80000
```

###### sample ruby code
```
require 'csv'
CSV.foreach("planet_express_logs.csv", headers: true) do |row|
  puts row.inspect # replace with your logic
end
```
###### sample code to create an HTML file from a `template.erb`
```
html_string = File.read("template.erb")
compiled_html = ERB.new(html_string).result(binding)
File.open("./index-output.html", "wb") {|file|
    file.write(compiled_html)
    file.close()
}
```

## Additional Resources
* [Google Chart Docs] (https://google-developers.appspot.com/chart/interactive/docs/gallery/piechart)
* [JS Fiddle of working Google Chart] (https://jsfiddle.net/0q925L2d/)
* [ERB Docs] (http://ruby-doc.org/stdlib-2.2.3/libdoc/erb/rdoc/ERB.html)
* Read http://www.nostarch.com/rubywizardry if you feel lost on Ruby basics
* [CSV documentation] http://ruby-doc.org/stdlib-2.2.2/libdoc/csv/rdoc/CSV.html
