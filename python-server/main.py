import os
from flask import Flask, render_template
import liblo
from easygoogletranslate import EasyGoogleTranslate
from threading import Lock
from flask_socketio import SocketIO

app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app, async_mode='threading')

class CaptionTextThread():
    def __init__(self):
        self.server = liblo.ServerThread(34353)
        self.translator_es = EasyGoogleTranslate(
            source_language='en',
            target_language='es',
            timeout=10)
        self.translator_ja = EasyGoogleTranslate(
            source_language='en',
            target_language='ja',
            timeout=10)

        self.lock = Lock()
        self.caption = {}
        self.last_translated = None
        self.last_translation_es = ""
        self.last_translation_ja = ""

        self.server.add_method("/livecaption/line/0", None, self.test_handler)
        self.server.add_method("/livecaption/line/1", None, self.test_handler)
    
    def test_handler(self, path, args, types, src):
        global socketio
        if path.startswith("/livecaption/line/"):
            ln = path.split("/")[3]
            if not ln.isnumeric():
                return
            with self.lock:
                ln = int(ln)
                self.caption[ln] = args[0]
                if ln == 1:
                    if(self.last_translated != args[0]):
                        self.last_translated = args[0]
                        self.last_translation_es = self.translator_es.translate(self.last_translated)
                        self.last_translation_ja = self.translator_ja.translate(self.last_translated)
                socketio.emit(
                    'captions', 
                    {
                        "captions": list(self.caption.values()),
                        "tr":{
                            "es": self.last_translation_es,
                            "jp": self.last_translation_ja
                        }
                    })

    def start(self):
        self.server.start()

    def stop(self):
        self.server.stop()

@app.route('/')
def index():
    return render_template('index.html')

@socketio.on('connect')
def test_connect():
    print('Client connected')

if os.environ.get("WERKZEUG_RUN_MAIN") == "true":
    pass
elif __name__ == "__main__":
    server = CaptionTextThread()

    server.start()
    socketio.run(app, debug=True, use_reloader=False, allow_unsafe_werkzeug=True)
    server.stop()