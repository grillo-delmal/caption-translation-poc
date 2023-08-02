import liblo
from easygoogletranslate import EasyGoogleTranslate

server = liblo.Server(34353)
translator_es = EasyGoogleTranslate(
    source_language='en',
    target_language='es',
    timeout=10)
translator_ja = EasyGoogleTranslate(
    source_language='en',
    target_language='ja',
    timeout=10)
last_translated = None
last_translation_es = ""
last_translation_ja = ""

def test_handler(path, args, types, src):
    global last_translated, last_translation_es, last_translation_ja
    print(path, args, types)
    if(path == "/livecaption/line/1"):
        if(last_translated != args[0]):
            last_translated = args[0]
            last_translation_es = translator_es.translate(last_translated)
            last_translation_ja = translator_ja.translate(last_translated)
        print(last_translation_es)
        print(last_translation_ja)
    
server.add_method("/livecaption/line/0", None, test_handler)
server.add_method("/livecaption/line/1", None, test_handler)

while True:
    server.recv(100)
