# STILL NEED TO IMPLEMENT THIS STUFF + NOTES TO SELF

def:
 - mute other sounds when user is recording?
 - set image in cells
 - make sure user isn't allowed to press too much on space button

optional:
 - let main table get titles from audiofiles instead of hardcoded
 - pitch —> only allowed to shift int steps
 - pitch —> graphically showing this
 - fix a launch screen
 - update audio files
 - add two other implement buttons


def (less urgent):
 - implement automate button better (+ think of a better name)
 - set effect back to pre-automate value after its done
 - check views on different devices
 - MAKE SURE RECORDINGS STAY UNDER 150 MB>>>!??
 - delete recording from phone after it has been uploaded.
 - update DESIGN.doc + README.md
 - delete "EDIT" button
 - move upload function to audiomanager
 - make sure user fills in correct info when uploading!!!!!
 - move error message to seperate function
 - make file header / class header / comments
 - make reference to dropbox for stealing their code

optionally optional:
 - get a developer account for releasing the app?
 - convert files to m4a ????
 - NSNotification center?

# LAST WEEK
 - fix comments
 - fix error messages (internet/upload/recording successful (file storage??))
 - DROPBOX CHECK ON DIFFERENT DEVICE
 - fix references
 - update README + DESIGN
 - fix layout (constraints etc)
 - move dropbox code to audiomanager ?????
 - move hardcoded strings to seperate variables !!!! !!!!
 - check app on device
 - check whether audio works smoothly when app gets bigger


# thrash

//        let path = NSFileManager
//            .defaultManager()
//            .URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//            .first?
//            .URLByAppendingPathComponent("sound.caf")
//            .path
//        OUTPUTrecorder = AKNodeRecorder(path!)


If you listen carefully iOS very “helpfully” routes the audio to the earpiece (e.g. where you listen when you’re on a call).
I had the same problem and you can now get around this with:
AKSettings.defaultToSpeaker  = true
This will force the audio out of the main speaker. 

