# STILL NEED TO IMPLEMENT THIS STUFF + NOTES TO SELF

def:
 - test on devices (TODAY!!!!!!!)
 - replace audiofiles with smaller files... could fix the audio fuck ups
 - make file header / class header / comments
 - make a scheme of all classes and functions for doc.
 - update DESIGN.doc + README.md
 - make reference to dropbox for their code
 - fix splitview layout
 - set device constraints (iphone 5+)
 - uploadFile function (seperation of concerns)
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
 
# LAST WEEK
 - fix comments
 - fix error messages (internet/upload/recording successful (file storage??))
 - DROPBOX CHECK ON DIFFERENT DEVICE
 - fix references
 - update README + DESIGN
 - fix layout (constraints etc)
 - move hardcoded strings to seperate variables !!!! !!!!
 - check whether audio works smoothly when app gets bigger . . . problem . . .


# thrash

If you listen carefully iOS very “helpfully” routes the audio to the earpiece (e.g. where you listen when you’re on a call).
I had the same problem and you can now get around this with:
AKSettings.defaultToSpeaker  = true
This will force the audio out of the main speaker. 

