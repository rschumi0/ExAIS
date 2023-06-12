# ExAIS (Executable AI Semantics) Test Case Generator and Semantic-based Neural Network Repair Tool
This test case generator can produce models in the form of Prolog queries, as well as TensorFlow Python scripts.
The repair component of the tool can repair invalid AI models that suffer from structural problems, wrongly used layers or wrongly connected layers.
It works with an executable semantics called [ExAIS](https://github.com/rschumi0/ExAIS) and supports JSON models in a format that is based on the [SOCRATES](https://github.com/longph1989/Socrates) platform.
The tool a simple Eclipse Java project that was developed on Ubuntu.

# Prerequisites
To run the tool, it is necessary to have the ExAIS AI framework semantics and also [SWI Prolog](https://www.swi-prolog.org) (we used version 8.2.1).
Moreover, Python (version 3.8.5) and TensorFlow (version 2.4) are needed to produce TensorFlow test models, and of Java (version 13).
Note that we used an Eclipse Maven plugin to automatically get some dependencies, and graphs are produced with Tensorflow and graphviz dot (pip install pydot).

# Configuration
In the config file app.config, several parameters need to be set.
* the Python command and/or path
* a path to a temporary Python file where the test models are temporarily stored and executed
* the Prolog command and/or path
* the path to the source folder of the Prolog semantics
* the number of tests or the test mode can be specified
* an operation mode (testMode) to specify what the tool should do (generate/nodeterministic/semanticruntime/gui/parse/repair/repairtime/generaterandrepair)
* optional path to save plots (produced with graphviz dot)
* optional output path to save the generated or loaded test cases both as TensorFlow code and as Prolog model 
* optional dot command from Graphviz to produce plots
* socratesMode to specify if a model from the SOCRATES tool should be repaired
* path to a JSON model that should be repaired

# Getting Started
To start, we would recommend to use Eclipse (or other Java editors), or Maven to build the project from source.
The tests can simply be executed by running the main file without arguments.
Per default the generator will produce AI models with various layers and execute them both with the Prolog semantics and as a TensorFlow Python script.
Additionally, existing JSON models can be loaded and executed as test case, or a precondition check can be performed with the loaded models to identify invalid or problematic components. The JSON model format that is supported by this tool is based on a standard that was introduced by [Socrates](https://github.com/longph1989/Socrates/).

# Repair
Per default the repair tool will repair a given model from the path specified in the app.config file.
Additionally, the test mode can in the app.config be adjusted to run an repair time evaluation or to generate and repair random test AI models that can, e.g., used for AI framework testing or for an accuracy evaluation.

# Experiment, Data, Results, and Replication
The folder ../tests contains experiment data for our test model generation and AI model validation approach. (There are 10000 generated test models, 100 model validation tests and runtime tests for different models.)
The folder ../repair_tests contains our models and repairs for our experiments. 
(It contains, the 1000 random models that we used to evaluate the effectiveness of our method, our test models for the repair time evaluation, and the real buggy models and benchmark models and the associated fixes)






