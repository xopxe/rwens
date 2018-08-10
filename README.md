# Random Waypoint Epidemic Network Simulator
 
 This repository contains source code for simulating and modeling Epidemic network algoithm running over a network with Random Waypoint mobility model.

The files a [Lua](https://www.lua.org/) scripts. Language versions 5.1-5.3 are supported, and also [LuaJIT](http://luajit.org/).

The files are:

* `markov_norden.lua` Computes the times to absorption of a Stochastic Logistic process.
* `rw_epidemic.lua` Simulates mobile network.
* `lib_epidemic.lua` Implements an Epidemic networking algorithm. It's used as a library by the `rw_epidemic.lua` simulator.
* `lib_rw` Implements a Random Waypoint mobility model. It's used as a library by the `rw_epidemic.lua` simulator.


---

 Jorge Visca
 jvisca@fing.edu.uy

 Facultad de ngenieríía - Universidad de la República - Uruguay