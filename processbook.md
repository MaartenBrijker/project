# PROCESSBOOK

# DAY 1|1
Wrote my proposal, a user-interactive music release :D

# DAY 1|2
Basis setup for my DESIGN.md. Mostly focussed on a sketch for the viewcontroller. Splitview design. Checked out the API im currently planning on using, AUDIO KIT. Nice features!

# DAY 1|3
Finished my DESIGN.md, still not sure whether I should be using SQLite to store my data. W'll see.

# DAY 1|4
Started building my app! Initiated a basic splitview, made audio files to start working with. Integrated the Audio Kit API, simple effects working now. Struggling a bit to find the best way to store each sound with its corresponding player and other AKnodes 

# DAY 1|5
Finished my prototype. Storing all my sounds and players in a list right know. Works perfect.

# DAY 2|1
Made sure sliders now jump back to initial settings when switching between sounds. Thinking of dropping the SQLite database... as I dont need to store settings anymore when app is killed. Still not really sure if I should focus on exporting audio via a record function (recording the audio real time and buffering it to a file), or making it possible for the user to automate all functions over time, and then export this to a file... hmmmmmmm. Also I fooled around with NSTIME. Now have a knob that controls sliders if you hit. Generating random values and using NSTime to have little pauses between changes (to enhance the sonic experience).

# DAY 2|2
OK, definetely decided to focus on the "exporting a live recording" functionality. Checking into AVAudioRecorder rn to do this. Really struggling with setting up the AVAudioRecorder, the path to the documentsdirectory doesn't seem right... Finally got it working (needed cast something down to a string... -_-)

# DAY 2|3
Fucked up, but appearently the AVAudioRecorder can only be used to record the mic... So need to check in to other classes todays. However the AVAudiorecorder can still be used later in the app to record ones voice and have that as audio input. Right now checking in the AKAudioRecorder class inherent to the Audio Kit API im using. Not able to get it working... something with the path to the directory again... Also found out later in the day that the AKAudioRecorder class is depreciated and has been morphed into the AKNodeRecorder class 23 days ago... -__- Soooo, switching to the AKNodeRecorder rn.. It basically uses an AVAudioFile to buffer audio to.

# DAY 2|4
Magically finally got the AKNodeRecorder working. Recording audio real time to a .caf file. Yaaayyyayyayyayya. Dont know how the problem got fixed though, Dennis made it happen. THANKS! Right now checking into the Dropbox API to upload audio to a shared folder. Also made a todo list with thing planning on implementing next week. And did move the record function to the masterview, instead of the detailview.
Not sure whether Dropbox is the best thing for uploading files as I want them in a public place (hosted by my account), without users having to log in. Maybe better to check different possibilities before implementing Dropbox. Marijn/Dennis/Julian suggested either Dropbox(filerequest / inlogging in the back.. but not so save maybe), GoogleDrive and iCloud. Checking into these possibilities as we speak.

# DAY 2|5
Alpha version is done! User can play with files, record this and has an "automate" button (special filter effect)

# DAY 3|1
Presentated my code in the Hour of Code. Was in doubt about my use of a Singleton. General view hereon however was positive! Also we talked a bit about databases and the safety of background login in. I decided to use the Dropbox API. Implementing it now.

# DAY 3|2
# DAY 3|3
# DAY 3|4
# DAY 3|5
# DAY 4|1
# DAY 4|2
# DAY 4|3
# DAY 4|4
# DAY 4|5
