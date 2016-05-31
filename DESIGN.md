# How does it work

The app will exist of three parts:
 - input
 - audio processing
 - output

Most of the focus in these four weeks will be on the audio processing part. The input and output parts will have some amount of implementation levels that could possibly be skipped during these four weeks and left for further work.

I will now explain each part of the app more detailed.

# input

The app is able to take input from several sources:
 - web (download music from youtube or soundcloud for example)
 - database (a set of sounds provided by me, stored in the app)
 - record audio (recording audio with the device's mic)

I will start building the app with only the database source of audio. I have done this before (the API assignment last block), and that will be an easy start for focussing on the most important part of the app, namely the audio processing

# audio processing

For this part of the app I will use the Audio Unit API. This API makes use of the Core Audio build in to swift, but is more accessable and easier to work with. Audio Unit provides several samplers, effects and sequencers to manipulate audio. Also it has some graphical tools I am planning on using. 

# output

In the most narrowed down version of my app, sound will only be 'outputted' in terms of playing the audio real time. So when the user kills the app, the audio will be gone. However, in a more extended version of this app I would like the audio to be exported as a single audio file, so the music can be stored and shared by the user. The AVAssetExportSession function of iOS would be able to do this. Even more fancy would be if the user could have the audio send to him via mail (with a cc to me, so DEVORM could display all the generated audio in some online environment) or streamed on Soundcloud. 
However I don't expect to be able to get to this part in this four weeks course. So all of this is optional and I will work foremostly with just playing back the audio real time.

# multiple screens

I will make use of a splitview. Were the main view is a table displaying all the audio sources, and the detailview is filled with several audio processors (sliders, buttons), a visual representation of the audio and a function to select playbacking modes (single sound vs overall sound)

![alt-tag](https://github.com/MaartenBrijker/project/blob/master/doc/sketch.png)

Ideally there will also be another screen where users could control a mixer to control overall volumes and panning of each track.

# information
Maarten Brijker
10440682
iOS app
programmeerproject