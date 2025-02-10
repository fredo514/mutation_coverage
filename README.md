# mutation_coverage
Environment for assessment of test completeness.

Even with a lot of skills and good will, it is easy to forget test cases to completely verify a program's function. Code coverage is not useful in this case, as it doesn't assess whether test cases actually check the program's behavior, only that all the lines are executed.

This is where mutation testing comes in. This technique generates variats of the original program with a multitude of logical changes (e.g. swapping a `+` for a `-`), and report whether the program still functions. When coupled with a test harness, this can become an automated way to tell you if your test cases are imcomplete.

## Installing Dependencies
Run Docker container described in Dockerfile. This installs:
* Ruby
* Ceedling
* LLVM
* Mull

## Gettings used to Mull
### Level 1: Running Mull
In this example, you will use Mull to generate mutants and inspect the results.

Go to the `hello-world` folder.
```
cd hello-world
```

Compile `main.c` with the Mull LLVM frontend.
```
clang-18 -fpass-plugin=/usr/lib/mull-ir-frontend-18 -g -grecord-command-line main.c -o hello-world
```

Run Mull on the resulting executable.
```
mull-runner-18 -ide-reporter-show-killed hello-world
```

This prints whether the generated mutants survived (ran successfully) or where killed (exited with an error). 

### Level 2: Running Mull on a Ceedling test harness
In the context of a test harness, mutants surviving or being killed translates to whether they passed all tests or not. In this example, you will use Mull to generate mutants of a module's source, link it to its Ceedling test harness, and then inspect the results.

Go to the `mull-unity_example` folder.
```
cd mull-unity_example
```

Run Ceedling to generate the test runner.
```
ceedling test:all
```

Compile the module under test (`module.c`) to bitcode with the Mull LLVM frontend and convert it to ana object file.
```
mkdir build/mull

clang-18 -emit-llvm -g -grecord-command-line -c -fpass-plugin=/usr/lib/mull-ir-frontend-18 -Isrc src/module.c -o build/mull/module.bc

llc-18 -filetype=obj build/mull/module.bc
```

Compile the rest of the harness files (`unity.c`, `test_module.c` and `test_module_runner.c`) to object files.
```
clang-18 -Ibuild/vendor/unity/src/ build/vendor/unity/src/unity.c -c -o build/mull/unity.o

clang-18 -Isrc -Ibuild/vendor/unity/src/ test/test_module.c -c -o build/mull/test_module.o

clang-18 -Isrc -Ibuild/vendor/unity/src/ build/test/runners/test_module_runner.c -c -o build/mull/test_module_runner.o
```

Link all the object files into an executable.
```
clang-18 build/mull/module.o build/mull/unity.o build/mull/test_module.o build/mull/test_module_runner.o -o build/mull/linked_tests
```

Run Mull on the resulting executable.
```
mull-runner-18 -ide-reporter-show-killed build/mull/linked_tests
```

If the result is that a mutant survived, this means you're missing test coverage.

### Level 3: Determining if surviving mutants are true positives
The example above is basically complete, but requires a lot of manual steps. On top of that, some surviving mutants might be equivalent to the original program, giving false positives which require manual analysis. In this example, we will automate the equivalency checking of the surviving mutants using a very simple comparison of the resulting optimized LLVM Intermediate Representation (IR).

Go to the `optimized_ir_diff` folder.
```
cd optimized_ir_diff
```

Run Ceedling to generate the test runner.
```
ceedling test:all
```

Compile the module under test (`module.c`) to bitcode with the Mull LLVM frontend and convert it to an object file.
```
clang-18 -emit-llvm -g -grecord-command-line -fpass-plugin=/usr/lib/mull-ir-frontend-18 -Isrc src/module.c -c -o module.bc

llc-18 -filetype=obj module.bc
```

Compile the rest of the harness files (`unity.c`, `test_module.c` and `test_module_runner.c`) to object files.
```
clang-18 -Ibuild/vendor/unity/src/ build/vendor/unity/src/unity.c -c

clang-18 -Isrc -Ibuild/vendor/unity/src/ test/test_module.c -c

clang-18 -Isrc -Ibuild/vendor/unity/src/ build/test/runners/test_module_runner.c -c
```

Link all the object files into an executable.
```
clang-18 module.o unity.o test_module.o test_module_runner.o -o linked_tests
```

Run Mull with the provided configuration file.
```
mull-runner-18 --reporters=Elements --report-name=mutation-report linked_tests
```

For convenience, the previous steps have been grouped into `build.sh` bash script.

Run the pruning script on the mull report.
```
python analyze_mutant.py build/mull/mutation-report.json
```

This will print whether the tool found differences between the original source and each surviving mutant's optimized IR.

### Level 4: Increasing accuracy
Comparing optimized IR like in the previous example is fast an simple, but can sometimes give false positives. The comparison accuracy can be improved using custom LLVM passes and Clang AST analysis.

### Level 5: Wrapping everything together
Make it a CI pipeline.