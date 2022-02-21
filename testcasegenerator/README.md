# ExAISTestGenerator: Test Case Generator for ExAIS (Executable AI Semantics)
This test case generator can produce models in the form of Prolog queries, as well as TensorFlow Python scripts.
It's a simple Eclipse Java project that was developed on Ubuntu.

# Prerequisites
To run the generator, it is necessary to have the ExAIS AI framework semantics and also [SWI Prolog](https://www.swi-prolog.org) (we used version 8.2.1).
Moreover, Python (version 3.8.5) and TensorFlow (version 2.4) are needed, and of course also Java (version 13).
Note that we used an Eclipse Maven plugin to automatically get some dependencies, and graphs are produced with Tensorflow and graphviz dot (pip install pydot).

# Configuration
In the config file app.config, several parameters need to be set.
1. the Python command and/or path
2. a path to a temporary Python file where the test models are temporarily stored and executed
3  the Prolog command
4. the path to the source folder of the Prolog semantics
5. the number of tests or the test mode can be specified
6. an optional path to save plots (produced with graphviz dot)
7. an optional path to save the generated or loaded test cases both as TensorFlow code and as Prolog model


# Getting Started
To start, we would recommend to use Eclipse (or other Java editors), or Maven to build the project from source.
The tests can simply be executed by running the main file without arguments.
Per default the generator will produce AI models with various layers and execute them both with the Prolog semantics and as a TensorFlow Python script.
Additionally, existing JSON models can be loaded and executed as test case, or a precondition check can be performed with the loaded models to identify invalid or problematic components. The JSON model format that is supported by this tool is based on a standard that was introduced by [Socrates](https://github.com/longph1989/Socrates/).
