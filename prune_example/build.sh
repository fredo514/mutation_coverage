ceedling test:all

clang-12 -emit-llvm -g -grecord-command-line -c -fexperimental-new-pass-manager -fpass-plugin=/usr/lib/mull-ir-frontend-12 -Isrc src/module.c -o module.bc

clang-12 -emit-llvm -g -grecord-command-line -c -I/usr/local/bundle/gems/ceedling-0.31.1/vendor/unity/src/ /usr/local/bundle/gems/ceedling-0.31.1/vendor/unity/src/unity.c

clang-12 -emit-llvm -g -grecord-command-line -c -Isrc -I/usr/local/bundle/gems/ceedling-0.31.1/vendor/unity/src/ test/test_module.c

clang-12 -emit-llvm -g -grecord-command-line -c -Isrc -I/usr/local/bundle/gems/ceedling-0.31.1/vendor/unity/src/ build/test/runners/test_module_runner.c

llvm-link-12 module.bc unity.bc test_module.bc test_module_runner.bc -o linked_tests.bc

llc-12 -filetype=obj module.bc
llc-12 -filetype=obj test_module.bc
llc-12 -filetype=obj test_module_runner.bc
llc-12 -filetype=obj unity.bc

clang-12 module.o unity.o test_module.o test_module_runner.o -o linked_tests

mull-runner-12 --reporters=Elements --reporters=Patches --report-name=mutation-report linked_tests