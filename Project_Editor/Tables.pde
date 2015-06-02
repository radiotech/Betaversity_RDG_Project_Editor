String[] allName;
String[] allIsModule;
String[] allProjectType;
String[] allDocCode;
String[] allLastUser;
String[] allDateAdded;
String[] allDateRemoved;
String[] allComponents;
String[] thisComponents;
String[] moduleDocCode;
String[] removedIsModule;
String[] removedDocCode;
String[] removedComponents;
int allEntries = 0;
int moduleEntries = 0;
int thisComponentsEntries;
int thisEntry = 0;

String[][] cNames = new String[1][20];
int[][] cActions = new int[1][20];
float[][] cXs = new float[1][20];
Table[] tables = new Table[1];
int tableIndex = 0;
float rowH = 30;

void loadModules(){
  loadData();
  cNames[0][0] = "#";
  cNames[0][1] = "Module Name";
  cNames[0][2] = "Doc Code";
  cNames[0][3] = "Last User";
  cNames[0][4] = "Date Added";
  cNames[0][5] = "Remove";
  tables[0] = new Table();
  TableRow newRow;
  for(int i = 0; i < 6; i++){
    tables[0].addColumn(cNames[0][i]);
    cActions[0][i] = -1;
  }
  cActions[0][5] = 0;
  for(int i = 0; i < allEntries; i++){
    if(allIsModule[i].equals("1")){
      newRow = tables[0].addRow();
      newRow.setInt(cNames[0][0], tables[0].lastRowIndex()+1);
      newRow.setString(cNames[0][1], allName[i].replaceAll("_"," "));
      newRow.setString(cNames[0][2], getTinyDocCode(allDocCode[i]));
      newRow.setString(cNames[0][3], allLastUser[i]);
      newRow.setString(cNames[0][4], allDateAdded[i]);
      newRow.setString(cNames[0][5], cNames[0][5]);
    }
  }
  textSizeTable();
}

void loadProjects(){
  loadData();
  cNames[0][0] = "#";
  cNames[0][1] = "Project Name";
  cNames[0][2] = "Project Type";
  cNames[0][3] = "Doc Code";
  cNames[0][4] = "Last User";
  cNames[0][5] = "Date Added";
  cNames[0][6] = "Edit";
  cNames[0][7] = "Remove";
  tables[0] = new Table();
  TableRow newRow;
  for(int i = 0; i < 8; i++){
    tables[0].addColumn(cNames[0][i]);
    cActions[0][i] = -1;
  }
  cActions[0][6] = 1;
  cActions[0][7] = 2;
  for(int i = 0; i < allEntries; i++){
    if(allIsModule[i].equals("0")){
      newRow = tables[0].addRow();
      newRow.setInt(cNames[0][0], tables[0].lastRowIndex()+1);
      newRow.setString(cNames[0][1], allName[i].replaceAll("_"," "));
      newRow.setString(cNames[0][2], allProjectType[i]);
      newRow.setString(cNames[0][3], getTinyDocCode(allDocCode[i]));
      newRow.setString(cNames[0][4], allLastUser[i]);
      newRow.setString(cNames[0][5], allDateAdded[i]);
      newRow.setString(cNames[0][6], cNames[0][6]);
      newRow.setString(cNames[0][7], cNames[0][7]);
    }
  }
  textSizeTable();
}

void loadProject(int a){
  //loadData();
  loadProjectData(a);
  cNames[0][0] = "Order";
  cNames[0][1] = "Added Modules";
  cNames[0][2] = "Up";
  cNames[0][3] = "Down";
  cNames[0][4] = "Remove";
  cNames[0][5] = "Available Modules";
  cNames[0][6] = "Add to Top";
  cNames[0][7] = "Add to Bottom";
  tables[0] = new Table();
  TableRow newRow;
  for(int i = 0; i < 8; i++){
    tables[0].addColumn(cNames[0][i]);
    cActions[0][i] = -1;
  }
  cActions[0][2] = 3;
  cActions[0][3] = 4;
  cActions[0][4] = 5;
  cActions[0][6] = 6;
  cActions[0][7] = 7;
  for(int i = 0; i < max(thisComponentsEntries,moduleEntries+1); i++){
    
    newRow = tables[0].addRow();
    if(i < thisComponentsEntries){
      newRow.setInt(cNames[0][0], tables[0].lastRowIndex()+1);
      newRow.setString(cNames[0][1], DocCodeToName(thisComponents[i],true).replaceAll("_"," "));
      newRow.setString(cNames[0][2], cNames[0][2]);
      newRow.setString(cNames[0][3], cNames[0][3]);
      newRow.setString(cNames[0][4], cNames[0][4]);
    } else {
      newRow.setString(cNames[0][0], "");
      newRow.setString(cNames[0][1], "");
      newRow.setString(cNames[0][2], "");
      newRow.setString(cNames[0][3], "");
      newRow.setString(cNames[0][4], "");
    }
    if(i == 0){
      newRow.setString(cNames[0][5], "Project Description");
      newRow.setString(cNames[0][6], cNames[0][6]);
      newRow.setString(cNames[0][7], cNames[0][7]);
    } else if(i > 0 && i < moduleEntries+1){
      newRow.setString(cNames[0][5], DocCodeToName(moduleDocCode[i-1],true).replaceAll("_"," "));
      newRow.setString(cNames[0][6], cNames[0][6]);
      newRow.setString(cNames[0][7], cNames[0][7]);
    } else {
      newRow.setString(cNames[0][5], "");
      newRow.setString(cNames[0][6], "");
      newRow.setString(cNames[0][7], "");
    }
    
  }
  textSizeTable();
}

void loadData(){
  //get data from web
  //String data = "Name_OneP:::Name_TwoM:::Name_ThreeM:::Name_FourP&&&0:::1:::1:::0&&&0:::-1:::-1:::2&&&9999999999:::8888888888:::7777777777:::5555555555&&&radiotech:::lavabirdaj:::airtruck:::dirtdragon&&&2008-06-13:::2008-06-13:::2008-06-13:::2008-06-13&&&2008-06-13:::2008-06-13:::2008-06-13:::2008-06-13&&&8888888888,8888888888,7777777777,---7777777777,8888888888:::::::::7777777777";//temp web str
  String[] dat = loadStrings("http://harvway.com/BetaBox/API/getData.php");
  String data = "&&&&&&&&&&&&&&&&&&&&&";
  if(dat != null){
    if(dat.length == 1 && dat[0].length()>20){
      data = dat[0];
    } else {
      messages.add(new Message("The Harvway/Betaversity servers returned the following error when attempting to serve you data:"));
      for(int i = 0; i < dat.length; i++){
        messages.add(new Message(dat[i]));
      }
    }
  } else {
    messages.add(new Message("Could not connect to the Harvway/Betaversity servers"));
  }
  String[] datas = split(data,"&&&");
  allName = split(datas[0],":::");
  allIsModule = split(datas[1],":::");
  allProjectType = split(datas[2],":::");
  allDocCode = split(datas[3],":::");
  allLastUser = split(datas[4],":::");
  allDateAdded = split(datas[5],":::");
  allDateRemoved = split(datas[6],":::");
  /*String[] temp*/allComponents = split(datas[7],":::");
  
  removedIsModule = new String[0];
  removedDocCode = new String[0];
  removedComponents = new String[0];
  for(int i = 0; i < allName.length; i++){
    if(!allDateRemoved[i].equals("0000-00-00")){
      removedIsModule = append(removedIsModule, allIsModule[i]);
      removedDocCode = append(removedDocCode, allDocCode[i]);
      removedComponents = append(removedComponents, allComponents[i]);
      allName = cutItem(allName,i);
      allIsModule = cutItem(allIsModule,i);
      allProjectType = cutItem(allProjectType,i);
      allDocCode = cutItem(allDocCode,i);
      allLastUser = cutItem(allLastUser,i);
      allDateAdded = cutItem(allDateAdded,i);
      allDateRemoved = cutItem(allDateRemoved,i);
      allComponents = cutItem(allComponents,i);
      //tempallComponents = cutItem(tempallComponents,i);
      i--;
    }
  }
  
  allEntries = allName.length;
  /*
  //remove non-project "components" fields
  int pointer = 0;
  allComponents = new String[allEntries];
  for(int i = 0; i < allEntries; i++){
    if(allIsModule[i].equals("0")){
      allComponents[pointer] = tempallComponents[i];
      pointer++;
    }
  }
  */
  moduleEntries = 0;
  moduleDocCode = new String[allEntries];
  for(int i = 0; i < allEntries; i++){
    if(allIsModule[i].equals("1")){
      moduleDocCode[moduleEntries] = allDocCode[i];
      moduleEntries++;
    }
  }
}

void loadProjectData(int a){
  thisEntry = a;
  String data = allComponents[a];
  if(!data.equals("")){
    String[] datas = split(data,",");
    String[] datas2 = new String[datas.length];
    int pointer = 0;
    for(int i = 0; i < datas.length; i++){
      if(datas[i].indexOf("---") == -1){
        datas2[pointer] = datas[i];
        pointer++;
      }
    }
    thisComponents = new String[pointer];
    for(int i = 0; i < pointer; i++){
      thisComponents[i] = datas2[i];
    }
    thisComponentsEntries = pointer;
  } else {
    thisComponentsEntries = 0;
  }
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

void textSizeTable(){
  int columns = tables[table].getColumnCount();
  int rows = tables[table].getRowCount();
  
  textSize(36);
  int[] pointer = new int[columns];
  float[] itemLength = new float[columns];
  
  float totalTextLength = 0;
  for(int i = 0; i < columns; i++){
    pointer[i] = -1;
    itemLength[i] = textWidth(cNames[table][i])+pad*4;
    for(int j = 0; j < rows; j++){
      if(textWidth(tables[table].getString(j,cNames[table][i]))+pad*4 > itemLength[i]){
        itemLength[i] = textWidth(tables[table].getString(j,cNames[table][i]))+pad*4;
        pointer[i] = j;
      }
    }
    totalTextLength += itemLength[i];
  }
  
  int pointer2 = 0;
  float itemLength2 = 0;
  
  cXs[table][0] = 0;
  for(int i = 0; i < columns; i++){
    float cWidth = itemLength[i]*width/totalTextLength;
    cXs[table][i+1] = cXs[table][i] + cWidth;
    if(itemLength[i] > itemLength2){
      itemLength2 = itemLength[i];
      pointer2 = i;
    }
  }
  
  if(pointer[pointer2] > -1){
    tableTextSize = resizeText(tables[table].getString(pointer[pointer2],cNames[table][pointer2]),itemLength[pointer2]*width/totalTextLength,2);
  } else {
    tableTextSize = resizeText(cNames[table][pointer2],itemLength[pointer2]*width/totalTextLength,2);
  }
  
  textSize(tableTextSize);
  
  rowH = 1.5*(textAscent()+textDescent());
  
  newBackground();
}

void drawTable(){
  
  int tempClickX = 0;
  int tempClickY = 0;
  int columns = tables[table].getColumnCount();
  int rows = tables[table].getRowCount();
  
  noStroke();
  fill(lightC);
  rect(0,0,width,rowH*(rows+2));
  fill(darkC);
  rect(0,0,width,rowH*2);
  
  stroke(lineC);
  strokeWeight(2);
  textAlign(LEFT,CENTER);
  fill(textC);
  textSize(tableTextSize);
  
  for(int i = 0; i < columns; i++){
    if(i > 0){
      line(cXs[table][i],0,cXs[table][i],rowH*(rows+2));
      if(mouseX>cXs[table][i]){
        tempClickX++;
      }
    }
    text(cNames[table][i],cXs[table][i]+pad,rowH);
  }
  
  TableRow newRow;
  for(int i = 0; i < rows; i++){
    for(int j = 0; j < columns; j++){
      if(cActions[0][j] == -1){
        fill(textC);
      } else {
        fill(darkC);
      }
      text(tables[table].getString(i,cNames[table][j]),cXs[table][j]+pad,rowH*(2.5+i));
    }
    if(i > 0){
      if(mouseY>rowH*(i+2)){
        tempClickY++;
      }
    }
    line(0,rowH*(i+2),width,rowH*(i+2));
  }
  line(0,rowH*(rows+2),width,rowH*(rows+2));
  
  if(tableClick){
    if(mouseX > 0 && mouseX < width){
      if(mouseY > rowH*2 && mouseY < rowH*(rows+2)){
        if(cActions[table][tempClickX]!=-1){
          tableClick(cActions[table][tempClickX],tempClickY);
        }
      }
    }
    tableClick = false;
  }
}

void tableClick(int a, int b){
  switch(a){
    case 0:
      //remove module b
      menus[1][2] = "Remove Module "+(b+1);
      menu = 1;
      isMenu = true;
      textSizeMenu();
      break;
    case 1:
      //edit project b
      //loadProject(b);
      if(DocCodeToIndex(getBigDocCode(tables[table].getString(b,"Doc Code")),true)>-1){
        loadProject(DocCodeToIndex(getBigDocCode(tables[table].getString(b,"Doc Code")),true));
      }
      break;
    case 2:
      //remove project b
      menus[1][2] = "Remove Project "+(b+1);
      menu = 1;
      isMenu = true;
      textSizeMenu();
      break;
    case 3:
      //move item b up (may be out of range)
      if(b > 0 && b < thisComponentsEntries){
        modifyComponents("up",b);
      }
      break;
    case 4:
      //move item b down (may be out of range)
      if(b < thisComponentsEntries-1){
        modifyComponents("up",b+1);
      }
      break;
    case 5:
      //remove item b (may not exist)
      if(b < thisComponentsEntries){
        modifyComponents("remove",b);
      }
      break;
    case 6:
      //add to top
      if(b < moduleEntries+1){
        modifyComponents("top",b);
      }
      break;
    case 7:
      //add to bottom
      if(b < moduleEntries+1){
        modifyComponents("bottom",b);
      }
      break;
  }
}
