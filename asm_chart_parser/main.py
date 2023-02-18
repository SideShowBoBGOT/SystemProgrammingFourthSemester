import pyflowchart as pf
import re

def parse_asm(path: str):
    text = open(path, 'r').read()
    procedures = re.split(pattern=r";<+\n;<+", string=text)
    for i, proc in enumerate(procedures):
        rows = proc.split('\n')
        rows = list(filter(lambda x: not re.match(r'^\s*$', x), rows))
        rows = list(filter(lambda x: not re.match(r'^;.*', x), rows))
        procedures[i] = '\n'.join(rows)
        print(procedures[i])
    with open('test.txt', 'w') as file:
        file.write('.\n'.join(procedures))




def main():
    parse_asm('../lab3/lab3/lab.asm')


if __name__ == '__main__':
    main()
