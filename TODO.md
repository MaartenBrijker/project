# STILL NEED TO IMPLEMENT THIS STUFF + NOTES TO SELF

 - alert box —> ask user if he want to upload file, let him fill in info?
 - how to store user info? change audiofile name to --> USERNAME_TRACKTITLE_(USERMAIL).caf
 - pitch —> only allowed to shift int steps
 - pitch —> graphical showing this
 - let maintable get titles from audiofiles instead of hardcoded
 - store pre-automate value and set to post-automate
 - implement micrecording button, let users play with this recording
 - implement automate button better (+ think of a better name)

 - how to share files? Dropbox (filerequest / inlog in the back), GoogleDrive, iCloud







# thrash

//        let path = NSFileManager
//            .defaultManager()
//            .URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//            .first?
//            .URLByAppendingPathComponent("sound.caf")
//            .path
//        OUTPUTrecorder = AKNodeRecorder(path!)

# DROPBOX

App key     5of5rtye3cyoib0
App secret  5xfnne8h3rrj8uj

https://www.dropbox.com/developers-v1/core/sdks/ios

# CLOUDKIT

"In development, when you run your app through Xcode on iOS Simulator or an iOS device, you also need to enter iCloud credentials to read records in the public database."