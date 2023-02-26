import pyflowchart as pf
import re
import os
from svglib.svglib import svg2rlg
from reportlab.graphics import renderPDF
from PyPDF2 import PdfMerger

def parse_label(row: str, node_type):
    name = row.split(':')[0].lstrip().rstrip()
    node = node_type(name)
    return node

def parse_proc(proc: str):
    nodes = []
    rows = proc.split('\n')
    for index, row in enumerate(rows):
        if index == 0:
            nodes.append([parse_label(row, pf.OperationNode), 'StartNode'])
        elif re.match(pattern=r'.*jmp.*', string=row):
            nodes.append([parse_label(row, pf.ConditionNode), 'Jump'])
        elif re.match(pattern=r'.*j.*', string=row):
            nodes.append([parse_label(row, pf.ConditionNode), 'ConditionalJump'])
        elif re.match(pattern=r'..*:', string=row):
            nodes.append([parse_label(row, pf.OperationNode), 'Label'])
        elif re.match(pattern=r'.*call.*', string=row):
            nodes.append([parse_label(row, pf.SubroutineNode), 'Call'])
        elif re.match(pattern=r',*\sret\s.*', string=row):
            nodes.append([parse_label(row, pf.OperationNode), 'Return'])
        else:
            nodes.append([parse_label(row, pf.OperationNode), 'Instruction'])

    cond_jumps = [x for x in nodes if x[1] == 'ConditionalJump']
    jumps = [x for x in nodes if x[1] == 'Jump']
    for i, node in enumerate(nodes):
        if i == 0:
            nodes[0][0].connect(nodes[1][0])
            continue
        root_nodes = []
        prev_node = nodes[i-1]
        if prev_node[1] == 'ConditionalJump':
            root_nodes.append([prev_node, prev_node[0].connect_no])
        for cj in cond_jumps:
            label = cj[0].node_text.split(' ')[1].lstrip().rstrip()
            if label == node[0].node_text:
                root_nodes.append([cj, cj[0].connect_yes])
        for j in jumps:
            label = j[0].node_text.split(' ')[1].lstrip().rstrip()
            if label == node[0].node_text:
                root_nodes.append([j, j[0].connect_no])
        if prev_node[1] != 'Jump' and prev_node[1] != 'ConditionalJump':
            root_nodes.append([prev_node, prev_node[0].connect])
        root_nodes.sort(key=lambda x: nodes.index(x[0]), reverse=True)
        for rt in root_nodes:
            rt[1](node[0])
    fc = pf.Flowchart(nodes[0][0])
    with open(f'{nodes[0][0].node_text}.flowchart', 'w') as file:
        file.write(fc.flowchart())
    name = nodes[0][0].node_text
    os.system(f'diagrams flowchart {name}.flowchart {name}.svg')
    drawing = svg2rlg(f"{name}.svg")
    renderPDF.drawToFile(drawing, f"{name}.pdf")



def parse_asm(lab: str, subs=''):
    report_path = '../' + lab + '/report.pdf'
    if subs == '':
        text = open('../' + lab + '/' + lab + '/' + 'lab.asm', 'r').read()
    else:
        text = open('../' + lab + '/' + subs + '/'+ subs + '/' + 'lab.asm', 'r').read()
    procedures = re.split(pattern=r";<+\n;<+", string=text)[1:]
    for i, proc in enumerate(procedures):
        rows = proc.split('\n')
        rows = list(filter(lambda x: not re.match(r'^\s*$', x), rows))
        rows = list(filter(lambda x: not re.match(r'.*;.*', x), rows))
        procedures[i] = '\n'.join(rows)
    proc_nodes = []
    for proc in procedures:
        proc_nodes.append(parse_proc(proc))
    diagrams = next(os.walk('.'), (None, None, []))[2]
    diagrams = list(filter(lambda x: x.endswith('.pdf'), diagrams))
    os.system(f'cp {report_path} report.pdf')
    diagrams.insert(0, 'report.pdf')
    pdf_merger = PdfMerger()
    for file in diagrams:
        pdf_merger.append(file)
    pdf_merger.write('finalReport.pdf')
    os.system(f'mv finalReport.pdf ../{lab}')
    os.system('rm *.pdf')
    os.system('rm *.flowchart')
    os.system('rm *.svg')

def main():
    parse_asm('lab4', 'lab4First')


if __name__ == '__main__':
    main()
