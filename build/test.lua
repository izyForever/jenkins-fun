function receive(prod, source)
    print("receive - resume coroutine " .. source .. ' lineNum = ' .. debug.getinfo(1).currentline)
    local status, value = coroutine.resume(prod)
    return value
end

function send(x, source)
    print("send - yield coroutine: "..source  .. ' lineNum = ' .. debug.getinfo(1).currentline)
    coroutine.yield(x)
end

function producer()
    return coroutine.create(function( )
        while true do
            local x = 'ahahah!'
            print("producer - " .. x  .. ' lineNum = ' .. debug.getinfo(1).currentline)
            send(x, 'producer') -- producer 生产后主动挂起
        end
    end)
end

function filter(prod)
    return coroutine.create(function()
        local line = 1
        while true do
            local x = receive(prod, 'filter')  -- filter 唤醒 producer
            print("filter: receive "..x  .. ' lineNum = ' .. debug.getinfo(1).currentline)
            x = string.format("%5d %s",line ,x)
            send(x, 'filter') -- filter 主动挂起
            line = line + 1
        end
    end)
end

function consumer(prod)
    while true do
        local x = receive(prod, 'consumer') -- consumer 唤醒 filter
        print("consumer: receive "..x  .. ' lineNum = ' .. debug.getinfo(1).currentline)
    end
end

-- P C 
print("Hello corutine!")
local p = producer() 
local f = filter(p)
consumer(f)

