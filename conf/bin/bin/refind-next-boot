#!/usr/bin/env python3
import subprocess
import sys

EFIVAR_NAME = 'PreviousBoot'
EFIVAR_GUID = '36d08fa7-cf0b-42f5-8f14-68df73ed3740'
EFIVAR_PREFIX = '/sys/firmware/efi/efivars'

PREFIX = b'\x07\x00\x00\x00'
SUFFIX = b'\x20\x00\x00\x00'

if len(sys.argv) != 2:
    print('error: must pass exactly one argument', file=sys.stderr)
    sys.exit(1)

text = sys.argv[1]
filename = '{}/{}-{}'.format(EFIVAR_PREFIX, EFIVAR_NAME, EFIVAR_GUID)

retcode = subprocess.call(['chattr', '-i', filename])
if retcode != 0:
    sys.exit(42 + retcode)

with open(filename, 'wb') as f:
    content = PREFIX + bytes(text, 'utf-16-le') + SUFFIX
    f.write(content)
