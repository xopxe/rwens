return function(buff_size)
  local m = {}
  local arrived = {}

  local math=math
  local abs, min = math.abs, math.min
  local random = math.random

  local mid = 0
  local function new_mid()
    mid=mid+1
    return mid
  end

  local function insert_msg(t, n, msg)
    if n.buff_n<buff_size then
      n.buff_n = n.buff_n + 1
      n.buff[n.buff_n] = msg
      n.buff[msg] = true
    else
      local pos = random(buff_size)
      print (t, 'EVICT', n.i, '#'..n.buff[pos].mid)
      n.buff[n.buff[pos]] = nil
      n.buff[pos] = msg
      n.buff[msg] = true
    end
  end


  m.new_message = function (t, n, dest)
    local msg = {
      mid = new_mid(),
      dest = dest,
      emitter = n,
    }
    print(t, 'NEW', '#'..msg.mid, n.i..'->'..dest.i)
    insert_msg(t, n, msg)
  end
    
    
  m.merge_buffs = function (t, n1, n2)
    for _, msg in ipairs(n1.buff) do
      if not n2.buff[msg] then
        print(t, 'MERGE', n2.i, '#'..msg.mid)
        insert_msg(t, n2, msg)
        if msg.dest == n2 then
          if not arrived[msg] then
            print (t, 'ARRIVED', n2.i, '#'..msg.mid)
            arrived[msg] = true
          else
            print (t, 'LATEARRIVED', n2.i, '#'..msg.mid)
          end
        end      
      end
    end
    
  end

  return m
end