@oai_urls = { completions: 'https://api.openai.com/v1/completions' }

def oai_invite_handle (prompt, invite_url)
    url = URI(@oai_urls[:completions])
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/json'
    request["Authorization"] = "Bearer #{ENV['OAI_KEY']}"
    
    instruction = 'Respond yes or no if the following message asks for your bot url/link/invite or so, however if he wants you to invite someone respond no as well: ' + prompt
    request.body = {
      "model" => "gpt-3.5-turbo-instruct",
      "prompt" => instruction,
      "max_tokens" => 50,
      "temperature" => 0
    }.to_json
    
    http_request = Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
      http.request(request)
    end
    
    response_data = JSON.parse(http_request.read_body)
    response = response_data['choices'][0]['text']

    if response.include? 'Yes'
        return 'Here is my invite link, ' + invite_url
    elsif response.include? 'No'
        return 'I can give you my invite link but I can not invite anyone for you: ' + invite_url
    else
        return 'I do not know how to respond to that, here is my invite url tho: ' + invite_url
    end
end

def explain (prompt)
end