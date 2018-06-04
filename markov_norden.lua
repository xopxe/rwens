
local random, sqrt, PI, exp, log = math.random, math.sqrt, math.pi, math.exp, math.log

local sample_exp_distribution = require ('mathutil').sample_exp_distribution
local avgstd = require ('mathutil').avgstd
local productory = require ('mathutil').productory

local params = {
  N = 100,
  --OM
  Q=0.3,     -- 0 .. 1.0
  lambda=0.1,
  
  runs = 10000, --100000, --max runs 
  totaltime = 6000, --600 max time s
}

local function precomupute_params (params)
  local N, Q, lambda = params.N, params.Q, params.lambda
  params.alfa = lambda --1.4
  params.beta = lambda*(1-Q)--1
  params.R0 = params.alfa/params.beta
  --print ('Q', Q, 'lambda', lambda, 'alfa', params.alfa, 'beta', params.beta, 'R0', params.R0)
end

local function runsimu(params)
  local N, Q, lambda = params.N, params.Q, params.lambda
  local alfa = params.alfa
  local beta = params.beta
  local R0 = params.R0
  local time = os.time
  
  local t = 0
  local S = {}
  local count = {}
  local timein = {}
  local timeto0 = {}

  S[0] = function()
    --print(t, 'Finished')
    --tau1 = tau1 + t
    timeto0[#timeto0+1] = t
  end
  for i = 1, N do
    count[i] = 0
    timein[i] = 0
    local px = i/N
    
    local B = (alfa/N)*i*(1-px)
    local D = (beta/N)*i
       
    S[i] = function ()
      count[i] = count[i] + 1
      
      local w = sample_exp_distribution(B+D)
      timein[i] = timein[i]+w
      t=t+w
      --print(i,w)
      
      if random() < B/(B+D) then
        return S[i+1]() 
      else
        return S[i-1]() 
      end
    end
  end

  local endtime, endruns = os.time()+(params.totaltime or math.huge), params.runs or math.huge
  local cycle = 0
  repeat
    t, cycle = 0, cycle+1
    math.randomseed(cycle)
    S[1]()
  until time()>=endtime or cycle>=endruns
  local runs=cycle

  params.timeto0 = timeto0
  params.timein = timein
  local tau1, tau1std = avgstd(timeto0)
  --print ('tau1', tau1, tau1std)

  return tau1, tau1std, runs
end

local function teorethical(params, tau1)
  --print('Teorethical results')
  
  local N, Q, lambda, R0 = params.N, params.Q, params.lambda, params.R0
  local alfa = params.alfa
  local beta = params.beta

  --Clancy et Tjia 2017
  local sum = 0
  for j=1, N do
    sum = sum + (1/j)*((R0/N)^(j-1))*productory (N-j+1, N)
  end
  local NordenTau = (1/(beta))*sum
  --print ('Norden TauF', NordenTau)
  
--[[
  local sumQ = 0
  for j=1, N do
    sumQ = sumQ + (1/(j*(N^j)*((1-Q)^j)))*productory(N-j+1, N)
  end
  local Etau1Q = (N/lambda)*sumQ
  print ('Norden TauQ', Etau1Q)
--]]

  --Ball F. et al 2015
  local expTau = (N/(beta))*(sqrt(2*PI/N)/(R0-1)) * exp(N*(log(R0)-1+(1/R0)))
  
  return NordenTau, expTau
end

print ('lambda', params.lambda)

print('Starting')
print('Q', 'tau1', 'tau1std', 'runs')

---[[
--for Q=0.1, 0.5, 0.1 do
for Q=0.025, 0.1, 0.025 do
  params.Q = Q
  precomupute_params (params)
  local tau1, tau1std, runs = runsimu(params)

  --local NordenTau, expTau = teorethical(params, tau1)
  print(Q, tau1, tau1std, runs)

  local f=io.open('timeto0_'..tostring(Q)..'.txt', 'w')
  for _, v in ipairs(params.timeto0) do
    f:write(tostring(v)..'\n')
  end
  f:close()
  f=io.open('timein_'..tostring(Q)..'.txt', 'w')
  for i=1, params.N do
    f:write(tostring(i)..' '..tostring(params.timein[i] or 0)/runs ..'\n')
  end
  f:close()
end

--]]

print('')
print('Q', 'NordenTau', 'expTau')

for Q=0, 1, 0.025 do
  params.Q = Q
  precomupute_params (params)
  --local tau1, tau1std, runs = runsimu(params)
  local NordenTau, expTau = teorethical(params, tau1)
  print(Q, --[[tau1, tau1std, runs,--]] NordenTau, expTau)
end

