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

void drawMenu(int a){
  
  int tempClick = 0;
  int items = int(menus[a][0]);
  int rows = ceil(float(items)/2);
  
  textAlign(CENTER,CENTER);
  rectMode(CORNERS);
  stroke(0);
  strokeWeight(2);
  fill(200);
  rect(width/16,height/16,width*15/16,height*15/16);
  
  line(width/2,height/16,width/2,height*15/16);
  
  fill(0);
  for(int i = 0; i < items; i++){
    if(i > 0 && i <= rows){
      line(width/16,height/16+height*14*i/16/rows,width*15/16,height/16+height*14*i/16/rows);
      if(mouseY > height/16+height*14*i/16/rows){
        tempClick+=2;
      }
    }
    text(menus[a][i+1],width/16+width*14/16/2/2+i%2*width*14/2/16,height/16+height*14/16/rows/2+height*14*floor(i/2)/16/rows);
  }
  
  
  if(menuClick){
    if(mouseX > width/16 && mouseX < width*15/16){
      if(mouseY > height/16 && mouseY < height*15/16){
        if(mouseX > width/2){
          tempClick++;
        }
        menuClick(a, tempClick);
      }
    }
    menuClick = false;
  }
}

void menuClick(int a, int b){
  switch(a*100+b){
    case 0:
      //view projects
      break;
    case 1:
      //add project
      menus[1][2] = "Paste Project Data";
      menu = 1;
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
      break;
    case 4:
      //exit
      exit();
      break;
    case 100:
      //cancel new entry
      menu = 0;
      break;
    case 101:
      //insert new entry
      String clipboard;
      try {
        clipboard = (String)Toolkit.getDefaultToolkit().getSystemClipboard().getContents(null).getTransferData(DataFlavor.stringFlavor);
      } catch(Exception e){
        clipboard = "false";
        println(e);
      }
      if(menus[1][2].equals("Paste Project Data")){
        
      } else if(menus[1][2].equals("Paste Module Data")){
        
      }
      break;
  }
}
