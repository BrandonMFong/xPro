#!//usr/bin/python3
"""
_uuid.py
======================
Helps create build hash for build process
"""

import hashlib
import random 

print(hashlib.sha256(str(random.getrandbits(256)).encode('utf-8')).hexdigest()[0:40])
