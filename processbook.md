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
Fucked up, but appearently the AVAudioRecorder can only be used to record the mic... So need to check in to other classes todays. However the AVAudiorecorder can still be used later in the app to record one's voice and have that as audio input. Right now checking in the AKAudioRecorder class inherent to the Audio Kit API im using. Not able to get it working... something with the path to the directory again... Also found out later in the day that the AKAudioRecorder class is depreciated and has been morphed into the AKNodeRecorder class 23 days ago... -__- Soooo, switching to the AKNodeRecorder right know.. It basically uses an AVAudioFile to buffer audio to.

# DAY 2|4
Magically finally got the AKNodeRecorder working. Recording audio real time to a .caf file. Yay! Dont know how the problem got fixed though, Dennis made it happen. THANKS! Right now checking into the Dropbox API to upload audio to a shared folder. Also made a todo list with thing planning on implementing next week. And did move the record function to the masterview, instead of the detailview.
Not sure whether Dropbox is the best thing for uploading files as I want them in a public place (hosted by my account), without users having to log in. Maybe better to check different possibilities before implementing Dropbox. Marijn/Dennis/Julian suggested either Dropbox(filerequest / inlogging in the back.. but not so save maybe), GoogleDrive and iCloud. Checking into these possibilities as we speak.

# DAY 2|5
Alpha version is done! User can play with files, record this and has an "automate" button (special filter effect)

# DAY 3|1
Presentated my code in the Hour of Code. Was in doubt about my use of a Singleton. General view hereon however was positive! Also we talked a bit about databases and the safety of background login in. I decided to use the Dropbox API. Implementing it now.

# DAY 3|2
Got the Dropbox linking working, and even managed to upload my files. Will need to focus tomorrow on implementing an alert screen asking users to change their filename. Also let add the mic recorder function to the screen and let this file be imported as audio input.

# DAY 3|3
Sometimes its better to clear one's mind by finishing up other projects. Had been shifting between writing my thesis and working on this project for the past weeks and was lacking focus. Decided today to focus fully on finihsing up my thesis and not on the programming. i succeeded in finishing this, and hopefully can work more focussed for the remaining of the programming course.

# DAY 3|4
Fixed that dropbox doesn't need a login anymore together with Emma. Also looked on conversion methods in order to change the .caf into a more widely used format. Didn't succed fully however...

# DAY 3|5
beta version submitted, but still some stuff need to be implemented. Working on in the weekend.

# DAY 3|6
Worked on on my beta version, implemented  my mic recording possibilities + letting user fill in trackinfo when uploading

# DAY 3|7
Made sure my micrecording is playable. Needed to convert this to project folder. Also added some coloring, to indidate to the user he is recording/playing audio.

# DAY 4|1
Started implementing loads of alert messages, to inform user if he is trying to do something he isn't allowed to do. Like recording mic and output at the same time, uploading a file when still recording and whether recordings or uploads were (un)successfull. Need to make a proper function for this tomorrow though. Over time I began noticing loads of the alert messages had the same structure! Also looked into converting a .caf file to .wav, but still not succesfull in this. Decided to leave this feature for the time being! Also moved lots of code to other function, so functionality is more clearer ("seperation of concerns"). 

# DAY 4|2
Moves around lots of code to seperate functions (seperation of concerns) to make code more clear and less bulky. Also build in more error checking functions, like for whether upload was succesful, internet connection works etc. Fixed the constraints and layout. Also experienced some glitches in the audio playback.. which is pretty problematic. Hope to solve this tomorrow by testing my app on a different device... Also struggled a bit with closures today.. Didn't yet quit understand the concept behind it, but now I do! Had to move some code around to get the intended code functionality (Moving some functions inside the closer, and some outside, and some in loops).

# DAY 4|3
Again moved around lots of code to seperate functions and cleaned up some unneccessary variables. Also downscaled the alert pop ups to 3 seperate functions. These function differ in whether they have multiple buttons and if textfields are present. Above my masterviewcontroller global variables are initiated which are used to call alert pop ups in the code with specified texts and button names. Having a problem with presentviewcontroller however on the same thread. This means that when I'm dismissing a certain alertview it asks to present the second alert view to fast and this one doesn't show. Also today i shortened most of the audio files, cutting them to files that are less than 15 seconds long. It seems the audio glitches are gone now, but not fully sure.

# DAY 4|4
Went in on the Hour of Code and presented my alert view controller problem from yesterday. We as a group finally managed to solve this by setting a NSNotification post between the two alert views, which made sure the second view was presented after the first view had completed fully. Also today I managed to test my app on a device (this was not possible because my app doesnt run on my own iphone 4...). I tested it on Julian's iphone 6 and it worked smoothly for most of the app. The only thing not working was the microphone button... the app crashes... :(. The problem here lies in the path I specifiy to write the microphone recording file. This problem doesn't occur in the simulator... Its too late now to fix this. Ill make a note in my report hereon.