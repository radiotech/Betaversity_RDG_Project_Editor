String[][] menus = new String[2][10];
float menuHPad = 10;
float menuVPad = 10;

void updateMenus(){
  menus[0][0] = "5";
  menus[0][1] = "View Projects";
  menus[0][2] = "New Project";
  menus[0][3] = "View Modules";
  menus[0][4] = "New Module";
  menus[0][5] = "Exit";
  menus[1][0] = "2";
  menus[1][1] = "Cancel";
  //menus[1][2] = "[Error]"; Is not changed when updateMenus() is called
}

void textSizeMenu(){
  textSize(36);
  int pointer = 0;
  float itemLength = 0;
  for(int i = 0; i < int(menus[menu][0]); i++){
    if(textWidth(menus[menu][i+1]) > itemLength){
      itemLength = textWidth(menus[menu][i+1]);
      pointer = i;
    }
  }
  menuTextSize = resizeText(menus[menu][pointer+1],(width-width/8)/2,5);
  
  textSize(menuTextSize);
  
  menuHPad = float(height)/16;
  menuVPad = max(float(width)/16,(height-int(menus[menu][0])*1.5*(textAscent()+textDescent()))/2);
  
  newBackground();
}

void drawMenu(){
  
  int tempClick = 0;
  int items = int(menus[menu][0]);
  int rows = ceil(float(items)/2);
  
  textAlign(CENTER,CENTER);
  rectMode(CORNERS);
  stroke(lineC);
  strokeWeight(2);
  fill(lightC);
  rect(menuHPad,menuVPad,width-menuHPad,height-menuVPad);
  
  line(width/2,menuVPad,width/2,height-menuVPad);
  
  fill(textC);
  textSize(menuTextSize);
  for(int i = 0; i < items; i++){
    if(i > 0 && i <= rows){
      line(menuHPad,menuVPad+(height-menuVPad*2)*i/rows,width-menuHPad,menuVPad+(height-menuVPad*2)*i/rows);
      if(mouseY > menuVPad+(height-menuVPad*2)*i/rows){
        tempClick+=2;
      }
    }
    text(menus[menu][i+1],menuHPad+(width-menuHPad*2)/2/2+i%2*(width-menuHPad*2)/2,menuVPad+(height-menuVPad*2)/rows/2+(height-menuVPad*2)*floor(i/2)/rows);
  }
  
  
  if(menuClick){
    if(mouseX > menuHPad && mouseX < width-menuHPad){
      if(mouseY > menuVPad && mouseY < height-menuVPad){
        if(mouseX > width/2){
          tempClick++;
        }
        menuClick(menu, tempClick);
      }
    }
    menuClick = false;
  }
}

void menuClick(int a, int b){
  switch(a*100+b){
    case 0:
      //view projects
      loadProjects();
      isMenu = false;
      isTable = true;
      break;
    case 1:
      //add project
      menus[1][2] = "Paste Project Data";
      menu = 1;
      textSizeMenu();
      break;
    case 2:
      //view modules
      loadModules();
      isMenu = false;
      isTable = true;
      break;
    case 3:
      //add module
      menus[1][2] = "Paste Module Data";
      menu = 1;
      textSizeMenu();
      break;
    case 4:
      //exit
      exit();
      break;
    case 100:
      //cancel new entry
      if(menus[1][2].equals("Paste Project Data") || menus[1][2].equals("Paste Module Data")){
        menu = 0;
        textSizeMenu();
      } else if(menus[1][2].indexOf("Remove Project") != -1 || menus[1][2].indexOf("Remove Module") != -1){
        isMenu = false;
      }
      break;
    case 101:
      //insert new entry
      String clipboard;
      try {
        clipboard = trim((String)Toolkit.getDefaultToolkit().getSystemClipboard().getContents(null).getTransferData(DataFlavor.stringFlavor));
      } catch(Exception e){
        clipboard = "false";
        messages.add(new Message("Make sure that you copied the Document Title"));
        println(e);
      }
      if(menus[1][2].equals("Paste Project Data")){
        if(addEntry(clipboard,false) == false){
          messages.add(new Message("Project Document Title Format:"));
          messages.add(new Message("ABC Project Spaceless_Project_Name (abc123-Publish-Doc-Code-321cba)"));
        }
      } else if(menus[1][2].equals("Paste Module Data")){
        if(addEntry(clipboard,true) == false){
          messages.add(new Message("Module Document Title Format:"));
          messages.add(new Message("Module Spaceless_Module_Name (abc123-Publish-Doc-Code-321cba)"));
        }
      } else if(menus[1][2].indexOf("Remove Project") != -1){
        removeFromDocCode(getBigDocCode(tables[table].getString((int(menus[1][2].replace("Remove Project ",""))-1),"Doc Code")));
        isMenu = false;
        loadProjects();
      } else if(menus[1][2].indexOf("Remove Module") != -1){
        removeFromDocCode(getBigDocCode(tables[table].getString((int(menus[1][2].replace("Remove Module ",""))-1),"Doc Code")));
        isMenu = false;
        loadModules();
      }
      break;
  }
}
