# DEVORM RECORDS presents an user-interactive music release

This app generates music by letting users edit audio files and record this in real time. These audio files are partly fixed by pre-supplied audio in the app, and possibly expanded by recordings of the device's mic. The user is able to upload his final recordings to a shared dropbox, with their unique chosen track title and artist name. Editing audio files can be done by changing a sound's pitch, reverb, filter and volume. The audio files in the app will be a collection of specifically composed pieces of short music by several artists when released. bur currently consists of placeholder audiofiles made by me.

This release will be part of DEVORM records, a cross-disciplinary creative platform I run. This app challenges the way we view an artwork by releasing a piece of music without a fixed final result. Releasing a tool to make music (aesthetically constrained by the label) rather than a piece of music. The specific music of the release depends both on the provided audio files from artists as on the choices made by the user of the app. Hereby this app transforms a music release to a more wider feedbacking tool between artist and consumer (and whether this separation even still can be made).

All the uploaded audio files are collected in a public dropbox, for all to listen to.

# technical design

The app consists of two screens; a Masterviewcontroller displaying all the sounds a user can select and play with. And a Detailviewcontroller where the user is able to manipulate/control the selected sound. For playing, manipulating and recording sounds, the AudioKit API is used. AudioKit (http://audiokit.io) is an audio synthesis, processing, and analysis platform for OS X, iOS, and tvOS which makes use of Apple's Core Audio functionality. For uploading sounds to Dropbox I make use of the Swifty Dropbox API (https://www.dropbox.com/developers/documentation/swift). Below are some screenshots of the app and a overview of the relation between classes, functions and buttons.

![alt-tag](https://github.com/MaartenBrijker/project/blob/back/doc/overview.png)

AudioKit API
- When the app starts all soundfiles are loaded from a list and a path to them is created. Hereafter each of the sounds are connected to a player, filter, reverb, pitcher, and then to a mixer. All of these are stored in a array, so later we are easily able to connect to them and manipulate their settings. Finally the mixer is set as the Audiokit Output.

Audio Manager
- This is a singleton where almost all of the audio processing takes place. I used a singleton in this case as of the need to connect with the audiokit nodes from both the detailview controller and the masterview controller. 

MasterViewController
- As stated, in this class all the audio is displayed in a TableView. Also there are a "record", "upload" and "microphone" button. 
- Here the microphone button initiates a AVAudioRecorder object and writes the audio from the microphone to a file. After this the Tableview and the Audiokit devices are updated.
- When a user presses the "record" button the AudioKit output is recorded until pressed again and stored in the documents directory of the device. Each time the user initiates a recording session a NSTimer will be initiated too and stop the recording when 90% of the free space is taken.
- When the "upload" button is pressed a connection to Dropbox will be made and if no errors occurred, a pop up screen will be shown asking for userinfo. After this the file will be uploaded, en all the functionality will be disabled for the time being. After the upload the user will be informed whether it was successful.

DetailViewController
- Here all the audio setting per sound are set. The specific sound playing is send to this view by a segue. By sliders a user sets levels of filter, reverb, volume and pitch. 
- By pressing the start/stop button the Audio Manager gets signalled it should play/stop the file. Also the background is turned green in order to display that the sound is playing.
- By pressing the spacewave button a NSTimer fires random nodes to the filter to create a extra spacey effect on that sound for a short period of time. The "spacewave" stops by itself.

SwiftyDropbox API
- This is the API of Dropbox which I use to connect to dropbox and upload files. The folder where all the files stored by me and not yet publicly visible. In order to provide a mechanism to push all files to my dropbox instead of a user's own dropbox I made use of the Generated Access Token. This means that I make a Dropboxclient with this token, which is hardcoded in the app, and a user isn't redirected to the Dropbox login screen.

Alert Messages
- In order to signal to the user about errors of a certain status I use three general alert functions. I call these with parameters to show and dismiss them. Alerts are for example about whether there is a internet connection, upload was successful, no multiple recordings are allowed etc.

Below a overview of most of above described the functionality of the app:

![alt-tag](https://github.com/MaartenBrijker/project/blob/back/doc/diagram.png)

# challenges during development & important changes

During the course of this project I encountered a few challenges and important changes. Most of these were because initially my idea was to focus more on the audio manipulating part of the app and less on input and output functions. However during the first week I noticed these audio manipulating functions (all the Audiokit filtering/pitching etc) were not that hard to implement due to the accessability of the AudioKit API. As I intend to release this app as part of my label after the summer, I decided to focus more on the possibly hard, but important for releasing the app as intended, parts and make smart use of the assistance provided in these weeks. I sticked to the 4 sliders functions to edit the audio and started focussing on recording the audio and uploading files to an online storage.

In week 1 most of my apps basics were done and I started focussing on recording the audio. I had to decide whether I would like to record audio in real time, or some sort of automate function (volume/reverb/etc) to write audio to a file more like a sequencer does (or regular audio composing software). For the time-span of the project being I decided to go with the first option. Recording audio real time would be easier to implement. After looking into the AVAudioRecorder class for two days and struggling with its filepath I noticed, when finally implemented, it could only be used for recording over the device's mic.. Although bummed, I could handy use this to let users record their voice as audio input, so I did! At the end of week 2 I managed to implement Audiokit's AKNodeRecorder class. This was hard as this class was only 3 weeks old from their side. It uses an AVAudioFile to buffer audio to. At first, a hard feature to understand, but I feel I understand the basics of this now.

In the Third week I focused more on the "uploading a file" part of the app. After a thorough examination of different storages (Cloudkit, Google, Dropbox, Firebase), I decided to implement the SwiftyDropbox API. This decision was partly focused on the several people struggling with Firebase, Cloudkit being payed, and Google not being used by others in this course. The fact that a few others had implemented Dropbox in their app, which could help me in the process, and that I already use Dropbox for storing and sharing music extensively, made the final decision for me. Implementing Dropbox wasn't that hard, but making sure Dropbox connects to the server without asking the users for log-in info was for a small part. Luckily I managed to fix this issue (with Emma, and Dennis) by creating a Dropbox client from a generated access token, which is hardcoded in the app.

Some other hurdles I encountered were the use of a singleton, making sure recording files would not take up all a device's free space and converting the file formats for uploading.
- I am using a Singleton (the AudioManager.swift) for all the audio processing parts. Although it isn't recommended to do this mostly, I did find it handy to use. Because I need to manipulate the AudioKit nodes from both the Detail- and the Masterviewcontroller it seemed wisely to use a singleton class where all the audio processing takes place.
- As users could record sounds for as long as they like, lots of the free space of the device could be taken. Or even recordings could be shut off when a device is out of free space. To fix this I implemented a function which checks the amount of free bytes on a device and simple formulae converting this to the available time free to record. Using a NSTimer I made sure the record function stops when 90% of the free space is taken (hereby alerting the user of course).
- The app's recording function buffers the audio to a .caf file (Core Audio Format). Disadvantageous to this is that most other applications don't support this format. A audio preview on Dropbox, uploading files to soundcloud or playing them in iTunes is not possible. I would have prefered to convert this to m4a or wav format, but after spending a whole afternoon trying to this I gave up and decided to leave this problem for a summer revision of the app.
- Initially I was planning on implementing a SQLite database to store values of sliders. This was with the goal to automate effects over time and export audio based on these settings. However as I decided to record audio in real time I deleted the SQLite database from my app.
- Unfortunately the app crashes when the microphone recording is used on a device. This is not the case in the simulator and was only discovered on the final day.. I have choosen to leave this functionality in the app, as the grading of the project was based on a simulator run. 



