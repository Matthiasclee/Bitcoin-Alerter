require 'json'
require 'httparty'
require './TwilioEZ.rb'
require 'net/http'
require 'active_support'
require 'active_support/core_ext/numeric/conversions'
def sendX(x)
	a = File.read("list").split("\n")
	b = a.length
	c = 0
	while c < b
		sendSMS(a[c], x)		
		c = c + 1
	end
end
while 1
chr = Time.now.hour
if chr > 5 && chr < 21
	price = JSON.parse(HTTParty.get("https://api.coindesk.com/v1/bpi/currentprice.json"))["bpi"]["USD"]["rate_float"].to_f.round(2).to_s(:delimited)
	if price.split(".")[1].length == 1
		price  = price + "0"
	end
	sendX("Current Price: $#{price}")
end
sleep(3600)
end