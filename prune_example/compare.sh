clang-12 -emit-llvm -g -grecord-command-line -c -Isrc src/module.c -o module.bc

llvm-link-12 module.bc unity.bc test_module.bc test_module_runner.bc -o linked_tests.bc

clang-12 -emit-llvm -g -grecord-command-line -c -Isrc patched_module.c -o patched_module.bc

llvm-link-12 patched_module.bc unity.bc test_module.bc test_module_runner.bc -o linked_patched_tests.bc

klee linked_tests.bc

klee linked_patched_tests.bc