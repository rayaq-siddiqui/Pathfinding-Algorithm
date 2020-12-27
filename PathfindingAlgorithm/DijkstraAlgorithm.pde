class DijkstraAlgorithm    // current version
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
  DijkstraAlgorithm(Node[][] n)
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
    int identifierVal = 0;  // allows for differentiation between nodes with similar properties so empty node 1 != empty node 2
    
    for (Node[] nodeArray : copyOfGrid)
    {
      for (Node node : nodeArray)
      {
        node.distance = Double.POSITIVE_INFINITY;   // initial value of each node
        node.identifier = identifierVal;            // setting identifier Val
        unexploredSet.add(node);                    // adding to the unexploredSet (main set for searching)
        identifierVal++;    // incrementing
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
    double lowestDistance = Double.POSITIVE_INFINITY;      // represents the Node with the lowest distance
    Node currentNode = new Node(Integer.MAX_VALUE, Integer.MAX_VALUE, Integer.MAX_VALUE, Integer.MAX_VALUE);    // will hold the node with the shortest distance for this function
    noPathFound = true;      // sees whether or not the game is over 
    
    // exploring the unexplored set for the node with the lowest value
    for (Node n : unexploredSet)
    {
      if (n.distance < lowestDistance && n.distance != Double.POSITIVE_INFINITY)
      {
        currentNode = n;
        lowestDistance = n.distance;
        noPathFound = false;
      }
    }
    
    // removing the currentNode from the unexploredSet - so it does not repeat
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
    // EVALUATION PHASE - calculates the distance away from the initial player
    
    // if the destination or path is not found, explore the surrounding nodes and call them unexplored
    if (!destinationFound && !noPathFound)
    {
      // creates array surroundingNodes and adds nodes surrounding currentNode to them 
      ArrayList<Node> surroundingNodes = new ArrayList<Node>();  // holds surrounding Nodes
      
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
      
      // surrounding nodes have been accumulated - calculations revolving surrounding nodes will occur
      for (Node surroundingNode : surroundingNodes)
      {
        // calculates the new distance based on whether or not it is a diagnol
        boolean diagnol = Math.abs(surroundingNode.row - nRow) + Math.abs(surroundingNode.col - nCol) == 2 ? true : false;    // whether or not diagnol
        double newDist = (diagnol) ? currentNode.distance + 1.5 : currentNode.distance + 1;       // distance from original tile depending on whether or not it is diagnol
        
        // if surroundingNodes overall distance is greater than newDist change parent and distance
        if (surroundingNode.distance > newDist && !surroundingNode.identity.equals("wall"))
        {
          surroundingNode.parents.put(newDist, currentNode);      // adding this new Node as a parent to parent hashmap
          surroundingNode.parent = currentNode;          // setting this node as current parent
          surroundingNode.distance = newDist;            // setting the distance as new Distance calculated
          // changes identity of the surrounding
          if (!surroundingNode.identity.equals("destination"))
          {
            surroundingNode.identity = "unexplored";      // adding it as an unexplored tile which will soon be explored
          }
          
          // good for testing purposes (should equal one another)
          //println("nodeDist: " + surroundingNode.distance + "   newDist: " + newDist);
        }
      }
      
      // set the currentNode to explored to change colour and identity
      if (!currentNode.identity.equals("initial player"))
      {
        currentNode.identity = "explored";        // sets the currentNode as explored
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
}
