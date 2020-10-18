# FacePoll
[![MIT License](https://img.shields.io/apm/l/atomic-design-ui.svg?)](https://github.com/Lucas-ZX-W/Identity-Crisis/blob/master/LICENSEs)

## Inspiration
Don't you just love when professor asks a question in zoom meeting? 

Camera's not on, mic's muted, you thought, "I'm good then". 

But is this really helping **you**? When confused by the meeting materials, most students are concerned whether their questions are important enough to ask, especially in front of a large group. To recreate the atmosphere in which the meeting presenter has a better, instant understandings of the attendee's feelings, we introduce the smart meeting analyzing feedback tool FacePoll.

## What it does
FacePoll is designed for bringing both the audiences and lecturers the pre-COVID lecturing experience with synchronous, model-trained precision feedbacks. 

As for the speakers, they will no longer have to taste the blandness of lecturing into one microphone. When using along a conference or a lecture, FacePoll will collect data from attendees' facial expressions, convert them into emojis, and display the aggregated expression that represents the overall feeling, so that the speaker can register the real-time feedback and make adjustments according to it. As for the audiences, they will have a chance to get a real sense of connection with the speaker. By simply turning on their webcam for Identity Crisis, anyone could make their reactions matter. 

## How we built it
To ensure a smooth workflow, we have carefully documented our ideas in this [doc](https://docs.google.com/document/d/1mu_al9Q-ttP6gq0LOzZq24rw9ugc5nFMrsUY3_avuQU/edit#). Our ML model was both implemented with OpenCV and Apple's CoreML, seeking to engage in more platforms and provide usages for a wider audience. Once the expression results are gathered, they are instant converted to an emoji most accurately describe their feelings based on our expression value scales, then the emojis are stored in our Firebase databases. After this step, the app retrieves the emojis and display them in proportional widths in a floating window for the meeting presenter(s). Of course, attendees have the choice at any time to opt out of the process of gathering their expressions, and their identity is encrypted with randomly generated meeting ID, which entry gets automatically removed when leaving the meeting.

## Challenges we ran into
Backend wise, we ran into incompatibility between firebase pods and MacOS. 
Our ML people had to compile the frameworks much longer than they expected using local machines. 

## Accomplishments that we're proud of
Successfully compiled all the frameworks needed.
Reached higher accuracy in prediction results for recognizing facial expressions than originally expected.
Created clear and well-designed UI for an integrated user experience.
Set up a working backend database for storing and retrieving data.
Encrypted identifier for to protect individual student’s privacy and share their instant feedbacks of class materials without having any pressure.

## What we learned
We have definitely learned to think in our users' perspectives. For FacePoll, we have two client types: the presenter(s) and the attendee(s), how our project serves each client's purposes are different, and then comes different mechanisms of implementing and revising our designs.

## What's next for FacePoll
We look forward to implement the following features:
Use customized Memoji
Draw in air with finger/mouse
Serve page over local network & draw there
Virtual characters
Change hair colors/styles
