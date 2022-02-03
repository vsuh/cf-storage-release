import requests
import sys

class myEnv():

    def __init__(self, env='.env'):
        self.cf={}
        self.f = env
        self.readenv()

    def readenv(self):
        with (open(self.f, 'rt')) as fh:
            lines = list(fh)
        for ln in lines:
            arr = ln.split("=")
            if len(arr)<2: continue
            if arr[0].strip()[:1]=="#": continue
            self.cf.update({arr[0].strip():arr[1].strip()})

def escape4tg(text: str):
    text = text.replace("_", "\\_")
    text = text.replace('*', '\\*')
    text = text.replace('`', '\\`')
    text = text.replace('{{b', '*')
    text = text.replace('b}}', '*')
    text = text.replace('{{i', '_')
    text = text.replace('i}}', '_')
    text = text.replace('{{c', '```')
    text = text.replace('c}}', '```')

    return text

def tg(text: str):
    Env = myEnv('.env')
    url = Env.cf["url"]
    url += Env.cf["token"]
    method = url + "/sendMessage"
    text = escape4tg(text)
    r = requests.post(method, data={
         "chat_id": Env.cf["channel_id"],
         "text": text.replace('###', '\r\n'),
         "parse_mode": "Markdown"
          })

    if r.status_code != 200:
        raise Exception(f'error [{r.status_code}] {r.reason}')


if len(sys.argv) > 1:
    tg(f'{sys.argv[1]}')
