# Overview

The app will exist of three parts:
 - input
 - audio processing
 - output

and two screens (classes):
 - AudioViewController
 - ProcessingViewController

Next to this I will make use of the Audio KIt API and an SQLite Database.
I will now explain all of this more detailed.

# input

The app is able to take input from several sources:
 - web (download music from youtube) Youtube API
 - database (a set of sounds provided by me, stored in the app)
 - record audio (recording audio with the device's mic)

# audio processing

For this part of the app I will use the Audio Kit API. This API makes use of the Core Audio build in to swift, but is more accessable and easier to work with. Audio Kit provides several samplers, effects and sequencers to manipulate audio. Also a graphical tool of Audio Kit will be used.

# output

For the MVP version of my app there will only be audio played back in real time. If there is time left in this coursee, I will focus on implementing an export function. This could be done via a record function or by automating the samples

# UI Vieuws

I will make use of a splitview. Were the main view is a table displaying all the audio sources, and the detailview is filled with several audio processors (sliders, buttons), a visual representation of the audio and a function to select playbacking modes (single sound vs overall sound).

![alt-tag](https://github.com/MaartenBrijker/project/blob/back/doc/sketch.png)

Optionally there will also be another screen where users could control a mixer to control overall volumes and panning of each track.

# AudioViewController

This class will exist of:
 - table view displaying the sound
 - button for adding a sound via mic recording
 - button for adding a youtube sourced audio
 - button for exporting a track
 - when a row is selected in the table, it gets either marked and it sound will be turned on, or demarked and silenced

# ProcessingViewController

This class will exist of:
 - several sliders controlling effects (filter / reverb / pitch)
 - a graphical interface displaying the wave form (Audio Kit has modules for this)
 - a bar like visual representation to automate an effect over the sample time (in order to provide more dynamics)

# SQLite database

SQL will be used to store each sound and its values. Each sound will have a seperate row. And each effect on a seperate column with its value for the specific sound.

![alt-tag](https://github.com/MaartenBrijker/project/blob/back/doc/table%20example.png)

# information
- Maarten Brijker
- 10440682
- iOS app
- programmeerproject