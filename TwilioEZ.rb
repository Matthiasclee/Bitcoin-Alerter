require 'twilio-ruby'

$accountsid = "" #ACCOUNT SID HEERE
$authtoken = "" #AUTH TOKEN HERE
$phone = "" #SENDING PHONE NUMBER HERE

def sendSMS(to, body = "No body was send for this message.", media = nil)

account_sid = $accountsid
auth_token = $authtoken
@client = Twilio::REST::Client.new(account_sid, auth_token)

if media
  message = @client.messages.create(
                             body: body,
                             from: $phone,
                             media_url: [media],
                             to: to
)
else
  message = @client.messages.create(
                             body: body,
                             from: $phone,
                             to: to
)
end
return message.sid
end
def call(to, tml = "https://handler.twilio.com/twiml/EHaa77fc48367b411a5f2a2c76f825e83f")
	account_sid = $accountsid
	auth_token = $authtoken
	@client = Twilio::REST::Client.new(account_sid, auth_token)

	call = @client.calls.create(
  	                     url: tml,
  	                     to: to,
   	                    from: $phone
   	                  )
return call.sid
end
