class Node
{
  // data fields
  String identity;    // identity (colour and traits) of the Node
  int 
    row,              // row 
    col,              // col
    rSize,            // the size of the row
    cSize,            // the size of the column
    red,              // rgb value
    green,            // rgb value
    blue;             // rgb value
  
  // Algorithmic data fields - used in the pathfinders
  Node parent;                              // the parent of the this node (closest)
  HashMap<Double, Node> 
    parents = new HashMap<Double, Node>();  // HashMap of parents to ensure all possibilities are feasible
  double   
    distance,          // distance from initialNode
    heuristic,         // used in a Star - distance to destination node
    aStarDist;         // used in a Star - sum of distance and heuristic
  int identifier;      // identifier used by both Algorithms
  
  // constructors
  Node(int row, int col, int rsize, int csize)
  {
    this.row = row;
    this.col = col;
    this.rSize = rsize;
    this.cSize = csize;
    this.identity = "empty";     // ensure that it always starts off as empty 
  }
  
  // METHODS
// ---------------------------------------------------------------------------------------------------------------
  
  /* drawTile()
   * draws the tile every turn
   */
  void drawTile()
  {
    // updates the identity before the tile is drawn
    updateIdentity();
    
    // draws the node as a square
    fill(red, green, blue);
    rectMode(CORNER);
    rect(row * rSize, col * cSize, rSize, cSize);
    
    // writes the distance on the node
    if (this.distance != Double.POSITIVE_INFINITY)
    {
      fill(0);
      textMode(CORNER);
      textAlign(CENTER, CENTER);
      textSize(7);
      text(Double.toString(this.distance), (float)this.row * this.rSize + rSize/2, (float)this.col * this.cSize + cSize/2);
    }
  }

// ---------------------------------------------------------------------------------------------------------------

  void updateDistance()
  {
    // Update parent and distance identity (searching through HashMap for lowest value mapped with a parent)
    if (!parents.isEmpty() && distance > 0)
    {
      double tmpDist = 0;
      while (!parents.containsKey(tmpDist))
      {
        tmpDist+=0.5;
      }
      // update value
      distance = tmpDist;
      parent = parents.get(distance);
      
      // if a star, update overall dist calc
      if (heuristic != Double.POSITIVE_INFINITY)
      {
        aStarDist = distance + heuristic;
      }
    }
  }
  
  void updateIdentity()
  {
    updateDistance();
    
    // UPDATE COLOUR AND IDENTITY AND SOME DISTANCES
    // change to an empty square
    if (identity.equals("empty"))
    {
      this.red = 255;
      this.green = 255; 
      this.blue = 255;
      this.distance = Double.POSITIVE_INFINITY;
      this.heuristic = Double.POSITIVE_INFINITY;
      this.aStarDist = Double.POSITIVE_INFINITY;
    }
    
    // ****************************************************************************
    
    // there can only be one initial player - this conditional statement creates it 
    if (identity.equals("initial player"))
    {
      this.red = 0;
      this.green = 0; 
      this.blue = 0;
      this.distance = 0;
      this.heuristic = 0;
      this.aStarDist = 0;
    }
    
    // ****************************************************************************
    
    // there can only be one destination (characteristics assigned by this statement)
    if (identity.equals("destination"))
    {
      this.red = 0;
      this.green = 0; 
      this.blue = 255;
      
      //println("destination");
    }
    
    // ****************************************************************************
    
    // allows for walls to be built making it harder to find a path
    if (identity.equals("wall"))
    {
      this.red = 139;
      this.green = 69; 
      this.blue = 19;
      
      //println("wall");
    }
    
    // ****************************************************************************
    
    // light green tiles in unexplored set (tiles yet to be checked)
    if (identity.equals("unexplored"))
    {
      this.red = 0;
      this.green = 255; 
      this.blue = 0;
      
      //println("unexplored");
    }
    
    // ****************************************************************************
    
    // tiles that have been checked and removed from unexplored set
    if (identity.equals("explored"))
    {
      this.red = 34;
      this.green = 139; 
      this.blue = 34;

      //println("explored");
    }
    
    // ****************************************************************************
    
    // there are the tiles in the winning path
    if (identity.equals("winning path"))
    {
      this.red = 255;
      this.green = 0; 
      this.blue = 0;
      
      //println("winning path");
    }
  }
}
