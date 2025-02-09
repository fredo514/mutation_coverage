# mutation_coverage
environment for assessment of test completeness

## Installing Dependencies
Run Docker container described in Dockerfile
* Ruby
* Ceedling
* LLVM
* Mull
* KLEE

## Gettings used to Mull
### Level 1: Running Mull
Go to the `hello-world` folder.
> cd hello-world

Compile `main.c` with the Mull LLVM frontend.
> clang-18 -fpass-plugin=/usr/lib/mull-ir-frontend-18 -g -grecord-command-line main.c -o hello-world

Run Mull on the resulting executable.
> mull-runner-18 -ide-reporter-show-killed hello-world

### Level 2: Running Mull on a unity test harness
Go to the `mull-unity_example` folder.
> cd mull-unity_example

Run Ceedling to generate the test runner.
> ceedling test:all

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
> clang-18 build/mull/module.o build/mull/unity.o build/mull/test_module.o build/mull/test_module_runner.o -o build/mull/linked_tests

Run Mull on the resulting executable.
> mull-runner-18 -ide-reporter-show-killed build/mull/linked_tests

### Level 3: Pruning equivalent mutants using KLEE
Go to the `prune_example` folder.
> cd prune_example

Run Ceedling to generate the test runner.
> ceedling test:all

Compile the module under test (`module.c`) to bitcode with the Mull LLVM frontend and convert it to ana object file.
```
clang-12 -emit-llvm -g -grecord-command-line -fexperimental-new-pass-manager -fpass-plugin=/usr/lib/mull-ir-frontend-12 -Isrc src/module.c -c -o module.bc

llc-12 -filetype=obj module.bc
```

Compile the rest of the harness files (`unity.c`, `test_module.c` and `test_module_runner.c`) to object files.
```
clang-12 -I/usr/local/bundle/gems/ceedling-0.31.1/vendor/unity/src/ /usr/local/bundle/gems/ceedling-0.31.1/vendor/unity/src/unity.c -c

clang-12 -Isrc -I/usr/local/bundle/gems/ceedling-0.31.1/vendor/unity/src/ test/test_module.c -c

clang-12 --Isrc -I/usr/local/bundle/gems/ceedling-0.31.1/vendor/unity/src/ build/test/runners/test_module_runner.c -c
```

Link all the object files into an executable.
> clang-12 module.o unity.o test_module.o test_module_runner.o -o linked_tests

For convenience, the previous steps have been grouped into `build.sh` bash script.

Run Mull with the provided configuration file.
> mull-runner-12 --reporters=Elements --reporters=Patches --report-name=mutation-report linked_tests

Run the pruning script on the mull report.
> python ../detect_equivalent_mutant.py --mull-report mutation-report.json --output equivalent_mutants.json
