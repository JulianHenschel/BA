void loadCSV() {

  String lines[] = loadStrings("daten.csv");
  
  int csvWidth=0;
  
  //calculate max width of csv file
  for (int i=0; i < lines.length; i++) 
  {
    String [] chars=split(lines[i],',');
        
    if (chars.length > csvWidth)
    {
      csvWidth=chars.length;
    }
  }
    
  //create csv array based on # of rows and columns in csv file
  csv = new String [lines.length][csvWidth];
  
  //parse values into 2d array
  for (int i=0; i < lines.length; i++) 
  {
    String [] temp = new String [lines.length];
    temp= split(lines[i], ',');
    
    for (int j=0; j < temp.length; j++)
    {
     csv[i][j]=temp[j];
    }
  }
  
  //println(csv[1]);
}
