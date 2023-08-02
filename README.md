# POC: Translated captions

## WHAT?!?!

I was thinking on looking for a solution to add live captions to my stream, 
and after discovering that there is an app that can do that, I started to 
design a proof of concept to extract the information from the app and translate
it in the process

## HOW!!?!??!

I used the following projects:
* LiveCaptions ... had to patch a couple of things
    * expose the translated strings
    * remove dependencies to the configuration schema.
        * I did this because yes.
* Dependencies of LiveCaptions (onnx and the model)
* tinyosc: to implement osc comms in LiveCaptions, ISC Licensed
* pyliblo: To receive the data from LiveCaptions
* EasyGoogleTranslate: to translate the things

To run it, run `deploy.sh`, then `run.sh` and finally run `osc_test.py` in parallel
This is ment to run in Fedora 38... cos it's what I use.

## WHY?!?!

To learn how this works, and maybe to motivate myself to actually do a propper software
to solve my problem.

Also, by looking at it's issue tracker, it doesn't seem that the LiveCaptions project is interested in this kind
of functionalities.... I might be wrong though xD