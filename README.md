# DEVORM RECORDS presents an user-interactive music release

This app generates music by letting users edit audio files and record this in real time. These audio files are partly fixed by pre-supplied audio in the app, and possibly expanded by recordings of the device's mic. The user is able to upload his final recordings to a shared dropbox, with their unique choosen tracktitle and artistname. The audiofiles in the app will be a collection of specifically composed pieces of short music by several artists. This release will be part of DEVORM records, a cross-disciplinairy creative platform runned by me. 

# How does it work

The app will exist of four parts:
 - input
 - audio processing
 - output
 - uploading

I will now explain each part of the app more detailed.

# input

The app is able to take input from several sources:
 - database (a set of sounds provided by several artists, stored in the app'a project folder)
 - record audio through the device's microphone

# audio processing

For this part of the app I will use the Audio Kit API. This API makes use of the Core Audio build in to swift, but is more accessable and easier to work with. Audio Kit provides several samplers, effects and sequencers to manipulate audio. 

# output

The sound of the app is outputted via the AudioKit mixer node and can be recorded by this same API. The user simply presses the record button and start recording until he/she presses this same button again.

# uploading

The user can upload his recorded musical piece to a shared Dropbox. For this the Swifty Dropbox API is used. An user can state a prefered tracktitle and artistname for his file to upload.

# multiple screens

I will make use of a splitview. Were the main view is a table displaying all the audio sources, and the detailview is filled with several audio processors (sliders, buttons), a visual representation of the splitview is shown below:

![alt-tag](https://github.com/MaartenBrijker/project/blob/back/doc/overview.png)

# sound reference

Ideally the sonic aesthetics users are able to generate with this app would be in line of this song: https://www.youtube.com/watch?v=ZMTT1Pnfuzw

# MVP (minimal viable product)

My old MVP was an audioprocessing app using a offline sound database (provided by me) and only outputting audio in real time playback (not exporting any audio to files). However as stated in the report, this shifted towards focussing on recording and exporting audio too.

# technical limitations

I did mostly foresee technical limitations in the audio input and output parts. However that's why I did choose to limit my MVP and focus foremostly on the audio processing part. Technical limitations in those parts include obtaining audio from an online source and writing audio to a file and storing that online. I did succeed however in this latter part. 
With respect to the time and my personal skill level I don't foresee myself hardcoding processing functions. So in the audio processing part of the app technical limitations would be based on the audio processing functions provided by the Audio Kit API. I did had to be creative to use these processing tools in a way that approaches the functions and aesthetics I have in mind and that will be satisfactionary to the user of the app.

# what does this app add to the world of apps?

There are several music generating and processing applications around (Multitrack, Garageband, Figure, to name a few). However non of them is aesthetically limited by a record label and does provide the direct possibility of being part of a collective group of artists without having any necessary musical skills.

This app will enable music fans that are not capable of composing music from scratch, to still have a music based output and being part of a music label.

# external sources

 - Swifty Dropbox API
 - AudioKit API
 - A stackoverflow function for checking a device's free space: http://stackoverflow.com/questions/5712527/how-to-detect-total-available-free-disk-space-on-the-iphone-ipad-device

# possible crashes

Unfortenately the app crashes when the microphone recording is used on a device. This is not the case in the simulator and was only discovered on the final day.. I have choosen to leave this functionality in the app, as the grading of the project was based on a simulator run.

# licence/copyright

This app's copyright notice states that all rights are owned by me (Maarten Brijker) and this app can only be used by explicit permission from me.

# information
 - Maarten Brijker
 - 10440682
 - iOS app
 - programmeerproject