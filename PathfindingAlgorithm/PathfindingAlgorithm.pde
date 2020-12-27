/* PATHFINDING ALGORITHMS
 * CREATED BY : Muhammad Rayaq Siddiqui :)
 * Version : 1.0
 *
 * Implementation of the Dijkstra Algorithm and A* Algorithm used for path finding
 * 
 * Concepts Used:
 * Buttons, Nodes, ArrayLists, Object Oriented Programming...         
 *
 * Resources :
 * https://medium.com/@nicholas.w.swift/easy-dijkstras-pathfinding-324a51eeb0f
 * https://www.geeksforgeeks.org/a-search-algorithm/
 * java docs.oracle
 * My projects referenced : Game of Life/ Sudoku / Snake
 */

// DATA FIELDS
DijkstraAlgorithm da;        // Dijkstra's Algorithm config.
AStarAlgorithm as;           // A Star Algorithm config.
Board b;                     // creating the grid
int
  initialPlayerCount,        // allows there to be one player
  initialDestinationCount,   // allows there to be one destination
  winningPathSize;           // winning path size
boolean
  iPlayer,                   // allows to place initial player
  destination,               // allows to place destination
  wall,                      // allows to build walls
  start,                     // whether or not game started
  dijkstraAlgorithm,         // says whether or not Dijkstra's Algorithm is running
  aStarAlgorithm,            // says whether or not A Star Algorithm is running
  slow,                      // sets the frame rate to 10
  medium,                    // sets the frame rate to 30
  fast;                      // sets the frame rate to 60
long
  startTime,                 // holds the value of the start time
  currentTime,               // holds the value of the current time
  endTime,                   // holds the value of the end time
  totalTime;                 // difference of end and start

// ---------------------------------------------------------------------------------------------------------------
// SETUP - ran only in the beginning 
void setup()
{
  // setting up the screen
  size(1200, 600);              // initialize size of screen
  surface.setResizable(false);  // does not allow window to be resized
  frameRate(30);                // initial frame rate is medium
  
  // initializing the board
  b = new Board(70, 40, 1100, 600);
  b.drawBoard();
  
  // initializing variables
  initialPlayerCount = 0;
  initialDestinationCount = 0;

  dijkstraAlgorithm = true;
  aStarAlgorithm = false;
  iPlayer = true;
  destination = false;
  wall = false;
  start = false;
}

// DRAW
// ---------------------------------------------------------------------------------------------------------------

void draw()
{
  // if running Dijkstra's Algorithm - start variables
  if (dijkstraAlgorithm && !start)
  {
    da = new DijkstraAlgorithm(b.nodes);            // creates the dijkstra's algorithm version of the game 
  }
  // if running A Star Algorithm - start variables
  else if (aStarAlgorithm && !start)
  {
    as = new AStarAlgorithm(b.nodes);               // creates the a star algorithm version of the game 
  }
  
  // updates the board every time
  b.drawBoard();
  
  if (slow || medium || fast)    // change in frame rate
  {
    speed();
  }
  
  // running the game
  if (start && dijkstraAlgorithm)      // if game started and running dijkstra's
  {
    // Updates the information with Dijkstra's Algorithm
    da.update();
    
    if (da.winningPath.size() > 0 || da.noPathFound)    // to see if game is over or if path found
    {
      winningPathSize = da.winningPath.size();
      start = false;
    }
  }
  else if (start && aStarAlgorithm)      // if game started and running a star
  {
    // Updates the information with A Star Algorithm
    as.update();
    
    if (as.winningPath.size() > 0 || as.noPathFound)   // to see if game is over or if path found
    {
      start = false;
      winningPathSize = as.winningPath.size();
    }
  }
  else if (!iPlayer && !destination && !wall && !start)  // if the animation is completely over
  {
    // updates the time at the end of the game
    endTime = System.currentTimeMillis();
    totalTime = (endTime - startTime) / 1000;
    b.buttons.get(9).myText = "Time:\n"+ Long.toString(totalTime) + " seconds";
    b.buttons.get(9).drawButton();
    
    // update the length of the winning path nodes
    b.buttons.get(10).myText = "Length:\n"+ winningPathSize + " nodes";
    b.buttons.get(10).drawButton();
    
    if (winningPathSize == 0)
    {
      b.buttons.get(10).myText = "Length:\nNo Path Found";
      b.buttons.get(10).drawButton();
    }
        
    // ends the loop - no more interactability
    noLoop();
  }
  
  if (start)    // assuming algorithms have started - do this
  {
    // updates the time at each turn
    currentTime = System.currentTimeMillis();
    totalTime = (currentTime - startTime) / 1000;
    b.buttons.get(9).myText = "Time:\n"+ Long.toString(totalTime) + " seconds";
  }
}

// METHODS
// ---------------------------------------------------------------------------------------------------------------
void mouseClicked()
{
  println(mouseX + ", " + mouseY);
  
  // initializing the mouse X and Y value
  int 
    mX = mouseX/b.rSize,      // x value of mouse in reference to tiles
    mY = mouseY/b.cSize;      // y value of mouse in reference to tiles
  
  if (mX < 70 && mX >= 0 && mY < 40 && mY >= 0)    // prevent errors
  {
    if (iPlayer)      // sets to initial player or removes initial player with a max of 1 
    {
      if (b.nodes[mX][mY].identity.equals("empty") && initialPlayerCount == 0)
      {
        b.nodes[mX][mY].identity = "initial player";
        initialPlayerCount = 1;
      }
      else if (b.nodes[mX][mY].identity.equals("initial player"))
      {
        b.nodes[mX][mY].identity = "empty";
        initialPlayerCount = 0;
      }
    }
    
    if (destination)      // sets or removes destination with a max of 1
    {
      if (b.nodes[mX][mY].identity.equals("empty") && initialDestinationCount == 0)
      {
        b.nodes[mX][mY].identity = "destination";
        initialDestinationCount = 1;
      }
      else if (b.nodes[mX][mY].identity.equals("destination"))
      {
        b.nodes[mX][mY].identity = "empty";
        initialDestinationCount = 0;
      }
    }
    
    if (wall)    // sets of removes as many walls as you want to make a challenge
    {
      if (b.nodes[mX][mY].identity.equals("empty"))
      {
        b.nodes[mX][mY].identity = "wall";
      }
      else if (b.nodes[mX][mY].identity.equals("wall"))
      {
        b.nodes[mX][mY].identity = "empty";
      }
    }
  }
  
  if (b.buttons.get(0).isClicked(mouseX, mouseY) && !start)    // Dijkstra's Algorithm Button clicked
  {
    // boolean change
    dijkstraAlgorithm = true;
    aStarAlgorithm = false;
    
    // button colour change
    b.buttons.get(0).selected = true;
    b.buttons.get(1).selected= false;
    
    // readibility 
    println("Dijkstra's Algorithm");
  }
  else if (b.buttons.get(1).isClicked(mouseX, mouseY) && !start)    // A Star Algorithm button clicked
  {
    // boolean change
    dijkstraAlgorithm = false;
    aStarAlgorithm = true;
    
    // button colour change 
    b.buttons.get(0).selected = false;
    b.buttons.get(1).selected = true;
    
    // readibility
    println("A Star Algorithm");
  }
  else if (b.buttons.get(2).isClicked(mouseX, mouseY) && !start)    // Initial Player button
  {
    // boolean chance
    iPlayer = true;
    destination = false;
    wall = false;
    
    // button colour change
    b.buttons.get(2).selected = true;
    b.buttons.get(3).selected = false;
    b.buttons.get(4).selected = false;
    
    // readibility
    println("Initial Player");
  }
  else if (b.buttons.get(3).isClicked(mouseX, mouseY) && !start)    // Destination button 
  {
    // boolean change
    iPlayer = false;
    destination = true;
    wall = false;
    
    // button colour change
    b.buttons.get(2).selected = false;
    b.buttons.get(3).selected = true;
    b.buttons.get(4).selected = false;
    
    // readibility
    println("Destination");
  }
  else if (b.buttons.get(4).isClicked(mouseX, mouseY) && !start)    // Wall button 
  {
    // boolean change
    iPlayer = false;
    destination = false;
    wall = true;
    
    // button colour change
    b.buttons.get(2).selected = false;
    b.buttons.get(3).selected = false;
    b.buttons.get(4).selected = true;
    
    // readibility 
    println("Wall");
  }
  else if (b.buttons.get(5).isClicked(mouseX, mouseY))    // Slow button
  {
    // boolean change
    slow = true;
    
    // button colour change
    b.buttons.get(5).selected = true;
    b.buttons.get(6).selected = false;
    b.buttons.get(7).selected = false;
    
    // readibility
    println("Slow");
  }
  else if (b.buttons.get(6).isClicked(mouseX, mouseY))    // Medium button
  {
    // boolean change
    medium = true;
    
    // button colour change
    b.buttons.get(5).selected = false;
    b.buttons.get(6).selected = true;
    b.buttons.get(7).selected = false;
    
    // readibility
    println("Medium");
  }
  else if (b.buttons.get(7).isClicked(mouseX, mouseY))    // Fast button
  {
    // boolean change
    fast = true;
    
    // button colour change
    b.buttons.get(5).selected = false;
    b.buttons.get(6).selected = false;
    b.buttons.get(7).selected = true;
    
    // readibility
    println("Fast");
  }
  else if (b.buttons.get(8).isClicked(mouseX, mouseY) && initialDestinationCount == 1 && initialPlayerCount == 1)    // Start button
  {
    // boolean change
    start = true;
    iPlayer = false;
    destination = false;
    wall = false;
    
    // button colour change
    b.buttons.get(0).selected = false;
    b.buttons.get(1).selected = false;
    b.buttons.get(2).selected = false;
    b.buttons.get(3).selected = false;
    b.buttons.get(4).selected = false;
    b.buttons.get(8).selected = true;
    
    // time start and readibility
    startTime = System.currentTimeMillis();
    println("Start");
  }
}

// ---------------------------------------------------------------------------------------------------------------
void mouseDragged()
{
  // initializing the mouse X and Y value
  int 
    mX = mouseX/b.rSize,      // x value of mouse in reference to tiles
    mY = mouseY/b.cSize;      // y value of mouse in reference to tiles
  
  if (mX < 70 && mX >= 0 && mY < 40 && mY >= 0)    // to avoid out of bound errors
  {
    if (wall)
    {
      if (b.nodes[mX][mY].identity.equals("empty"))
      {
        b.nodes[mX][mY].identity = "wall";
      }
      
      /* THIS IS CURRENTLY TURNED OFF SO WALLS CAN BE DRAWN EASIER - HOWEVER TO UNCOMMENT TO HAVE A MORE CONSISTENT FEATURE */
      //else if (b.nodes[mX][mY].identity.equals("wall"))
      //{
      //  b.nodes[mX][mY].identity = "empty";
      //}
    }
  }
}

// ---------------------------------------------------------------------------------------------------------------

/* speed()
 * updates the frame rate if given instruction to do so
 */
void speed()
{
  if (slow)         // if slow frame Rate == 10
  {
    frameRate(10);
    slow = false;
  }
  else if (medium)  // if medium frameRate = 30
  {
    frameRate(30);
    medium = false;
  }
  else if (fast)    // if medium frameRate = 60
  {
    frameRate(60);
    fast = false;
  }
}
