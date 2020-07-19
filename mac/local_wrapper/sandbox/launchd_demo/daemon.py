from datetime import datetime

def timestamp():
    now = datetime.now()
    return now.strftime("[%H:%M:%S]")


print(timestamp() + " <== There should be a 20 sec interval between 2 lines");