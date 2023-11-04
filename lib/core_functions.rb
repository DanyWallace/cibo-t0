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