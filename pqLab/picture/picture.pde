import java.awt.Image;
import java.util.Vector;
// Processing & TUIO import
import processing.core.*;
import TUIO.*;

  TuioClient client = null;
  boolean open = false;
  boolean tap = false;
  
  //for sizing
  boolean sizingKitty = false;
  boolean sizingPuppy = false;
 
  //for rotating
   boolean rotatingKitty = false;
   boolean rotatingPuppy = false; 
  
  PImage img;
//  PImage imgT;
  PImage imgK;
  PImage imgP;
  
  // Window Size
  // Image Position & Size & Angle
  float imagePositionX = 640.0F;
  float imageKPositionX = 0.0F;
  float imagePPositionX = 0.0F;
  float imagePositionY = 400.0F;
  float imageKPositionY = 0.0F;
  float imagePPositionY = 0.0F;
  float imageWidth = 480.0F;
  float imageKWidth = 200.0F;
  float imagePWidth = 200.0F;
  float imageHeight = 180.0F;
  float imageKHeight = 130.0F;
  float imagePHeight = 130.0F;
  float imageKRotate = 0.0F;
  float imagePRotate = 0.0F;
  
  int aliveCursor = 0;
  int curTime = 0;
  int prevCursor = 0;
  int prevTime = 0;

  // 1. Setup
  public void setup() {    
    // 1. Create TuioClient
    client = new TuioClient();
    client.connect();

    // 2. Load Image
    img = loadImage("album.png");
//    imgT = loadImage("test.jpg");
    imgK = loadImage("Kitten.jpg");
    imgP = loadImage("puppy.jpg");

    size(displayWidth, displayHeight);
  }

  // 2. draw
  public void draw() {
    // call multi-touch values and update
    updateImageData();
    albumTapCheck();
    // set Background color
    background(100);
    // drawing
    pushMatrix();
      translate(- imageWidth / 2, - imageHeight / 2);
      // draw Image
      image(img, imagePositionX, imagePositionY, imageWidth, imageHeight);
      if(open && tap){
        pushMatrix();
        translate(imageKPositionX, imageKPositionY);
        rotate( radians(imageKRotate) );
        image(imgK, 0, 0, imageKWidth, imageKHeight);
        popMatrix();
        
        pushMatrix();
        translate(imagePPositionX, imagePPositionY);
        rotate( radians(imagePRotate) );
        image(imgP, 0, 0, imagePWidth, imagePHeight);
        popMatrix();
      }
      
//      image(imgT, imagePositionX, imagePositionY, 10.0f, 10.0f);
    popMatrix();
  }

  // 3. update data
  public void updateImageData() {
    aliveCursor = client.getTuioCursors().size();
    switch (aliveCursor) {
    // if touch 1 finger
    // albumTap
    case 1:
      sizingKitty = false;
      sizingPuppy = false;
      rotatingKitty = false;
      rotatingPuppy = false;
      
      Vector<TuioCursor> cursors = client.getTuioCursors();
      if(aliveCursor == 1){
        drag(cursors.get(0));
      }
      
      if(isTouchAlbum()){
        if(open){
          open = false;
        }else{
          open = true;
          changePicturePos();
        }
      }  
      
      break;
    // if touch 2 fingers
    // Image Size Modify
    case 2:
      rotatingKitty = false;
      rotatingPuppy = false;
      // check
      // Change Image Size
      findImageForSizing();
      changeSize();
      break;
//    // if touch 3 fingers
//    // Image Rotation Modify
    case 3:
      sizingKitty = false;
      sizingPuppy = false;
      
      findImageForRotating();
      rotating();
      
      // check
      // calculate two cursors's gradient and rotate Image
      
      break;

    default:
      break;
    }
  }
  
  public void albumTapCheck(){
      aliveCursor = client.getTuioCursors().size();
      curTime = minute()*60 + second(); 
      
      if(prevCursor == 1 && aliveCursor == 0){
        prevTime = curTime;
        if(curTime-prevTime < 2){
          tap = true;
        }
      }else if(isTouchAlbum()){
        tap = false;
        prevCursor = aliveCursor;
      }
      
      
      
  }
  
  public boolean isTouchAlbum(){
   Vector<TuioCursor> cursors = client.getTuioCursors();
      // loop - find cursor ( cursorID == 0 )
      float curX = 0;
      float curY = 0;
      for (TuioCursor tuioCursor : cursors) {
        if (0 == tuioCursor.getCursorID()) {
          curX = tuioCursor.getX() * displayWidth;
          curY = tuioCursor.getY() * displayHeight;
        }
      } 
      
      //check and return
      float minX = imagePositionX-imageWidth/2;
      float maxX = imagePositionX+imageWidth/2;
      float minY = imagePositionY-imageHeight/2;
      float maxY = imagePositionY+imageHeight/2;
   
      if(minX<curX && curX<maxX && minY<curY && curY<maxY){
        return true;
      }else{
        return false;
      }
  }
  
  public boolean isTouchKitty(){
    if(!open){
      return false;
    }
   
   Vector<TuioCursor> cursors = client.getTuioCursors();
      // loop - find cursor ( cursorID == 0 )
      float curX = 0;
      float curY = 0;
      for (TuioCursor tuioCursor : cursors) {
        if (0 == tuioCursor.getCursorID()) {
          curX = tuioCursor.getX() * displayWidth;
          curY = tuioCursor.getY() * displayHeight;
        }
      } 
      
      //check and return
      float minX = imageKPositionX-imageKWidth/2;
      float maxX = imageKPositionX+imageKWidth/2;
      float minY = imageKPositionY-imageKHeight/2;
      float maxY = imageKPositionY+imageKHeight/2;
   
      if(minX<curX && curX<maxX && minY<curY && curY<maxY){
        return true;
      }else{
        return false;
      }
  }
  
  public boolean isTouchPuppy(){
   if(!open){
      return false;
    }
    
   Vector<TuioCursor> cursors = client.getTuioCursors();
      // loop - find cursor ( cursorID == 0 )
      float curX = 0;
      float curY = 0;
      for (TuioCursor tuioCursor : cursors) {
        if (0 == tuioCursor.getCursorID()) {
          curX = tuioCursor.getX() * displayWidth;
          curY = tuioCursor.getY() * displayHeight;
        }
      } 
      
      //check and return
      float minX = imagePPositionX-imagePWidth/2;
      float maxX = imagePPositionX+imagePWidth/2;
      float minY = imagePPositionY-imagePHeight/2;
      float maxY = imagePPositionY+imagePHeight/2;
   
//      float minX = imagePPositionX-imagePWidth/2;
//      float maxX = imagePPositionX+imagePWidth/2;
//      float minY = imagePPositionY-imagePHeight/2;
//      float maxY = imagePPositionY+imagePHeight/2;
      
      if(minX<curX && curX<maxX && minY<curY && curY<maxY){
        print("P_touch\n");
        return true;
      }else{
        return false;
      }
  }


public void drag(TuioCursor tuioCursor){
  float curX = tuioCursor.getX() * displayWidth;
  float curY = tuioCursor.getY() * displayHeight;
  
  if(isTouchAlbum()){
    //album
    if(Math.abs(curX-imagePositionX) < 120 && Math.abs(curY-imagePositionY) < 120){
      imagePositionX = curX;
      imagePositionY = curY;
      changePicturePos();
    }
  }else if(isTouchKitty()){
    //kitty
    if(Math.abs(curX-imageKPositionX) < 150 && Math.abs(curY-imageKPositionY) < 150){
      imageKPositionX = curX;
      imageKPositionY = curY;
    }
  }else if(isTouchPuppy()){
    //puppy
    if(Math.abs(curX-imagePPositionX) < 150 && Math.abs(curY-imagePPositionY) < 150){
      imagePPositionX = curX;
      imagePPositionY = curY;
    }
  }
}

public void changePicturePos(){
  imageKWidth = 200.0F;
  imagePWidth = 200.0F;
  imageKHeight = 130.0F;
  imagePHeight = 130.0F;
  
  imageKRotate = 0.0F;
  imagePRotate = 0.0F;
    
  imageKPositionX = imagePositionX+imageWidth*2/3;
  imageKPositionY = imagePositionY-imageHeight;
  imagePPositionX = imagePositionX-imageWidth/3;
  imagePPositionY = imagePositionY-imageHeight;
  
  
}

public void findImageForSizing(){
  TuioCursor cursor1 = null;
  TuioCursor cursor2 = null;
  
  for (TuioCursor tuioCursor : client.getTuioCursors()) {
        if (0 == tuioCursor.getCursorID()) {
          cursor1 = tuioCursor;
        }
        if (1 == tuioCursor.getCursorID()) {
          cursor2 = tuioCursor;
        }
  }
     
  if (cursor1 != null && cursor2 != null) {
    if((checkPicture(cursor1) != checkPicture(cursor2)) || checkPicture(cursor1)==-1 || checkPicture(cursor2)==-1){
      return;
    }
    //size change
    if(checkPicture(cursor1)==1){
      return;
    }
    if(checkPicture(cursor1)==2){
      //kitty
      sizingKitty = true;
      sizingPuppy = false;
    }
    if(checkPicture(cursor1)==3){
      //puppy
      sizingKitty = false;
      sizingPuppy = true;
    }
  }
}

public void findImageForRotating(){
  TuioCursor cursor1 = null;
  TuioCursor cursor2 = null;
  
  for (TuioCursor tuioCursor : client.getTuioCursors()) {
        if (0 == tuioCursor.getCursorID()) {
          cursor1 = tuioCursor;
        }
        if (1 == tuioCursor.getCursorID()) {
          cursor2 = tuioCursor;
        }
  }
     
  if (cursor1 != null && cursor2 != null) {
    if((checkPicture(cursor1) != checkPicture(cursor2)) || checkPicture(cursor1)==-1 || checkPicture(cursor2)==-1){
      return;
    }
    //size change
    if(checkPicture(cursor1)==1){
      return;
    }
    if(checkPicture(cursor1)==2){
      //kitty
      rotatingKitty = true;
      rotatingPuppy = false;
    }
    if(checkPicture(cursor1)==3){
      //puppy
      rotatingKitty = false;
      rotatingPuppy = true;
    }
  }
}

public int checkPicture(TuioCursor cursor){
  float curX = cursor.getX() * displayWidth;
  float curY = cursor.getY() * displayHeight; 
  
  // Albumcheck
  float AminX = imagePositionX-imageWidth/2;
  float AmaxX = imagePositionX+imageWidth/2;
  float AminY = imagePositionY-imageHeight/2;
  float AmaxY = imagePositionY+imageHeight/2;
  
  float KminX = imageKPositionX-imageKWidth/2;
  float KmaxX = imageKPositionX+imageKWidth/2;
  float KminY = imageKPositionY-imageKHeight/2;
  float KmaxY = imageKPositionY+imageKHeight/2;
  
  float PminX = imagePPositionX-imagePWidth/2;
  float PmaxX = imagePPositionX+imagePWidth/2;
  float PminY = imagePPositionY-imagePHeight/2;
  float PmaxY = imagePPositionY+imagePHeight/2;
   
  if(AminX<curX && curX<AmaxX && AminY<curY && curY<AmaxY){
    //album
    return 1;
  }
  if(KminX<curX && curX<KmaxX && KminY<curY && curY<KmaxY){
    //kitty
    return 2;
  }
  if(PminX<curX && curX<PmaxX && PminY<curY && curY<PmaxY){
    //puppy
    return 3;
  }
  return -1;
}

public void changeSize(){
  TuioCursor cursor1 = null;
  TuioCursor cursor2 = null;
  
  for (TuioCursor tuioCursor : client.getTuioCursors()) {
        if (0 == tuioCursor.getCursorID()) {
          cursor1 = tuioCursor;
        }
        if (1 == tuioCursor.getCursorID()) {
          cursor2 = tuioCursor;
        }
  }
  
  if(sizingKitty){
    imageKWidth = Math.abs(cursor1.getX() - cursor2.getX())* displayWidth;
    imageKHeight = Math.abs(cursor1.getY() - cursor2.getY())* displayHeight;
  }else if(sizingPuppy){
    imagePWidth = Math.abs(cursor1.getX() - cursor2.getX())* displayWidth;
    imagePHeight = Math.abs(cursor1.getY() - cursor2.getY())* displayHeight;
  }
  
}

public void rotating(){
  TuioCursor cursor1 = null;
  TuioCursor cursor2 = null;
  
  for (TuioCursor tuioCursor : client.getTuioCursors()) {
        if (0 == tuioCursor.getCursorID()) {
          cursor1 = tuioCursor;
        }
        if (1 == tuioCursor.getCursorID()) {
          cursor2 = tuioCursor;
        }
  }

  if(rotatingKitty){
    float gradient = (cursor1.getY() - cursor2.getY()) / (cursor1.getX() - cursor2.getX());
    imageKRotate = (float)(Math.atan(gradient) * 180.0 /  Math.PI);
  }else if(rotatingPuppy){
    float gradient = (cursor1.getY() - cursor2.getY()) / (cursor1.getX() - cursor2.getX());
    imagePRotate = (float)(Math.atan(gradient) * 180.0 /  Math.PI);
  }  
}
