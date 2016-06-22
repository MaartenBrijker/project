# STILL NEED TO IMPLEMENT THIS STUFF + NOTES TO SELF

def:
 - mute other sounds when user is MICrecording?
 - set image in cells
 - make sure user doesn't use invalid (like "/") characters when uploading!
 - data handling (convert to MB, let recorder only record for pre specified time)
 - put alert messages in function
- fix mechanism for "free space is finished.." #stopper
 - test on devices (TODAY!!!!!!!)


optional:
 - let main table get titles from audiofiles instead of hardcoded
 - pitch —> only allowed to shift int steps
 - pitch —> graphically showing this
 - fix a launch screen
 - update audio files
 - add two other implement buttons


def (less urgent):
 - check views on different devices
 - MAKE SURE RECORDINGS STAY UNDER 150 MB>>>!??
 - delete recording from phone after it has been uploaded.
 - update DESIGN.doc + README.md
 - move upload function to audiomanager?
 - make sure user fills in correct info when uploading!!!!!
 - move error message to seperate function
 - make file header / class header / comments
 - make reference to dropbox for their code

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

