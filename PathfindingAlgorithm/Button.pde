class Button
{
  // data fields
  int 
    topLeftX,      // top left x of button
    topLeftY,      // top left y of button
    buttonWidth,   // witdth of button
    buttonHeight,  // height of button
    red,           // rgb value 
    green,         // rgb value 
    blue,          // rgb value 
    myTextSize;    // how large is text
  String myText;   // String displayed
  boolean selected;// whether or not button is selected
  
  // CONSTRUCTOR (2 Types)
  Button(int topLeftX, int topLeftY, int bWidth, int bHeight, String myText, int myTextSize, boolean selected)    // red and white button
  {
    this.topLeftX = topLeftX;
    this.topLeftY = topLeftY;
    this.buttonWidth = bWidth;
    this.buttonHeight = bHeight;
    this.red = 255;
    this.green = 255;
    this.blue = 255;
    this.myText = myText;
    this.myTextSize = myTextSize;
    this.selected = selected;
  }
  
  Button(int topLeftX, int topLeftY, int bWidth, int bHeight, int red, int green, int blue, String myText, int myTextSize, boolean selected)    // single colour button
  {
    this.topLeftX = topLeftX;
    this.topLeftY = topLeftY;
    this.buttonWidth = bWidth;
    this.buttonHeight = bHeight;
    this.red = red;
    this.green = green;
    this.blue = blue;
    this.myText = myText;
    this.myTextSize = myTextSize;
    this.selected = selected;
  }
  
  // METHODS
// ---------------------------------------------------------------------------------------------------------------

  /* drawButton()
   * characteristics required to draw the button
   */
  void drawButton()
  {
    // colour
    fill(red, green, blue);
    if (selected && !myText.equals("START"))
    {
      fill(255, 0, 0);
    }
    
    // drawing box
    rectMode(CORNER);
    rect(topLeftX, topLeftY, buttonWidth, buttonHeight);
    
    // writing the words on top of the button
    fill(0);
    textAlign(CENTER, CENTER);
    PFont serif = createFont("Serif", myTextSize);
    textFont(serif);
    textSize(myTextSize);
    text(myText, topLeftX + buttonWidth/2, topLeftY + buttonHeight/2);
  }
  
// ---------------------------------------------------------------------------------------------------------------

  /* isClicked()
   * checks if the given values are in the parameters of the button
   */ 
  boolean isClicked(int playerX, int playerY)
  {
    boolean xTrue = (playerX > topLeftX && playerX < topLeftX + buttonWidth) ? true : false;
    boolean yTrue = (playerY > topLeftY && playerY < topLeftY + buttonHeight) ? true : false;
    return xTrue && yTrue;
  } 
}
