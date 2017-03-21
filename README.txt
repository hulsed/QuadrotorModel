This program will optimize the performance of a quadrotor with respect to a few different compenents (motors, propellers, and support rods) 

In order to optimize this performance, run GA_Experiment.m, which will run a genetic algorithm over all of the choices available for the parameters. The output x should represent the best choices of the design found, with performance f.

Dependencies:
* Current MATLAB installation
* QProp.exe in the model directory

Some model assumptions (more in the code):
* cylindrical support rods of various materials
* nominal performance 
* hover, climb performance, and cost are all that is needed
* all continous variables are discretized over ranges