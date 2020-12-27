
// This is the old version of the algorithm
// fundamental for both of the new Algorithm
// do not use

class DijkstraAlgoirthmV1
{
  // data fields
  Node[][] tmpCopy;
  ArrayList<Node> unexploredSet = new ArrayList<Node>(), winningPath = new ArrayList<Node>();
  boolean destinationFound = false;
  Node winningNode;
  
  // methods
  void initialize()
  {
    println("initialize");
    int identifierVal = 0;
    // works in setup in the main
    for (Node[] nodeArray : tmpCopy)
    {
      for (Node node : nodeArray)
      {
        node.distance = Double.POSITIVE_INFINITY;
        node.identifier = identifierVal;
        unexploredSet.add(node);
        identifierVal++;
      }
    }
  }
  
  void update() throws InterruptedException
  {
    /* whatever updates are required - draw in main basically */
    
    // setting current Node and removing it from unexplored set
    double lowestDistance = Double.POSITIVE_INFINITY;
    Node currentNode = new Node(0, 0, 0, 0);
    
    for (Node n : unexploredSet)
    {
      if (n.distance < lowestDistance)
      {
        currentNode = n;
        lowestDistance = n.distance;
      }
    }
    
    unexploredSet.remove(currentNode);
    
    // if the destination has been found
    if (currentNode.identity.equals("destination"))
    {
      // found the path
      // backtrack until the start
      destinationFound = true;
      winningNode = currentNode;
      drawDestination();
    }
    
    if (!destinationFound)
    {
      // creates tmpNodes and adds nodes surrounding currentNode to them *******************************************************
      ArrayList<Node> tmpNodes = new ArrayList<Node>();  // surrounding Nodes
      int nCol = currentNode.col;
      int nRow = currentNode.row;
      if (nCol - 1 >= 0)
      {
        tmpNodes.add(tmpCopy[nRow][nCol-1]);
        if (nRow - 1 >= 0)
        {
          tmpNodes.add(tmpCopy[nRow-1][nCol-1]);
        }
        if (nRow + 1 < 70)
        {
          tmpNodes.add(tmpCopy[nRow+1][nCol-1]);
        }
      }
      if (nCol + 1 < 40)
      {
        tmpNodes.add(tmpCopy[nRow][nCol+1]);
        if (nRow - 1 >= 0)
        {
          tmpNodes.add(tmpCopy[nRow-1][nCol+1]);
        }
        if (nRow + 1 < 70)
        {
          tmpNodes.add(tmpCopy[nRow+1][nCol+1]);
        }
      }
      if (nRow - 1 >= 0)
      {
        tmpNodes.add(tmpCopy[nRow-1][nCol]);
      }
      if (nRow + 1 < 70)
      {
        tmpNodes.add(tmpCopy[nRow+1][nCol]);
      }
      
      for (Node node : tmpNodes)
      {
        // calculates the new distance
        boolean diagnol = Math.abs(node.row - nRow) + Math.abs(node.col - nCol) == 2 ? true : false;
        double newDist = (diagnol) ? currentNode.distance + 1.5 : currentNode.distance + 1;
        
        if (node.distance > newDist && !node.identity.equals("wall"))
        {
          node.parents.put(newDist, currentNode);
          node.parent = currentNode;
          node.distance = newDist;
          
          println("nodeDist: " + node.distance + "   newDist: " + newDist);
          
          //Thread.sleep(500);
          
          if (!node.identity.equals("destination"))
          {
            node.identity = "unexplored";
          }
        }
      }
      // **************************************************************************************************************
      
      if (!currentNode.identity.equals("initial player"))
      {
        currentNode.identity = "explored";
      }
    }
  }
  
  void drawDestination() throws InterruptedException
  {
    Node currentNode = winningNode.parent;
    while (!currentNode.identity.equals("initial player"))
    {
      winningPath.add(currentNode);
      currentNode = currentNode.parent;
      println("adding node");
    }
    for (Node n : winningPath)
    {
      n.identity = "winning path";
      n.drawTile();
      //Thread.sleep(1000);
    }
  }
  
  //// finds the surrounding node with the smallest distance behind it
  //Node checkSurroundings(Node n)
  //{
  //  // checks all eight directions
  //  int nRow = n.row;
  //  int nCol = n.col;
  //  Node favourableNode = new Node(0, 0, 0, 0);
  //  double favourableDistance = Double.POSITIVE_INFINITY;
    
    //// creates tmpNodes and adds nodes to them *******************************************************
    
    
    //// LATER MAKE SURE TO INCLUDE WALL CHECKING
    
    
    
    //ArrayList<Node> tmpNodes = new ArrayList<Node>();
    //if (nCol - 1 >= 0)
    //{
    //  tmpNodes.add(tmpCopy[nRow][nCol-1]);
    //  if (nRow - 1 >= 0)
    //  {
    //    tmpNodes.add(tmpCopy[nRow-1][nCol-1]);
    //  }
    //  if (nRow + 1 < 70)
    //  {
    //    tmpNodes.add(tmpCopy[nRow+1][nCol-1]);
    //  }
    //}
    //if (nCol + 1 >= 0)
    //{
    //  tmpNodes.add(tmpCopy[nRow][nCol+1]);
    //  if (nRow - 1 >= 0)
    //  {
    //    tmpNodes.add(tmpCopy[nRow-1][nCol+1]);
    //  }
    //  if (nRow + 1 < 70)
    //  {
    //    tmpNodes.add(tmpCopy[nRow+1][nCol+1]);
    //  }
    //}
    //if (nRow - 1 >= 0)
    //{
    //  tmpNodes.add(tmpCopy[nRow-1][nCol]);
    //}
    //if (nRow + 1 >= 0)
    //{
    //  tmpNodes.add(tmpCopy[nRow+1][nCol]);
    //}
    //// **************************************************************************************************************
    
  //  for (Node tmpNode : tmpNodes)
  //  {
  //    if (tmpNode.distance < favourableDistance)
  //    {
  //      favourableNode = tmpNode;
  //    }
  //  }
    
  //  // diagnol or besides
  //  boolean diagnol = Math.abs(favourableNode.row - nRow) + Math.abs(favourableNode.col - nCol) == 2 ? true : false;
    
  //  return favourableNode;
  //}
}
