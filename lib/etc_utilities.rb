def eval_request (snippet)
    begin
        evaluation = eval(snippet)
        status = 'Yes!, '
    rescue Exception => e
        evaluation = e
        status = 'Yes!, but it failed, see error: '
    end
    result = status + evaluation.to_s
end

def md5_hash_string(string:, truncate_size: 8)
    full_hash = Digest::MD5.hexdigest(string)
    truncated_hash = full_hash[0,truncate_size]
    return {:full => full_hash, :truncated => truncated_hash }
end
