# VimodPub and CordovaPhoneGap used to make hybrid Bible apps

VimodPub scripting used with Cordova/PhoneGap cli to make hybrid Bible apps, sourced from Paratext USX files. Simplehtmlscr is the name of the process.
Added by Ian McQuay almost 2 years ago

This project sprang up from being unable to process an already published USFM project through another program that generates HTML output. It turns out that there were out of order verses. Bibles for years have been print published with out of order verses. One of the problems of Digital publishing is that many apps require the verses to be in order and no verse 1a and 1b. This rigidity takes no account of what is good translation. The question remains, why is digital publishing different. Many processes are data centric, which usually also means verse centric. While USFM appears verse centric it is not fully verse centric. USX an XML representation of USFM is clearly not verse centric but is document centric.

Simplehtmlscr is used to generate the HTML in the same efficient form as Prophero and Haiola. It has a simple menu bar with no wording only a next and previous arrow and a menu icon. This app builder allows any order of verses. It does require that each book does have one \id line and one \h line.

So far this has been used to generate over 20 Bible language apps. It is just a simple reader with no search.

The Simplehtmlscr process is just two XSLT transformation.
Combine all the USX files into one file, orders them, and adds grouping within the files for chapters and introduction matter.
Output a file for each chapter in HTML, as well as book chapter indexes and book index and any other pages.
Once the parameters are entered into the VimodPub script,
Cordova/PhoneGap is used to generate a project
Simplehtmlscr is used to generate the HTML within the project
An Android output is setup
A debug version is created for checking
Modifications are made to the Cordova files to add icon and other changes.
The final signed output is generated

You need Java JDK 1.7. and the Android ADT installed on your computer. The ADT is quite large.

A demo project was found in the Files secion (Palaso.org)[http://projects.palaso.org/projects/vimod-pub/files] but this is now obsolete as of 2016-05-13.
Since 2016-05-13 Hosted on https://github.com/SILAsiaPub/vimod-pub