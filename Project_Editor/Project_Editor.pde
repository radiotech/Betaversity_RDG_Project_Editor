import java.awt.datatransfer.*;
import java.awt.Toolkit;

//Project types:
//SEL = Self Guided
//GLO = Global
//LOC = Local
//CHA = Cheritable Advanced
//CHE = Cheritable

float menuTextSize = 12;
float tableTextSize = 12;
float chatTextSize = 12;
float loginTextSize = 12;
boolean isMenu = false;
boolean isTable = false;
int menu = 0;
int table = 0;
boolean menuClick = false;
boolean tableClick = false;
boolean loginClick = false;
String username = "notAccepted";
String password = "notAccepted";
int clearance = 0;
float pad;

PImage bgImage;
int bgIndex = 0;

color lineC;
color darkC;
color lightC;
color textC;
color fadeC;

void setup(){
  
  lineC = color(31,81,105);//color(86,100,113);//color(102);//color(86,100,113);//color(82,198,234);
  darkC = color(5,97,228);//color(15,175,237);
  lightC = color(96,212,255);//color(129,206,234);//color(178,219,234);//color(82,198,234);
  textC = color(255);//color(49,56,63);
  fadeC = color(255,200);
  
  size(800,600);
  pad = float(width)/200;
  updateMenus();
  updateTables();
  textSizeMenu();
  textSizeChat();
  textSizeLogin();
  
  loadData();
  newBackground();
}

void draw(){
  image(bgImage,0,0,width,height);
  if(!(isMenu == true && isTable == true)){
    fill(fadeC);
    noStroke();
    rect(0,0,width,height);
  }
  
  if(isMenu == true || isTable == true){
    if(isTable){
      drawTable();
    }
    if(isMenu == true && isTable == true){
      fill(fadeC);
      noStroke();
      rect(0,0,width,height);
    }
    drawChat();
    if(isMenu){
      drawMenu();
    }
  } else {
    drawChat();
    drawLogin();
  }
}

void mousePressed(){
  if(isMenu == true || isTable == true){
    if(mouseX > width-messageH*2 && mouseY > height-messageH*2){
      menu = 0;
      isMenu = true;
      textSizeMenu();
    } else {
      if(isMenu){
        menuClick = true;
      } else if(isTable){
        tableClick = true;
      }
    }
  } else {
    loginClick = true;
  }
}

void keyPressed(){
  if(isMenu == true || isTable == true){
    if(key == 'm' || key == 'M'){
      menu = 0;
      isMenu = true;
      textSizeMenu();
    }
  } else {
    if(key!=CODED){
      if(key==BACKSPACE) {
        if(focusedField == 0){
          if(tempUsername.length()>0){
            tempUsername=tempUsername.substring(0, tempUsername.length()-1);
          }
        } else if(focusedField == 1){
          if(tempPassword.length()>0){
            tempPassword=tempPassword.substring(0, tempPassword.length()-1);
          }
        }
      } else if(key==RETURN || key==ENTER) {
        if(focusedField == 0){
          focusedField = 1;
        } else if(focusedField == 1){
          login();
        }
      } else if(key == TAB){
        if(focusedField == 0){
          focusedField = 1;
        }
      } else {
        if(focusedField == 0){
          tempUsername = tempUsername+key;
        } else if(focusedField == 1){
          tempPassword = tempPassword+key;
        }
      }
    }
  }
}


String DocCodeToName(String a, boolean b){
  for(int i = 0; i < allEntries; i++){
    if(allDocCode[i].equals(a)){
      if(b){
        if(allIsModule[i].equals("1")){
          return allName[i];
        }
      } else {
        return allName[i];
      }
    }
  }
  if(allDocCode[thisEntry].equals(a)){
    return "Project Description";
  }  
  return "Error 404";
}

int DocCodeToIndex(String a, boolean b){
  for(int i = 0; i < allEntries; i++){
    if(allDocCode[i].equals(a)){
      if(b){
        if(allIsModule[i].equals("0")){
          return i;
        }
      } else {
        return i;
      }
    }
  }
  return -1;
}

String getTinyDocCode(String a){
  if(a.length()<15){
    return a;
  } else {
    return a.substring(0,10)+"...";
  }
}
String getBigDocCode(String a){
  if(a.length()==13){
    for(int i = 0; i < allEntries; i++){
      if(getTinyDocCode(allDocCode[i]).equals(a)){
        return allDocCode[i];
      }
    }
  }
  return "Doc Code Error";
}

void modifyComponents(String a, int b){
  if(a.equals("remove")){
    String data = allComponents[thisEntry];
    String[] datas = split(data,",");
    int pointer = 0;
    data = "";
    for(int i = 0; i < datas.length; i++){
      if(datas[i].indexOf("---") == -1){
        if(pointer == b){
          datas[i] = "---"+datas[i];
        }
        pointer++;
      }
      if(i > 0){
        data = data+","+datas[i];
      } else {
        data = datas[i];
      }
    }
    allComponents[thisEntry] = data;
  } else if(a.equals("up")){
    String data = allComponents[thisEntry];
    String[] datas = split(data,",");
    int otherPointer = 0;
    int pointer = 0;
    for(int i = 0; i < datas.length; i++){
      if(datas[i].indexOf("---") == -1){
        if(otherPointer == b){
          String tempStr = datas[pointer];
          datas[pointer] = datas[i];
          datas[i] = tempStr;
        }
        pointer = i;
        otherPointer++;
      }
    }
    data = "";
    for(int i = 0; i < datas.length; i++){
      if(i > 0){
        data = data+","+datas[i];
      } else {
        data = datas[i];
      }
    }
    allComponents[thisEntry] = data;
  } else if(a.equals("top")){
    if(b == 0){
      allComponents[thisEntry] = allDocCode[thisEntry] + "," + allComponents[thisEntry];
    } else {
      allComponents[thisEntry] = moduleDocCode[b-1] + "," + allComponents[thisEntry];
    }
  } else if(a.equals("bottom")){
    if(b == 0){
      allComponents[thisEntry] = allComponents[thisEntry] + "," + allDocCode[thisEntry];
    } else {
      allComponents[thisEntry] = allComponents[thisEntry] + "," + moduleDocCode[b-1];
    }
  }
  
  if(allComponents[thisEntry].length()>0){
    if((allComponents[thisEntry].substring(0,1)).equals(",")){
      allComponents[thisEntry] = allComponents[thisEntry].substring(1,allComponents[thisEntry].length());
    } else if((allComponents[thisEntry].substring(allComponents[thisEntry].length()-1,allComponents[thisEntry].length())).equals(",")){
      allComponents[thisEntry] = allComponents[thisEntry].substring(0,allComponents[thisEntry].length()-1);
    }
  }
  
  updateComponents(allDocCode[thisEntry],allComponents[thisEntry]);
  
  loadData();
  loadProject(thisEntry);
}

boolean addEntry(String a, boolean b){
  a = trim(a);
  String[] data = split(a," ");
  if(b == true && data.length != 3){
    messages.add(new Message("Modules should have 2 spaces"));
    return false;
  } else if(b == false && data.length != 4){
    messages.add(new Message("Projects should have 3 spaces"));
    return false;
  }
  if(b == true && !data[0].equals("Module")){
    messages.add(new Message("Modules should have the word \"Module\" before their first space"));
    return false;
  } else if(b == false && !data[1].equals("Project")){
    messages.add(new Message("Projects should have the word \"Project\" after their first space"));
    return false;
  }
  
  String tempDocCode;
  
  if(b){
    tempDocCode = data[2];
  } else {
    tempDocCode = data[3];
  }
  
  tempDocCode = trim(tempDocCode);
  if(tempDocCode.indexOf("(") == -1 || tempDocCode.indexOf(")") == -1){
    messages.add(new Message("There should be parentheses around the document publish code"));
    return false;
  }
  tempDocCode = tempDocCode.substring(1,tempDocCode.length()-1);
  if(tempDocCode.indexOf("(") != -1 || tempDocCode.indexOf(")") != -1){
    messages.add(new Message("There should not be parentheses inside your document publish code"));
    return false;
  }
  
  for(int i = 0; i < allEntries; i++){
    if(allDocCode[i] == tempDocCode){
      messages.add(new Message("That document code is already in use"));
      return false;
    }
  }
  
  String tempContents = "";
  for(int i = 0; i < removedIsModule.length; i++){
    if(removedDocCode[i].equals(tempDocCode)){
      if(int(removedIsModule[i]) == 0){
        tempContents = removedComponents[i];
      }
      if(deleteFromDocCode(tempDocCode) == false){
        messages.add(new Message("An entry existed before with the same document code"));
        messages.add(new Message("The above error occured when attempting to delete it"));
        return false;
      }
    }
  }
  
  if(b == false){
    if(convertType(data[0]) == -1){
      messages.add(new Message("Project type can only be \"SOL,\" \"GLO,\" \"LOC,\" \"CHA,\" or \"CHE\""));
      messages.add(new Message("(Solo, Globally Marketed, Locally Marketed, Charitable Advanced, Cheritable)"));
      return false;
    }
  }
  
  
  String[] dat;
  if(b){
    dat = loadStrings("http://harvway.com/BetaBox/API/addItem.php?u="+username+"&p="+password+"&n="+data[1]+"&i=1&t=-1&d="+tempDocCode+"&c=");
  } else {
    dat = loadStrings("http://harvway.com/BetaBox/API/addItem.php?u="+username+"&p="+password+"&n="+data[2]+"&i=0&t="+convertType(data[0])+"&d="+tempDocCode+"&c="+tempContents);
  }
  if(dat == null){
    messages.add(new Message("Could not connect to the Harvway/Betaversity servers"));
    return false;
  }
  if(dat.length == 1){
    if(dat[0].equals("Success")){
      messages.add(new Message("Your item was added successfully"));
      if(b){
        loadModules();
      } else {
        loadProjects();
      }
      isTable = true;
      isMenu = false;
      return true;
    } else {
      messages.add(new Message("Add item failed; The server returnd the following line:"));
      messages.add(new Message(dat[0]));
      return false;
    }
  } else {
    messages.add(new Message("Add item failed; The server returnd the following lines:"));
    for(int i = 0; i < dat.length; i++){
      messages.add(new Message(dat[i]));
    }
    return false;
  }
  
}

boolean deleteFromDocCode(String a){
  println(a);
  String[] dat = loadStrings("http://harvway.com/BetaBox/API/deleteItem.php?u="+username+"&p="+password+"&d="+a);
  if(dat == null){
    messages.add(new Message("Could not connect to the Harvway/Betaversity servers"));
    return false;
  }
  if(dat.length == 1){
    if(dat[0].equals("Success")){
      messages.add(new Message("Successfully cleared the doc code "+a));
      return true;
    } else {
      messages.add(new Message("Clear doc code failed; The server returnd the following line:"));
      messages.add(new Message(dat[0]));
      return false;
    }
  } else {
    messages.add(new Message("Clear doc code failed; The server returnd the following lines:"));
    for(int i = 0; i < dat.length; i++){
      messages.add(new Message(dat[i]));
    }
    return false;
  }
}

boolean removeFromDocCode(String a){
  String[] dat = loadStrings("http://harvway.com/BetaBox/API/removeItem.php?u="+username+"&p="+password+"&d="+a);
  if(dat == null){
    messages.add(new Message("Could not connect to the Harvway/Betaversity servers"));
    return false;
  }
  if(dat.length == 1){
    if(dat[0].equals("Success")){
      messages.add(new Message("Item removed successfully"));
      return true;
    } else {
      messages.add(new Message("Remove item failed; The server returnd the following line:"));
      messages.add(new Message(dat[0]));
      return false;
    }
  } else {
    messages.add(new Message("Remove item failed; The server returnd the following lines:"));
    for(int i = 0; i < dat.length; i++){
      messages.add(new Message(dat[i]));
    }
    return false;
  }
}

boolean updateComponents(String a,String b){
  String[] dat = loadStrings("http://harvway.com/BetaBox/API/updateComponents.php?u="+username+"&p="+password+"&d="+a+"&c="+b);
  if(dat == null){
    messages.add(new Message("Could not connect to the Harvway/Betaversity servers"));
    return false;
  }
  if(dat.length == 1){
    if(dat[0].equals("Success")){
      messages.add(new Message("Operation preformed successfully"));
      return true;
    } else {
      messages.add(new Message("Update project failed; The server returnd the following line:"));
      messages.add(new Message(dat[0]));
      return false;
    }
  } else {
    messages.add(new Message("Update project failed; The server returnd the following lines:"));
    for(int i = 0; i < dat.length; i++){
      messages.add(new Message(dat[i]));
    }
    return false;
  }
}

int convertType(String a){
  if(a.equals("SOL")){
    return 0;
  } else if(a.equals("GLO")){
    return 1;
  } else if(a.equals("LOC")){
    return 2;
  } else if(a.equals("CHA")){
    return 3;
  } else if(a.equals("CHE")){
    return 4;
  }
  return -1;
}

float resizeText(String a, float b, float c){
  int pointer = 12;
  float distance = b;
  for(int i = 1; i < 100; i++){
    textSize(i);
    if(textWidth(a)<b-pad*c*2){
      if((b-pad*c*2)-textWidth(a)<distance){
        distance = (b-pad*c*2)-textWidth(a);
        pointer = i;
      }
    }
  }
  return pointer;
}

String trimChars(String a, float b){
  String myReturn = "";
  for(int i = 0; i < a.length(); i++){
    if(textWidth(a.substring(0,i+1)) < b){
      myReturn = a.substring(0,i+1);
    }
  }
  return myReturn;
}

String obscureText(String a, boolean b){
  String myReturn = "";
  for(int i = 0; i < a.length(); i++){
    if(i+1<a.length() || b==false){
      myReturn = myReturn + "•";
    } else {
      if((a.substring(a.length()-1,a.length())).equals("|")){
        myReturn = myReturn + "|";
      } else {
        myReturn = myReturn + "•";
      }
    }
  }
  return myReturn;
}

void newBackground(){
  int newIndex = 1;//= bgIndex;
  int rs = 0;
  if(isTable){
    if(isMenu){
      rs = tables[table].getColumnCount()+int(menus[menu][0])+3;
    } else {
      rs = tables[table].getColumnCount()+2;
    }
  } else if(isMenu) {
    rs = int(menus[menu][0])+1;
  } else {
    rs = 0;
  }
  randomSeed(rs);
  //println(rs);
  bgIndex = floor(random(0,500)%5);
  //println(bgIndex);
  bgImage = loadImage("bg"+bgIndex+".jpg");
}

String[] cutItem(String[] a, int b){
  if(b > -1 && b < a.length){
    if(b == a.length-1){
      return subset(a,0,b);
    } else if(b == 0){
      return subset(a,1,a.length-1);
    } else {
      return concat(subset(a,0,b),subset(a,b+1,a.length-b-1));
    }
  } else {
    return a;
  }
}


