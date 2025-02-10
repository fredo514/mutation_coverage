import subprocess
import json
import os
import filecmp

output_dir = "build/mull"

# for each surviving mutant
with open(output_dir + '/mutation-report.json', 'r') as file:
    mutation_report = json.load(file)

equivalent_mutants = []
    
for file in mutation_report['files']:
    print('Analyzing surviving mutants of {}'.format(file))
    
    # create bytecode of original file
    cmd = f"clang-18 -emit-llvm -c -g -O0 -Xclang -disable-O0-optnone -Isrc {file} -o {output_dir}/module.bc"
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    # optimize bytecode
    cmd = f"opt-18 -O3 {output_dir}/module.bc -o {output_dir}/module_opt.bc"
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True) 
    # create IR
    cmd = f"llvm-dis-18 {output_dir}/module_opt.bc -o {output_dir}/module_opt.ll"
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)

    with open(file, 'r') as f:
        orig_lines = f.readlines()
    
    # Find surviving mutants
    surviving_mutants = []
    for mutant in mutation_report['files'][file]['mutants']:
        if mutant['status'] == 'Survived':
            surviving_mutants.append(mutant)

    count = 0
    for idx, mutant in enumerate(surviving_mutants):
        print('   Analyzing mutation {} at line {}, column {}'.format(mutant['id'], mutant['location']['start']['line'], mutant['location']['start']['column']))
        
        os.makedirs(os.path.dirname(f"{output_dir}/mutants/"), exist_ok=True)

        # create patched mutant file
        mutant_file = orig_lines
        change_line = mutant['location']['start']['line'] - 1
        change_start_col = mutant['location']['start']['column'] - 1
        change_end_col = mutant['location']['end']['column'] - 1
        mutant_file[change_line] = mutant['replacement'].join([mutant_file[change_line][:change_start_col], mutant_file[change_line][change_end_col:]])

        with open(f"{output_dir}/mutants/mutant_{idx}.c", 'w') as f:
            f.writelines(mutant_file)
        
        # create mutant bytecode
        cmd = f"clang-18 -emit-llvm -c -g -O0 -Xclang -disable-O0-optnone -Isrc {f"{output_dir}/mutants/mutant_{idx}.c"} -o {f"{output_dir}/mutants/mutant_{idx}.bc"}"
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        # optimize bytecode
        cmd = f"opt-18 -O3 {f"{output_dir}/mutants/mutant_{idx}.bc"} -o {f"{output_dir}/mutants/mutant_{idx}_opt.bc"}"
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        # create IR
        cmd = f"llvm-dis-18 {output_dir}/mutants/mutant_{idx}_opt.bc -o {output_dir}/mutants/mutant_{idx}_opt.ll"
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)

        if filecmp.cmp(f"{output_dir}/module_opt.ll", f"{output_dir}/mutants/mutant_{idx}_opt.ll"):
            print("      Mutant is equivalent!")
        else:
            print("      Mutant is not equvalent!")
