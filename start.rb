require 'discordrb'
require 'json'
require 'net/http'
require 'openai'
require 'sinatra'

load 'lib/etc_utilities.rb'
load 'lib/openai.rb'

if ENV['DISCO_TOKEN'] or ENV['OAI_KEY']
    token = ENV['DISCO_TOKEN']
else
    puts 'No token found in ENV(DISCO_TOKEN) or ENV(OAI_KEY)'
end

# start discord
discord_client = Discordrb::Bot.new token: token
# puts "invite url: #{discord_client.invite_url}"

# All messages are catched here, mainly for logging
discord_client.message do |event|
    puts "Message: #{event.author.name}:#{event.author.id}: #{event.content} - #{Time.now}"
    # log to db?
end

# trigger on mention
discord_client.mention do |event|
    # The `pm` method is used to send a private message (also called a DM or direct message) to the user who sent the
    # initial message.
    # event.user.pm('You have mentioned me!')
    # puts "Mentioned by: #{event.user.name} - #{Time.now}"
    puts "Mentioned by #{event.user.name}: #{event.content} - #{Time.now}"

    user_request = event.content

    case user_request
    when /eval:/
        # break unless event.author.name == ENV['DISCO_OWNER_USERNAME']
        break unless event.author.id == ENV['DISCO_OWNER_ID'].to_i
        eval_req = event.content.split(': ')[1]
        eval_result = eval_request(eval_req)
        event.respond eval_result
        puts eval_result
    when /invite.*[?]/
        oai_invite_handle_result = oai_invite_handle(user_request, discord_client.invite_url)
        event.respond oai_invite_handle_result
        puts oai_invite_handle_result
    when /hash:/
        hash_result = md5_hash_string(string: user_request)
        event.respond hash_result[:full]
        puts hash_result[:full]
    end
end

# for me
discord_client.message(content: 'Cibo, Stop!') do |event|
    if event.author.id == ENV['DISCO_OWNER_ID'].to_i
        event.respond 'Yes! Dany?'
    end
end


class App < Sinatra::Base
    configure do
        set port: 8080
    end

    get '/' do
        'Go away'
    end

end

Thread.new { App.run! }
puts 'Started Sinatra'


puts 'Starting Discord Client'
Thread.new { discord_client.run }
#discord_client.run
#puts 'Started Discord Client'