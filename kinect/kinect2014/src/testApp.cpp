#include "testApp.h"
Boolean flag = true;
int yPos = 100;

Boolean ball1 = true;
Boolean ball2 = true;
Boolean ball3 = true;
Boolean ball4 = true;
Boolean ball5 = true;

//--------------------------------------------------------------
void testApp::setup() {
    
    ofSetLogLevel(OF_LOG_VERBOSE);

    openNIDevice.setup();
    openNIDevice.addImageGenerator();
    openNIDevice.addDepthGenerator();
    openNIDevice.setRegister(true);
    openNIDevice.setMirror(true);
    
    // setup the hand generator
    openNIDevice.addHandsGenerator();
    
    // add all focus gestures (ie., wave, click, raise arm)
    openNIDevice.addAllHandFocusGestures();
    
    // or you can add them one at a time
    //vector<string> gestureNames = openNIDevice.getAvailableGestures(); // you can use this to get a list of gestures
                                                                         // prints to console and/or you can use the returned vector
    //openNIDevice.addHandFocusGesture("Wave");
    
    openNIDevice.setMaxNumHands(4);
    
    openNIDevice.start();
    
    
    
    verdana.loadFont(ofToDataPath("verdana.ttf"), 24);
}

//--------------------------------------------------------------
void testApp::update(){
    openNIDevice.update();
}

//--------------------------------------------------------------
void testApp::draw(){
    
    if(yPos == 100){
        flag = true;
    }else if(yPos == 400){
        flag = false;
    }
    
    if(flag){
        yPos++;
    }else if(flag == false){
        yPos--;
    }

    
	ofSetColor(255, 255, 255);
    
    ofPushMatrix();
    // draw debug (ie., image, depth, skeleton)
    openNIDevice.drawDebug();
    ofPopMatrix();
    
    
    // draw background
    ofPushMatrix();
    ofSetColor(255, 0, 0);
    if(ball1){
        ofCircle(100, yPos, 20);
    }else{
        ofRect(100, yPos, 40, 40);
    }
    
    if(ball2){
        ofCircle(200, yPos, 20);
    }else{
        ofRect(200,yPos,40,40);
    }
    
    if(ball3){
        ofCircle(300, yPos, 20);
    }else{
        ofRect(300, yPos, 40, 40);
    }
    
    if(ball4){
        ofCircle(400, yPos, 20);
    }else{
        ofRect(400, yPos, 40, 40);
    }
    
    if(ball5){
        ofCircle(500, yPos, 20);
    }else{
        ofRect(500, yPos, 40, 40);
    }
    ofPopMatrix();
    
    
    ofPushMatrix();
    // get number of current hands
    int numHands = openNIDevice.getNumTrackedHands();
    
    // iterate through users
    for (int i = 0; i < numHands; i++){
        
        // get a reference to this user
        ofxOpenNIHand & hand = openNIDevice.getTrackedHand(i);
        
        // get hand position
        ofPoint & handPosition = hand.getPosition();
        // do something with the positions like:
        
        // draw a rect at the position (don't confuse this with the debug draw which shows circles!!)
        ofSetColor(255,0,0);
        ofRect(handPosition.x, handPosition.y, 10, 10);
        
        if(handPosition.x < 100 && 100<handPosition.x+10 && handPosition.y < yPos < yPos < handPosition.y+10){
            if(ball1){
                ball1 = false;
            }else{
                ball1 = true;
            }
        }
        
        if(handPosition.x < 200 && 200<handPosition.x+10 && handPosition.y < yPos < yPos < handPosition.y+10){
            if(ball2){
                ball2 = false;
            }else{
                ball2 = true;
            }
        }
        
        if(handPosition.x < 300 && 300<handPosition.x+10 && handPosition.y < yPos < yPos < handPosition.y+10){
            if(ball3){
                ball3 = false;
            }else{
                ball3 = true;
            }
        }
        
        if(handPosition.x < 400 && 400<handPosition.x+10 && handPosition.y < yPos < yPos < handPosition.y+10){
            if(ball4){
                ball4 = false;
            }else{
                ball4 = true;
            }
        }
        
        if(handPosition.x < 500 && 500<handPosition.x+10 && handPosition.y < yPos < yPos < handPosition.y+10){
            if(ball5){
                ball5 = false;
            }else{
                ball5 = true;
            }
        }
        
    }
    ofPopMatrix();
    
    // draw some info regarding frame counts etc
	ofSetColor(0, 255, 0);
	string msg = " MILLIS: " + ofToString(ofGetElapsedTimeMillis()) + " FPS: " + ofToString(ofGetFrameRate()) + " Device FPS: " + ofToString(openNIDevice.getFrameRate());
    
	verdana.drawString(msg, 20, openNIDevice.getNumDevices() * 480 - 20);
}

//--------------------------------------------------------------
void testApp::handEvent(ofxOpenNIHandEvent & event){
    // show hand event messages in the console
    ofLogNotice() << getHandStatusAsString(event.handStatus) << "for hand" << event.id << "from device" << event.deviceID;
}

//--------------------------------------------------------------
void testApp::exit(){
    openNIDevice.stop();
}

//--------------------------------------------------------------
