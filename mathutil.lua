local M = {}
local random, sqrt, PI, exp, log = 
      math.random, math.sqrt, math.pi, math.exp, math.log


function M.avgstd(t)
  local avg, std, count = 0, 0, 0
  for _, v in pairs(t) do
    avg=avg+v
    count=count+1
  end
  avg=avg/count
  for _, v in pairs(t) do
    std=std+(v-avg)^2
  end
  std=sqrt(std/count)
  
  return avg, std
end

function M.sample_exp_distribution(l)
  local u = random()
  local r = -log(u) / l
  return r
end

function M.productory (a, b, f)
  local p = 1
  if f then
    for k = a, b do
      p = p*f(k)
    end
  else
    for k = a, b do
      p = p*k
    end
  end
  return p
end

function M.median ( t )
  local temp={}
  local med, low, high

  -- deep copy table so that when we sort it, the original is unchanged
  -- also weed out any non numbers
  for k,v in pairs(t) do
    if type(v) == 'number' and v>0 then
      temp[#temp+1] = v
    end
  end

  table.sort( temp )
  
  if #temp==0 then return nil, nil, nil end
  
  if #temp%2 == 0 then
    med = ( temp[#temp/2] + temp[(#temp/2)+1] ) / 2
  else
    med = temp[math.ceil(#temp/2)]
  end
  
  --print ('!!1', #temp/4)
  --print ('!!2', 3*#temp/4)
  --print ('<'..#temp..'>',table.concat(temp, ' | '))

  if #temp%4 == 0 then
    low = ( temp[#temp/4] + temp[#temp/4+1] ) / 2
  else
    low = temp[math.ceil(#temp/4)]
  end
  
  if 3*#temp%4 == 0 then
    high = ( temp[3*#temp/4] + temp[3*#temp/4+1] ) / 2
  else
    high = temp[math.ceil(3*#temp/4)]
  end
  
  return med, low, high
end



return M
