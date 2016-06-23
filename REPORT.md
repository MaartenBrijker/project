# DEVORM RECORDS presents an user-interactive music release

This app generates music by letting users edit audio files and record this in real time. These audio files are partly fixed by a pre-supplied audio in the app, and possibly expanded by recordings of the device's mic. The user is able to upload his final recordings to a shared dropbox, with their unique choosen tracktitle and artistname. Editing audio files can be done by changing a sound's pitch, reverb, filter and volume. The audiofiles in the app will be a collection of specifically composed pieces of short music by several artists.

This release will be part of DEVORM records, a cross-disciplinairy creative platform run by me. This app challenges the way we view an artwork by releasing a piece of music without a fixed final result. Releasing a tool to make music (esthetically constrained by the label) rather than a piece of music. The specific music of the release depends both on the provided audiofiles from artists as on the choices made by the user of the app. Hereby this app transforms a music release to a more wider feedbacking tool between artist and consumer (and whether this seperation even still can be made).

All the uploaded audio files are collected in a public dropbox, for all to enjoy.

# technical design

The app consists of two screens; a Masterviewcontroller displaying all the sounds a user can select and play with. And a Detailviewcontroller where the user is able to manipulate/controll the selected sound. For playing, manipulating and recording sounds, the AudioKit API is used. AudioKit (http://audiokit.io) is an audio synthesis, processing, and analysis platform for OS X, iOS, and tvOS which makes use of Apple's Core Audio functionality. For uploading sounds to Dropbox I make use of the Swifty Dropbox API (https://www.dropbox.com/developers/documentation/swift). Below are some screenshots of the app and a overview of the relation between functions and buttons.

![alt-tag](https://github.com/MaartenBrijker/project/blob/back/doc/overview.png)
![alt-tag](https://github.com/MaartenBrijker/project/blob/back/doc/diagram.pdf)

AudioKit API
- When the app starts all soundfiles are loaded from a list and a path to them is created. Hereafter each of the sounds are connected to a player, filter, reverb, pitcher, and then to a mixer. All of these are stored in a array, so later we are able to connect to them and manipulate their settings. Finally the mixer is set as the Audiokit Output.

Audio Manager
 - This is a singleton where almost all of the audio processing takes place. I used a singleton in this case as of the need to connect with the audiokit nodes from both the detailview controller and the masterview controller. 

MasterViewController
 - As stated, in this class all the audio is displayed in a TableView. Also there are a "record", "upload" and "microphone" button. 
 - Here the microphone button initiates a AVAudioRecorder object and writes this to a file. After this the Tableview and the Audiokit devices are updated.
 - When a user presses the "record" button the AudioKit output is recorded until pressed again and stored in the documents directory of the device. Each time the user initiates a recording session a NSTimer will be initiated too and stop the recording when 90% of the free space is taken.
 - When the "upload" button is pressed a connection to Dropbox will be made and if no errors occured, a Pop Up will be shown asking for userinfo. After this the file will be uploaded, en all the functionality will be disabled for the time being. After the upload the user will be informed whether it was successful.

DetailViewController

SwiftyDropbox API

Alert Messages

# challenges during development &  important changes (PROCESS.md)

# Defend decisions