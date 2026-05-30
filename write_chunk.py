import os
def write_chunk(f, labelname, start="label===", end="===end", dir="generated"):
    pathname = os.path.splitext(f)[0]
    fn = pathname.split('/')[-1]
    #dn = os.path.dirname(f)
    #fn = os.path.basename(f)
    with open(f, 'r') as file:
        code = file.read().splitlines()
        print_chunk = False
        found_label = False
        for i in range(len(code)):
            if start in code[i]:
                label = code[i].split(start, maxsplit=2)
                if label[1] == labelname:
#                ofn = open(f'{dir}/{fn}.{label[1]}.txt', 'w')
                    ofn = open(f'{dir}/{fn}-{label[1]}.txt', 'w')
                    print_chunk = True
                    found_label = True
                    continue
            if end in code[i]:
                print_chunk = False
                if found_label:
                    ofn.close()
                continue
            if print_chunk == True:
                ofn.write(code[i]+'\n')

import os
  
directory = '/Users/Programs/Directory/program1.csv'
pathname, extension = os.path.splitext(directory)

filename = pathname.split('/')
 
print(filename[-1])