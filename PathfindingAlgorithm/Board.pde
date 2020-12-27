class Board
{
  // data fields
  Node[][] nodes;    // all of the nodes that the board will be made out of 
  ArrayList<Button> 
    buttons;         // all of the buttons on the board
  int 
    rows,     // the amount of rows
    cols,     // the amount of columnss
    rSize,    // the size of each row
    cSize;    // the size of each column
  
  /* Position in the r/c - visual representation of the grid 
    [r, c]   [r+1, c]   [r+2, c]
    [r, c+1] [r+1, c+1] [r+2, c+1]
    [r, c+2] [r+1, c+2] [r+2, c+2]
  */
  
  // constructors
  Board(int rows, int cols, int rSize, int cSize)
  {
    this.rows = rows;
    this.cols = cols;
    this.rSize = rSize/rows;
    this.cSize = cSize/cols;
    
    nodes = new Node[rows][cols];
    initializeTiles();
    initializeButtons();
  }
  
  // methods
// ---------------------------------------------------------------------------------------------------------------

  /* initializeTiles()
   * creates the actual node array of the board
   */
  void initializeTiles()
  {
    for (int r = 0; r < rows; r++)
    {
      for (int c = 0; c < cols; c++)
      {
        // creating new tiles
        nodes[r][c] = new Node(r, c, rSize, cSize);
      }
    }
  }

// ---------------------------------------------------------------------------------------------------------------  

  /* initializeButtons()
   * creates all of the buttons and add them to an array list 
   */
  void initializeButtons()
  {
    buttons = new ArrayList<Button>();
    
    // Algorithm buttons
    buttons.add(new Button(1050, 50, 150, 75, "Dijkstra's\nAlgorithm", 23, true));  // 0
    buttons.add(new Button(1050, 125, 150, 75, "A Star\nAlgorithm", 23, false));    // 1
    
    // player interaction with board buttons
    buttons.add(new Button(1050, 200, 150, 50, "Initial Player", 25, true));    // 2
    buttons.add(new Button(1050, 250, 150, 50, "Destination", 30, false));      // 3
    buttons.add(new Button(1050, 300, 150, 50, "Wall", 30, false));             // 4
    
    // speed buttons
    buttons.add(new Button(1050, 350, 150, 50, "Slow", 30, false));       // 5
    buttons.add(new Button(1050, 400, 150, 50, "Medium", 30, true));      // 6
    buttons.add(new Button(1050, 450, 150, 50, "Fast", 30, false));       // 7
    
    // start buttons
    buttons.add(new Button(1050, 500, 150, 100, 1, 150, 32, "START", 40, false));     // 8
    
    // display time and score
    buttons.add(new Button(1050, 0, 75, 50, 1, 150, 32, "Time:\n____ seconds", 10, false));    // 9  
    
    buttons.add(new Button(1125, 0, 75, 50, 1, 150, 32, "Length:\n____ nodes", 10, false));    // 10
  }
  
// ---------------------------------------------------------------------------------------------------------------  

  /* drawBoard()
   * every turn when the game updates, draw the board
   */
  void drawBoard()
  {
    // first draw the nodes
    for (int r = 0; r < rows; r++)
    {
      for (int c = 0; c < cols; c++)
      {
        nodes[r][c].drawTile();
      }
    }
    
    // followed by drawing all of the buttons
    for (Button button : buttons)
    {
      button.drawButton();
    }
  }
}
