def toDec(hexstr,BIT):
    msb4bits = hexstr[0]
    n = int(msb4bits, 16)
    if n >= 8:
        p = -1*pow(2,BIT-1)
        addend = int(str(n-8) + hexstr[1:], 16)
        return str( p + addend)
    else:
        return str(int(hexstr, 16))

NEGATE = {'1': '0', '0': '1'}
def negate(value):
    return ''.join(NEGATE[x] for x in value)

def twocomplement(n, size_in_bits):
    # print(n)
    number = int(n)
    if number < 0:
        return negate(bin(abs(number) - 1)[2:]).rjust(size_in_bits, '1')
    else:
        return bin(number)[2:].rjust(size_in_bits, '0')

def int2hex(num,bit_width):
    if num<0:
        num = (1 << bit_width) + num
    hex_string = hex(num)[2:]
    return '{:0>{width}}'.format(hex_string,width = (bit_width+3)//4)

def reverse_str(bits):
    return str(bits)[::-1]

def bin2hex(bin):
   return hex(int(bin,2))

# built in function to convert integer to binary
def int2bin(num,bit_width):
    return '{:0>{width}}'.format(bin(num)[2:],width = bit_width)