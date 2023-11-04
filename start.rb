require 'discordrb'
require 'json'
require 'openai'

load 'lib/core_functions.rb'

if ENV['DISCO_TOKEN']
    token = ENV['DISCO_TOKEN']
else
    puts 'No token found in ENV(DISCO_TOKEN)'
end
discord_client = Discordrb::Bot.new token: token
# puts "invite url: #{client.invite_url}"

# All messages are catched here, mainly for logging
discord_client.message do |event|
    puts "Message: #{event.author.name}:#{event.author.id}: #{event.content} - #{Time.now}"

    if event.content.start_with?('Cibo, eval:')
        # break unless event.author.name == ENV['DISCO_OWNER_USERNAME']
        break unless event.author.id == ENV['DISCO_OWNER_ID'].to_i
        # snippet = event.content[12..-1]
        snippet = event.content.split(':')[1]
        eval_result = eval_request(snippet)
        event.respond eval_result
    end
end

# trigger on mention
discord_client.mention do |event|
    # The `pm` method is used to send a private message (also called a DM or direct message) to the user who sent the
    # initial message.
    # event.user.pm('You have mentioned me!')
    # puts "Mentioned by: #{event.user.name} - #{Time.now}"
    puts "Mentioned by: #{event.user.name} - #{Time.now}, SLEEPING 10 SECS?"
    event.respond 'Yes?!?!'
end

# for me
discord_client.message(content: 'Cibo, Stop!') do |event|
    if event.author.id == ENV['DISCO_OWNER_ID'].to_i
        event.respond 'Yes! Dany?'
    end
end

discord_client.run