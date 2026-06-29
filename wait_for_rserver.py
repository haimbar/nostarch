"""Wait until the talk2stat R server is ready to accept commands."""
import time
import sys
from talk2stat.talk2stat import client

for _ in range(120):
    if client('./', 'R', '``` ```'):
        print('R server ready')
        sys.exit(0)
    time.sleep(1)

sys.exit('ERROR: R server did not become ready within 120 seconds')