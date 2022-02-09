# Test Case Generator for AI Semantics
This test case generator can produce models in the form of Prolog queries, as well as TensorFlow Python scripts.
It's a simple Eclipse Java project that was developed on Ubuntu.

# Prerequisites
To run the generator, it is necessary have tha AI framework semantics and also [SWI Prolog](https://www.swi-prolog.org) (we used version 8.2.1).
Moreover, Python (version 3.8.5) and TensorFlow (version 2.4) are needed, and of course also Java (version 13).

# Configuration
In the config file app.config, several parameters need to be set.
1. the Python command and/or path
2. a path to a temporary Python file where the test models are temporarily stored and executed
3.  the Prolog command
4. the path to the source folder of the Prolog semantics

Optionally, also the number of tests or the test mode can be specified.
# Getting Started
To start, we would recommend to use Eclipse (or other Java Editors) to open the project to build it from source.
The tests can simply be executed by running the main file without arguments.
Per default 10 graph models will be generated and executed both with the Prolog semantics and as a TensorFlow Python script.
