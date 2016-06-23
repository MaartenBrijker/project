# STILL NEED TO IMPLEMENT THIS STUFF + NOTES TO SELF

def:
 - test on devices (TODAY!!!!!!!)
 - make file header / class header / comments
 - make a scheme of all classes and functions for doc.
 - update DESIGN.doc + README.md
 - make reference to dropbox for their code
 - set device constraints (iphone 5+)
 - stop audio when users is recording mic

optional:
 - let main table get titles from audiofiles instead of hardcoded
 - pitch —> only allowed to shift int steps
 - pitch —> graphically showing this
 - fix a launch screen
 - add two other implement buttons
 - delete recording from phone after it has been uploaded.

optionally optional:
 - get a developer account for releasing the app?
 - convert files to m4a ????
 


# thrash

If you listen carefully iOS very “helpfully” routes the audio to the earpiece (e.g. where you listen when you’re on a call).
I had the same problem and you can now get around this with:
AKSettings.defaultToSpeaker  = true
This will force the audio out of the main speaker. 

