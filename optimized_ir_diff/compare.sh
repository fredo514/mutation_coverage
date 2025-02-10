mkdir -p build/mull

# clang-18 -emit-llvm -g -grecord-command-line -c -Isrc src/module.c -o build/mull/module.bc

# llvm-link-18 build/mull/module.bc build/mull/unity.bc build/mull/test_module.bc build/mull/test_module_runner.bc -o build/mull/linked_tests.bc

# clang-18 -emit-llvm -g -grecord-command-line -c -Isrc build/mull/patched_module.c -o build/mull/patched_module.bc

# llvm-link-18 build/mull/patched_module.bc build/mull/unity.bc build/mull/test_module.bc build/mull/test_module_runner.bc -o build/mull/linked_patched_tests.bc

# klee build/mull/linked_tests.bc

# klee build/mull/linked_patched_tests.bc

clang-18 -emit-llvm -c -g -O0 -Xclang -disable-O0-optnone -Isrc src/module.c -o build/mull/module.bc
clang-18 -emit-llvm -c -g -O0 -Xclang -disable-O0-optnone -Isrc patched_module.c -o build/mull/mutant.bc

opt-18 -O3 build/mull/module.bc -o build/mull/module_opt.bc
opt-18 -O3 build/mull/mutant.bc -o build/mull/mutant_opt.bc

llvm-dis-18 build/mull/module_opt.bc -o build/mull/module_opt.ll
llvm-dis-18 build/mull/mutant.bc -o build/mull/mutant_opt.ll

diff build/mull/module_opt.ll build/mull/mutant_opt.ll 
# diff build/mull/module_opt.ll build/mull/module_opt.ll 
