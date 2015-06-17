/*
Processing code for the Automatic Jump Shot Camera
Modified from Face Detection example from the OpenCV Processing & Java library
2013
*/


import gab.opencv.*;
import processing.video.*;
//import java.awt.*;
import java.awt.Rectangle;

import ddf.minim.*;

Minim minim;
AudioPlayer player;

Capture video;
OpenCV opencv;

int contrast_value    = 0;
int brightness_value  = 0;
int trigger;
int triggerOld = 0;
int wide =  640;    //change wide & high variables to match resolution of your web camera
int high = 480;
int yThreshold = 60;
int yMark = yThreshold+25;
String directions = "JUMP TO GET YOUR HEAD IN THE BOX";

void setup() {
  size( wide, high );

  opencv = new OpenCV(this, wide, high);
  video = new Capture(this, wide, high);
  opencv.loadCascade( OpenCV.CASCADE_FRONTALFACE );  

  minim = new Minim(this);
  player = minim.loadFile("shutter.mp3");

  video.start();
  println( "Drag mouse on X-axis inside this sketch window to change contrast" );
  println( "Drag mouse on Y-axis inside this sketch window to change brightness" );
}

void draw() {
  opencv.loadImage(video);
  image(video, 0, 0 );

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();

  if (faces.length>0) {
    if (faces[0].width<70) {  
      stroke(255, 10, 10);
      strokeWeight(4);
      rect(0, 0, wide, yMark);
      textSize(35);
      text(directions, 10, 550);
      fill(255, 10, 10);
      trigger = faces[0].y;
      println(triggerOld - trigger);    
      if (trigger < yThreshold && triggerOld - trigger > 5) {
        takePhoto();
      }
      triggerOld = trigger;
    }
  }
}

void captureEvent(Capture c) {
  c.read();
}

void mouseDragged() {
  contrast_value   = (int) map( mouseX, 0, width, -128, 128 );
  brightness_value = (int) map( mouseY, 0, width, -128, 128 );
}

void takePhoto() {
  image(video, 0, 0 );
  saveFrame("test####.jpg");      //saves each photo under a different name, located in the sketch folder
  player.play();                  //makes shutter sound because why not?
  background(255);
  delay(100);
}

