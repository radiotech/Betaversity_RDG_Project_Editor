String[] allName;
String[] allIsModule;
String[] allProjectType;
String[] allDocCode;
String[] allLastUser;
String[] allDateAdded;
String[] allDateRemoved;
String[] allComponents;
int allEntries = 0;

void loadModules(){
  loadData();
  cNames[0][0] = "#";
  cNames[0][1] = "Module Name";
  cNames[0][2] = "Doc Code";
  cNames[0][3] = "Last User";
  cNames[0][4] = "Date Added";
  cNames[0][5] = "Edit";
  cNames[0][6] = "Remove";
  tables[0] = new Table();
  TableRow newRow;
  for(int i = 0; i < 7; i++){
    tables[0].addColumn(cNames[0][i]);
  }
  for(int i = 0; i < allEntries; i++){
    newRow = tables[0].addRow();
    newRow.setInt(cNames[0][0], tables[0].lastRowIndex()+1);
    newRow.setString(cNames[0][1], allName[i]);
    newRow.setString(cNames[0][2], allDocCode[i]);
    newRow.setString(cNames[0][3], allLastUser[i]);
    newRow.setString(cNames[0][4], allDateAdded[i]);
    newRow.setString(cNames[0][5], "Edit");
    newRow.setString(cNames[0][6], "Remove");
  }
}

void loadData(){
  //get data from web
  String data = "Name_OneP:::Name_TwoM:::Name_ThreeM:::Name_FourP&&&0:::1:::1:::0&&&0:::-1:::-1:::2&&&9999999999:::8888888888:::7777777777:::5555555555&&&radiotech:::lavabirdaj:::airtruck:::dirtdragon&&&2008-06-13:::2008-06-13:::2008-06-13:::2008-06-13&&&2008-06-13:::2008-06-13:::2008-06-13:::2008-06-13&&&9999999999:::8888888888:::7777777777:::5555555555";//temp web str
  String[] datas = split(data,"&&&");
  allName = split(datas[0],":::");
  allIsModule = split(datas[1],":::");
  allProjectType = split(datas[2],":::");
  allDocCode = split(datas[3],":::");
  allLastUser = split(datas[4],":::");
  allDateAdded = split(datas[5],":::");
  allDateRemoved = split(datas[6],":::");
  allComponents = split(datas[7],":::");
  allEntries = allName.length;
}

void updateTables(){
  cNames[0][0] = "#";
  cNames[0][1] = "species";
  cNames[0][2] = "name";
  
  tables[0] = new Table();
  
  tables[0].addColumn(cNames[0][0]);
  tables[0].addColumn(cNames[0][1]);
  tables[0].addColumn(cNames[0][2]);
  
  TableRow newRow;
  
  newRow = tables[0].addRow();
  newRow.setInt(cNames[0][0], tables[0].lastRowIndex());
  newRow.setString(cNames[0][1], "Panthera leo");
  newRow.setString(cNames[0][2], "Lion");
  
  newRow = tables[0].addRow();
  newRow.setInt(cNames[0][0], tables[0].lastRowIndex());
  newRow.setString(cNames[0][1], "New Species");
  newRow.setString(cNames[0][2], "Name!");
  
}

void drawTable(int a){
  float pad = 7;
  int columns = tables[a].getColumnCount();
  int rows = tables[a].getRowCount();
  
  noStroke();
  fill(150);
  rect(0,0,width,rowH*height*(rows+2));
  fill(200);
  rect(0,0,width,rowH*height*2);
  
  stroke(0);
  strokeWeight(2);
  textAlign(LEFT,CENTER);
  fill(0);
  
  
  for(int i = 0; i < columns; i++){
    if(i > 0){
      line(width/columns*i,0,width/columns*i,rowH*height*(rows+2));
    }
    text(cNames[a][i],width/columns*i+pad,rowH*height);
  }
  
  TableRow newRow;
  for(int i = 0; i < rows; i++){
    for(int j = 0; j < columns; j++){
      text(tables[a].getString(i,cNames[a][j]),width/columns*j+pad,rowH*height*(2.5+i));
    }
    line(0,rowH*height*(i+2),width,rowH*height*(i+2));
  }
  line(0,rowH*height*(rows+2),width,rowH*height*(rows+2));
}


