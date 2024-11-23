ceedling test:all

clang-12 -emit-llvm -fexperimental-new-pass-manager -fpass-plugin=/usr/lib/mull-ir-frontend-12 -g -grecord-command-line -Isrc src/module.c -c -o module.bc

llc-12 -filetype=obj module.bc

clang-12 -I/usr/local/bundle/gems/ceedling-0.31.1/vendor/unity/src/ /usr/local/bundle/gems/ceedling-0.31.1/vendor/unity/src/unity.c -c

clang-12 -Isrc -I/usr/local/bundle/gems/ceedling-0.31.1/vendor/unity/src/ test/test_module.c -c

clang-12 -Isrc -I/usr/local/bundle/gems/ceedling-0.31.1/vendor/unity/src/ build/test/runners/test_module_runner.c -c

clang-12 module.o unity.o test_module.o test_module_runner.o -o linked_tests