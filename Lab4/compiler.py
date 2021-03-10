r_file = open("program2.txt", "r") 
w_file = open("machine2.txt", "w")

def dec_to_bin(n, opcode):
    n = int(n)
    s = ''
    while n > 0:
        s = str(n % 2) + s
        n = (n // 2)
    if opcode == '0':
        while len(s) < 4:
            s = '0' + s
    else:
        while len(s) < 5:
            s = '0' + s
    return s

operation = {'mv': "0000", 'as': "0001", 'add': '0010', 'sub': '0011', 'b': '0100', 'blt': '0101', 
        'beq': '0110', 'lw': '0111', 'sw': '1000', 'xor': '1001', 'and': '1010', 'xall': '1011', 'lut': '1100', 
        'sll': '1101', 'stop': '1111', 'li': '000', 'gbi': '001', 'sb0': '010', 'sb1': '011', 'addi':'100', 
        'subi': '101', 'luti': '110'}


for line in r_file:
    l = line.split()

    instruction = l[0]
    opcode = '1' if len(operation[instruction]) == 3 else '0'
    val = l[1][1:] if (l[1][0] == 'r') else l[1]
    w_file.write(opcode + operation[instruction] + dec_to_bin(val, opcode) + '\n')

w_file.write("111111111") # always end with Ack instruction

r_file.close()
w_file.close()
