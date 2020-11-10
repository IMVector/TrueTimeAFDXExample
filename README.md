# TrueTimeAFDXExample
a example of truetime simulation for AFDX

# How to install truetime 
https://www.cnblogs.com/oneflyleader/p/12079189.html

# How to install complier 
https://www.mathworks.com/matlabcentral/fileexchange/52848-matlab-support-for-mingw-w64-c-c-compiler

# known compile problem
https://blog.csdn.net/zfqy2222/article/details/98971506



# truetime introduction

*Simulation of Networked and Embedded Control Systems*
TrueTime is a Matlab/Simulink-based simulator for real-time control systems. TrueTime facilitates co-simulation of controller task execution in real-time kernels, network transmissions, and continuous plant dynamics. Features of the simulator include

Simulation of complex controller timing due to code execution, task scheduling, and wired/wireless network communication.
Possibility to write tasks as M-files or C++ functions. It is also possible to call Simulink block diagrams from within the code functions
Network block (Ethernet, CAN, TDMA, FDMA, Round Robin, Switched Ethernet, FlexRay and PROFINET)
Wireless network block (802.11b WLAN and 802.15.4 ZigBee)
Battery-powered devices, Dynamic Voltage Scaling, and local clocks
News
 2016-04-06  TrueTime 2.0 has been released. Precompiled MEX files for 64-bit Matlab under 64-bit Windows, Mac OS X, and Linux are included.
Software
TrueTime is Matlab-based and requires Matlab R2012a with Simulink 7.9 (R2012a) or later. Control System Toolbox is required to run some of the examples. TrueTime has been tested under Windows, and Mac OS X, and Linux, but may run on other platforms as well. Please note:

The current release includes precompiled files for 64-bit Matlab under 64-bit Windows, Mac OS X, and Linux. Compilation details:

The Windows version was compiled using Microsoft Windows SDK 7.1 (C++) in Matlab 2014a (64-bit) under Windows 7 Professional.
The Mac OS X version was compiled using XCode 7.3 in Matlab 2016a (64-bit) under OS X El Capitan.
The Linux version was compiled using gcc 4.8.3 in Matlab 2012a (64-bit) under Fedora release 20 (Heisenbug).
If you are unable load/run the examples using the precompiled files, then you need to recompile all the C++ MEX files. For this, you need to have a Matlab-supported and compatible C++ compiler installed. See https://se.mathworks.com/support/compilers.html

Download link: TrueTime-2.0.zip
(15 MB zip archive including precompiled files for 64-bit Matlab under Windows, Mac OS X, and Linux)
README
HISTORY
LICENCE
Documentation
Anton Cervin, Dan Henriksson, Martin Ohlin: "TrueTime 2.0 – Reference Manual". Department of Automatic Control, Lund University, Sweden, April 2016.

Main TrueTime Publication
If you write a paper and want to make a reference to TrueTime, please cite the following publication:

Anton Cervin, Dan Henriksson, Bo Lincoln, Johan Eker, Karl-Erik Årzén: "How Does Control Timing Affect Performance? Analysis and Simulation of Timing Using Jitterbug and TrueTime." IEEE Control Systems Magazine, 23:3, pp. 16–30, June 2003.
