class AStarAlgorithm
{
  // data fields
  boolean
    destinationFound = false,                // tells whether or not destination has been found
    noPathFound;                             // tells whether or not no destination has been found
  Node winningNode;                          // holds value of the destination when it has been found
  Node[][] copyOfGrid;                       // holds a copy of the grid for access that the arraylist does not have
  ArrayList<Node>
    unexploredSet = new ArrayList<Node>(),   // the set of nodes that have not been explored
    winningPath = new ArrayList<Node>();     // holds the nodes that are the optimal distance from the destination to the initial player (testing purposes)
  
  // CONSTRUCTOR
  AStarAlgorithm(Node[][] n)
  {
    copyOfGrid = n;
    initialize();
  }
  
  // METHODS
// ---------------------------------------------------------------------------------------------------------------
  
  /* initialize()
   * initializes all of the unexploredSet and assigns them differentiating identifierVals
   */
  void initialize() // works in setup in the main
  {
    int identifierVal = 0;  // allows for differentiation between nodes with similar properties
    
    for (Node[] nodeArray : copyOfGrid)
    {
      for (Node node : nodeArray)
      {
        // initialize distance data fields (*IMPORTANT*)
        node.distance = Double.POSITIVE_INFINITY;
        node.heuristic = Double.POSITIVE_INFINITY;
        node.aStarDist = Double.POSITIVE_INFINITY;
        
        node.identifier = identifierVal;    // identifier
        unexploredSet.add(node);            // adding to unexplored set (main set)
        identifierVal++;
      }
    }
  }
  
// ---------------------------------------------------------------------------------------------------------------

  /* update()
   * completes all of the required actions while in draw
   */
   void update()
  {
    // INITIALIZING PHASE
    // setting current Node and removing it from unexplored set
    double lowestDistance = Double.POSITIVE_INFINITY;      // holds the lowest distance to do its turn
    Node currentNode = new Node(Integer.MAX_VALUE, Integer.MAX_VALUE, Integer.MAX_VALUE, Integer.MAX_VALUE);    // holds node with the lowest distance 
    noPathFound = true;
    
    // exploring the unexplored set for the node with the lowest value
    for (Node n : unexploredSet)
    {
      if (n.aStarDist < lowestDistance && n.aStarDist != Double.POSITIVE_INFINITY)    // distance with heuristics check
      {
        currentNode = n;
        lowestDistance = n.aStarDist;
        noPathFound = false;
      }
      
      if (n.identity.equals("destination"))
      {
        winningNode = n;
        println("we got winning node");    // allows heuristic calculations to occur
      }
    }
    
    // removing the currentNode from the unexploredSet
    unexploredSet.remove(currentNode);    
    
    // **************************************************************************************************************
    // NO PATH TO THE DESTINATION FOUND
    
    if (noPathFound)
    {
      /* nothing happens through this statement - when no path is found
       * however if there wanted to be some type of animation for the end of the game - draw it here
       */
      println("game ended - lost");
    }
    
    // **************************************************************************************************************
    // GAME WON OR NOT PHASE
    
    // if the destination has been found, draw path to destination
    if (currentNode.identity.equals("destination") && !noPathFound)
    {
      destinationFound = true;    // to ensure that the statements after this do not run
      winningNode = currentNode;  // so path could be draw
      
      // basically draws the path back to the original node
      drawDestination();
    }
    
    // **************************************************************************************************************
    // EVALUATION PHASE
    
    // if the destination is not found, explore the surrounding nodes and call them unexplored
    if (!destinationFound && !noPathFound)
    {
      // creates array surroundingNodes and adds nodes surrounding currentNode to them
      ArrayList<Node> surroundingNodes = new ArrayList<Node>();  // holds surrounding Nodes of currentNode
      
      // improves readability
      int nCol = currentNode.col;
      int nRow = currentNode.row;
      
      /* conditional statements to add surrounding nodes to surroundNodes
       * it is also checking to make sure it is not going through a wall
       */ 
      // CHECKING ROW ABOVE
      if (nCol - 1 >= 0)
      {
        surroundingNodes.add(copyOfGrid[nRow][nCol-1]);
        if (nRow - 1 >= 0 && !copyOfGrid[nRow][nCol-1].identity.equals("wall") && !copyOfGrid[nRow-1][nCol].identity.equals("wall"))
        {
          surroundingNodes.add(copyOfGrid[nRow-1][nCol-1]);
        }
        if (nRow + 1 < 70 && !copyOfGrid[nRow][nCol-1].identity.equals("wall") && !copyOfGrid[nRow+1][nCol].identity.equals("wall"))
        {
          surroundingNodes.add(copyOfGrid[nRow+1][nCol-1]);
        }
      }
      // CHECKING ROW BELOW
      if (nCol + 1 < 40)
      {
        surroundingNodes.add(copyOfGrid[nRow][nCol+1]);
        if (nRow - 1 >= 0 && !copyOfGrid[nRow][nCol+1].identity.equals("wall") && !copyOfGrid[nRow-1][nCol].identity.equals("wall"))
        {
          surroundingNodes.add(copyOfGrid[nRow-1][nCol+1]);
        }
        if (nRow + 1 < 70 && !copyOfGrid[nRow][nCol+1].identity.equals("wall") && !copyOfGrid[nRow+1][nCol].identity.equals("wall"))
        {
          surroundingNodes.add(copyOfGrid[nRow+1][nCol+1]);
        }
      }
      // CHECKING LEFT AND RIGHT MIDDLE NODES
      if (nRow - 1 >= 0)
      {
        surroundingNodes.add(copyOfGrid[nRow-1][nCol]);
      }
      if (nRow + 1 < 70)
      {
        surroundingNodes.add(copyOfGrid[nRow+1][nCol]);
      }
      
      // **************************************************************************************************************
      // SURROUDNING EVALUATION PHASE
      
      // surrounding nodes have been accumulated
      // calculations revolving surrounding nodes will occur
      for (Node surroundingNode : surroundingNodes)
      {
        // calculates the new distance based on whether or not it is a diagnol
        boolean diagnol = Math.abs(surroundingNode.row - nRow) + Math.abs(surroundingNode.col - nCol) == 2 ? true : false;    // calculates whether or not diagnol
        
        // calculates f, g and h (f = g + h)
        double movementCosts = (diagnol) ? currentNode.distance + 1.5 : currentNode.distance + 1;    // g
        double heuristic = calculateHeuristic(surroundingNode);                                      // h
        double overallCost = movementCosts + heuristic;                                              // f
        
        // very good for testing purposes
        //println(overallCost);
        
        // if surroundingNodes overall distance is greater than overall cost change parent and distance
        if (surroundingNode.aStarDist > overallCost && !surroundingNode.identity.equals("wall"))
        {
          surroundingNode.parents.put(movementCosts, currentNode);    // adds current node as parent (hashmap) with reference to g
          surroundingNode.parent = currentNode;      // adding current node as parent
          surroundingNode.distance = movementCosts;  // setting their distance to movement cost
          surroundingNode.heuristic = heuristic;     // setting their heuristic as heuristic calculated
          
          surroundingNode.updateDistance();      // does the distance calculation
          
          // changes identity of the surrounding
          if (!surroundingNode.identity.equals("destination"))
          {
            surroundingNode.identity = "unexplored";
          }
          
          // good for testing purposes (should equal one another)
          //println("nodeDist: " + surroundingNode.distance + "   overallCost: " + overallCost);
        }
      }
      
      // set the currentNode to explored to change colour and identity
      if (!currentNode.identity.equals("initial player"))
      {
        currentNode.identity = "explored";
      }
    }
  }
  
// ---------------------------------------------------------------------------------------------------------------

  /* drawDestination()
   * draws the path from destination to initial player 
   */ 
  void drawDestination()
  {
    // adds the nodes that make the optimal path from initial to destination
    Node currentNode = winningNode.parent;
    while (!currentNode.identity.equals("initial player"))
    {
      winningPath.add(currentNode);
      currentNode.identity = "winning path";
      currentNode = currentNode.parent;
    }
  }
  
// ---------------------------------------------------------------------------------------------------------------

  /* calculateHeuristic(Node)
   * this is the calculation of the hueristic in this algorithm
   */
   double calculateHeuristic(Node n)
   {
     // readibility 
     int rSize = n.rSize;
     int cSize = n.cSize;
     
     // calculates the change in x and y
     double dX = Math.abs(n.row * rSize - winningNode.row * rSize) / rSize;    // distance in terms of x nodes
     double dY = Math.abs(n.col * cSize - winningNode.col * cSize) / cSize;    // distance in terms of y nodes
     // uses pythagorean theorem and returns the heuristic
     double displacement = Math.sqrt(Math.pow(dX, 2) + Math.pow(dY, 2));       // pytagorean theorem
     return displacement;
   }
}
