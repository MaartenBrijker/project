# STILL NEED TO IMPLEMENT THIS STUFF + NOTES TO SELF

def:
 - let main table get titles from audiofiles instead of hardcoded
 - mute other sounds when users is recording?
 - set image in cells

optional:
 - pitch —> only allowed to shift int steps
 - pitch —> graphically showing this
 - fix a launch screen
 - update audio files

def (less urgent):
 - implement automate button better (+ think of a better name)
 - set effect back to pre-automate value after its done
 - check views on different devices
 - MAKE SURE RECORDINGS STAY UNDER 150 MB>>>!??
 - delete recording from phone after it has been uploaded.
 - update DESIGN.doc + README.md
 - delete "EDIT" button
 - automate function knob for every button
 - make screen red when recording!
 - move upload function to audiomanager
 - make sure user fills in correct info when uploading!!!!!
 - move error message to seperate function

optionally optional:
 - get a developer account for releasing the app?
 - convert files to m4a ????
 - NSNotification center?


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

