ceedling test:all

mkdir build/mull

clang-18 -emit-llvm -g -grecord-command-line -c -fpass-plugin=/usr/lib/mull-ir-frontend-18 -Isrc src/module.c -o build/mull/module.bc

llc-18 -filetype=obj build/mull/module.bc

clang-18 -Ibuild/vendor/unity/src/ build/vendor/unity/src/unity.c -c -o build/mull/unity.o
clang-18 -Isrc -Ibuild/vendor/unity/src/ test/test_module.c -c -o build/mull/test_module.o
clang-18 -Isrc -Ibuild/vendor/unity/src/ build/test/runners/test_module_runner.c -c -o build/mull/test_module_runner.o

clang-18 build/mull/module.o build/mull/unity.o build/mull/test_module.o build/mull/test_module_runner.o -o build/mull/linked_tests

mull-runner-18 --reporters=Elements --reporters=Patches --report-name=mutation-report build/mull/linked_tests
