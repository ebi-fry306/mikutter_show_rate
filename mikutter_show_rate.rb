#-*- coding: utf-8 -*-

require 'open-uri'
require 'json'

Plugin.create :mikutter_show_rate do

	now = Time.new
  	time = Time.mktime now.year, now.mon, now.day, now.hour ,now.min ,now.sec

	currency = ["USD","EUR","GBP"]
	rate = currency
	i = 0

	for str in currency do
		api = "http://rate-exchange.appspot.com/currency?from=" + str + "&to=jpy"
		source = open(api).read()
		json = JSON.parser.new(source)
		hash = json.parse()
		rate[i] = hash['rate']
		i += 1
	end

	date = "#{time.year}年#{time.mon}月#{time.day}日#{time.hour}時#{time.min}分#{time.sec}秒現在\n\n"
	currency = ["USD","EUR","GBP"]

	r = ""
	j = 0

	for var in rate do
		r = r + "1 " + currency[j] + " = " + var.to_s + " JPY\n"
		j += 1
	end

	post = date + r + "\nです。"

	command(:mikutter_show_rate,
		name: '為替',
		condition: lambda{ |opt| true },
		icon: 'http://i.imgur.com/G0HEa0D.png',
		visible: true,
		role: :window) do |opt|
		Plugin.call(:update, nil, [Message.new(message: post, system: true)])
	end
end