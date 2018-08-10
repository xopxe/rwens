----------------------------------------
--log file path
local out_path='./'
----------------------------------------

----------------------------------------
--mobility
local w = 1000     --area side (m)
local R = 40       --node range (m)
local v = 1        --speed (m/s)
local L = 500      --epoch length (m)
local T = 500000   --time window (s)
local t_step = 0.1 --time step (s)
----------------------------------------

----------------------------------------
--nodes
local n_nodes = 10
local r_rate = 0.01  -- arrival rate, in network
local buff_size = 100

local math, ipairs = math, ipairs
local abs, min, random = math.abs, math.min, math.random
local sample_exp_distribution = require ('mathutil').sample_exp_distribution

  
local function runsim()
  local R2 = R^2 --(m^2)

  math.randomseed(os.time())

  local lib_rw =require('lib_rw')
  local get_random_direction = lib_rw.get_random_direction
  local isin_range2 = lib_rw.isin_range2

  local lib_epidemic =require('lib_epidemic')(buff_size)
  local new_message = lib_epidemic.new_message
  local merge_buffs = lib_epidemic.merge_buffs
  
  local function set_random_direction(node)
    node.vx, node.vy = get_random_direction()
    node.vx, node.vy = v*node.vx, v*node.vy -- m/s
    node.dx, node.dy = t_step*node.vx, t_step*node.vy -- s*m/s
  end

  
  local t = 0
  
  print (t, 'CONF', 'N_NODES', n_nodes, 'N_BUFF', buff_size, 'R', r_rate)
  
  local nodes = {}
  for i=1, n_nodes do
    local node = {i=i}
    node.x, node.y = w*random(), w*random()
    set_random_direction(node)
    node.buff = {}
    node.buff_n = 0
    node.next_direction_change = sample_exp_distribution(1/L)
    if r_rate==0 then
      node.next_new_message = math.huge
    else
      node.next_new_message = sample_exp_distribution(r_rate/n_nodes)
    end
    nodes[i] = node
  end
  
  for i, n in ipairs(nodes) do
    for buffcount=1, buff_size do
      local random_dest = random(n_nodes)
      while random_dest == i do random_dest = random(n_nodes) end
      new_message(t, n, nodes[random_dest])
    end
  end
  
  local iinr = {}
  for i=1, n_nodes do iinr[i]={} end
  local function set_inr(t, i1, i2, v)
    local first, second = i1, i2
    if first>second then first, second = second, first end
    
    local isinr = iinr[first][second]
    if v and not isinr then
      print (t, 'IN', first, second)
      merge_buffs(t, nodes[i1], nodes[i2])
    end
    if not v and isinr then
      print (t, 'OUT', first, second)
    end
    iinr[first][second] = v
  end
  
  for i=1, n_nodes-1 do
    for j=i+1, n_nodes do
      local v = isin_range2(nodes[i].x, nodes[i].y, nodes[j].x, nodes[j].y, w, R, R2)
      --assert(v == isin_range2(nodes[j].x, nodes[j].y, nodes[i].x, nodes[i].y, w, R, R2))
      set_inr(0, i, j, v)
    end
  end
  
  --print ('Starting simulation')
  
  while true do
       
    for i, n in ipairs(nodes) do
      
      --new messages
      if t>=n.next_new_message then
        local random_dest = random(n_nodes)
        while random_dest==n.i do random_dest = random(n_nodes) end
        new_message(t, n, nodes[random_dest])
        n.next_new_message = t+sample_exp_distribution(r_rate/n_nodes)
      end    
      
      -- mobility
      if t>=n.next_direction_change then
        set_random_direction(n)
        n.next_direction_change = t+sample_exp_distribution(1/L)
      end
      
      local x, y = n.x, n.y
      x, y = x+n.dx, y+n.dy
      if x>w then x=x-w 
      elseif x<0 then x=x+w end
      if y>w then y=y-w 
      elseif y<0 then y=y+w end
      n.x, n.y = x, y
    
      --for i2, n2 in ipairs(nodes) do
      for i2=i+1, n_nodes do
        local n2 = nodes[i2]
        local v = isin_range2(n.x, n.y, n2.x, n2.y, w, R, R2)
        set_inr(t, i, i2, v)
      end
    end
    t=t+t_step

    if t>=T then 
      return 
    end
  end
end

--io.stdout:setvbuf 'no'    -- switch off buffering for stdout

local oldprint = print

for ibuff_size = 20,100,20 do
  for _, ir_rate in ipairs({0.0, 0.0025, 0.005, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.2}) do --  for ieT=10000, 20000, 1000 do
    for in_nodes=20, 100, 20 do
      
for ibuff_size = 20,20,20 do
  for _, ir_rate in ipairs({0.0, 0.0025, 0.005, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.2}) do --  for ieT=10000, 20000, 1000 do
    for in_nodes=100, 100, 20 do
      
      
      buff_size=ibuff_size
      r_rate = ir_rate
      n_nodes = in_nodes
      local f=assert(io.open(out_path..'r/'..'B'..tostring(buff_size)..'_N'..tostring(n_nodes)..'_R'..tostring(r_rate)..'_log.txt','w'))
      print = function (...)
        f:write(table.concat({...}, "\t")..'\n')
      end
      oldprint('buff_size', buff_size, 'r', r_rate, 'N', n_nodes)
      runsim()
    end
  end
end
