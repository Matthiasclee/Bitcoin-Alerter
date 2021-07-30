require 'sinatra'
require 'json'
require 'httparty'
require './TwilioEZ.rb'
require 'net/http'
require 'active_support'
require 'active_support/core_ext/numeric/conversions'
def chart(days)
	timestamp = days
	olddate = Time.at(Time.now.to_i - (86400 * (timestamp.to_i - 1))).to_s.split(" ")[0]
	now = Time.now.to_s.split(" ")[0]
	data = JSON.parse(HTTParty.get("https://api.coindesk.com/v1/bpi/historical/close.json?start=#{olddate}&end=#{now}"))["bpi"]
	dates = data.keys.to_s
	prices = data.values.to_s
	url = "https://quickchart.io/chart?bkg=white&c={ type: 'bar', data: { labels: #{dates}, datasets: [{ label: 'Price', data: #{prices} }] }}"
	outurl = "http://xn--zga.net/" + HTTParty.post('http://xn--zga.net/api', body: {"url" => url, "csturl" => "BitcoinChart#{rand(10000000..99999999)}"})
	puts outurl
	return outurl
end
post("/rcvsms") do
	pnmr = params["From"].gsub("-", "").gsub("(", "").gsub(")", "").gsub("+1", "").gsub(" ", "")
	pnmr = "+1" + pnmr
if params["Body"].downcase == "get updates"
	if File.read("list").include?(pnmr)
		sendSMS(pnmr, "You are already subscribed. Text \"stop updates\" to unsubscribe.")
	else
		File.write("list", "\n#{pnmr}", mode: "a")
		sendSMS(pnmr, "You have successfully been subscribed to hourly Bitcoin price alerts. Text \"stop updates\" to unsubscribe.")
	end
end
if params["Body"].downcase == "stop updates"
	if File.read("list").include?(pnmr)
		newlist = File.read("list").gsub("\n#{pnmr}", "")
		File.write("list", newlist)
		sendSMS(pnmr, "You have successfully been unsubscribed from hourly Bitcoin price alerts. Text \"get updates\" to resubscribe.")
	else
		sendSMS(pnmr, "You are not subscribed to hourly bitcoin price updates. Text \"get updates\" to subscribe.")
	end
end
if params["Body"].downcase == "price"
	price = JSON.parse(HTTParty.get("https://api.coindesk.com/v1/bpi/currentprice.json"))["bpi"]["USD"]["rate_float"].to_f.round(2).to_s(:delimited)
	if price.split(".")[1].length == 1
		price  = price + "0"
	end
	sendSMS(pnmr, "$#{price}")
end
if params["Body"].downcase.split(" ")[0] == "chart" && params["Body"].downcase.split(" ")[1] != nil
	num = params["Body"].downcase.split(" ")[1].to_i
	if num < 251 && num > 0
		sendSMS(pnmr, chart(params["Body"].downcase.split(" ")[1]))
	else
		sendSMS(pnmr, "You must choose a number between 1 and 250")
	end
	#
end
end