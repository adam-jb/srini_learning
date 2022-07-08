


# argparse is for calling script from cli
import argparse


"""
parser = argparse.ArgumentParser(description='Process some integers.')

# calling argument '--clock_increase' from cli 
parser.add_argument('--clock_increase', dest='clock_increase')
args = parser.parse_args()
print(args)

# handle the error
try:
    clock_increase = float(args.clock_increase)
except:
    raise ValueError('clock_increase only accepts numeric input')
print(clock_increase)

"""

def clock(i):
    
    print(type(i))
    
    return i + 1

assert clock(2) == 3

#assert clock(4) == 3


def big_ben(i):
    
    print(type(i))
    
    return i + 1




"""
print('clock increase to value:')
print(clock(clock_increase))
"""

