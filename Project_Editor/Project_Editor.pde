import java.awt.datatransfer.*;
import java.awt.Toolkit;

String[][] cNames = new String[1][10];
String[][] menus = new String[2][10];
Table[] tables = new Table[1];
int tableIndex = 0;
float rowH = float(1)/20;

boolean isMenu = true;
boolean isTable = false;
int menu = 0;
int table = 0;
boolean menuClick = false;
boolean tableClick = false;

void setup(){
  size(600,400);
  updateMenus();
  updateTables();
}

void draw(){
  background(255);
  if(isTable){
    drawTable(table);
  }
  if(isMenu){
    drawMenu(menu);
  }
}

void mousePressed(){
  if(isMenu){
    menuClick = true;
  } else if(isTable){
    tableClick = true;
  }
}
