# Random Waypoint Epidemic Network Simulator
 
 This repository contains source code for simulating and modeling an Epidemic network algorithm running over a network with Random Waypoint mobility model.

The files are [Lua](https://www.lua.org/) scripts. Language versions 5.1-5.3 are supported, and also [LuaJIT](http://luajit.org/).

The files are:

* `markov_norden.lua` Computes the times to absorption of a Stochastic Logistic process.
* `rw_epidemic.lua` Simulates mobile network.
* `lib_epidemic.lua` Implements an Epidemic networking algorithm. It's used as a library by the `rw_epidemic.lua` simulator.
* `lib_rw.lua` Implements a Random Waypoint mobility model. It's used as a library by the `rw_epidemic.lua` simulator.

To execute, edit the configuration parameters in the scripts and run `lua markov_norden.lua` or `lua rw_epidemic.lua`. Some results are written to the standard output, so you might want to redirect it to a file.

---

This work is licensed under MIT license. See COPYRIGHT

---
Jorge Visca - jvisca@fing.edu.uy

Facultad de Ingeniería - Universidad de la República - Uruguay

