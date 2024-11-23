# mutation_coverage
environment for assessment of test completeness

```
# level 1
cd hello-world
clang-12 -fexperimental-new-pass-manager -fpass-plugin=/usr/lib/mull-ir-frontend-12 -g -grecord-command-line main.c -o hello-world
mull-runner-12 -ide-reporter-show-killed hello-world

# level 2
cd example

clang-12 -emit-llvm -fexperimental-new-pass-manager -fpass-plugin=/usr/lib/mull-ir-frontend-12 -g -grecord-command-line -Isrc src/module.c -c -o module.bc

clang-12 -emit-llvm -I/usr/local/bundle/gems/ceedling-0.31.1/vendor/unity/src/ /usr/local/bundle/gems/ceedling-0.31.1/vendor/unity/src/unity.c -c -o unity.bc

clang-12 -emit-llvm -Isrc -I/usr/local/bundle/gems/ceedling-0.31.1/vendor/unity/src/ test/test_module.c -c -o test_module.bc

clang-12 -emit-llvm -Isrc -I/usr/local/bundle/gems/ceedling-0.31.1/vendor/unity/src/ build/test/runners/test_module_runner.c -c -o test_module_runner.bc

llc-12 -filetype=obj module.bc
llc-12 -filetype=obj unity.bc
llc-12 -filetype=obj test_module.bc
llc-12 -filetype=obj test_module_runner.bc

clang-12 module.o unity.o test_module.o test_module_runner.o -o linked_tests

mull-runner-12 -ide-reporter-show-killed linked_tests
```