# About
This project was designed for bachelor thesis and consists in the implementation of a hardware architecture in VHDL for the execution of Sparse Convolutional Neural Networks based on a Finite State Machine. The project involved the creation of 4 fundamental entities: the Control Unit (to implement the FSM), the Data Path (for the generation of the addresses, for the increments of the indexes and for the convolution itself), the memory of the images and the memory of the weights. A top module was created to integrate the 4 entities and the test bench was created to carry out the simulations. During the simulations, the waveforms were closely monitored to ensure that the data and control signals were correct (indexes and convolution) and consistent with the hardware architecture specifications.

## FSM
<p align="center">
  <img width="500" height="350" src="https://github.com/svtmontagna/Architecture-for-Execution-of-SCNN-in-VHDL/blob/main/Images/fsm.png?raw=true">
</p>
The proposed state diagram shows the sequence of operations and the transitions between states that occur during the execution of a convolution operation on a computational system. Specifically, the presented diagram is composed of 7 states, each of which represents a specific phase of the convolution process.

## Architecture of the accelerator
Once the behavior was described through the diagram, I implemented the finite state machine and all the necessary entities using VHDL.
The realization of the system was carried out through the implementation of three crucial memories: the memory of the input images, the memory of the output images after the convolution and the memory of the weights. These memories have been integrated with the Data Path and Control Unit to ensure efficient data flow and precise control of the image processing process

## Test benches and simulations
At the end, the simulations of the test benches that were written to verify the correct functioning of the system were carried out. I verified that the convolution indices were incremented correctly and monitored the changing states of the component and their respective waveforms. The simulation results show that the component is performing as expected and that the test benches were effective in verifying that the component was functioning correctly.
<p align="center">
  <img width="800" height="450" src="https://github.com/svtmontagna/Architecture-for-Execution-of-SCNN-in-VHDL/blob/main/Images/writeInit.png?raw=true">
</p>
