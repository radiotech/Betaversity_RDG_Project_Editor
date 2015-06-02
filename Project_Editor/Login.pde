float boxStartX = 0;
String tempUsername = "";
String tempPassword = "";
int focusedField = 0;

void textSizeLogin(){
  loginTextSize = resizeText("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM",width,0);
  textSize(loginTextSize);
  messageH = 1.5*(textAscent()+textDescent());
  
  menuHPad = float(height)/16;
  menuVPad = (height-messageH*6.5)/2;
  
  boxStartX = max(textWidth("User Name:"),textWidth("Password:"))+menuHPad*3;
}

void drawLogin(){
  
  textSize(loginTextSize);
  rectMode(CORNERS);
  stroke(lineC);
  strokeWeight(2);
  
  fill(darkC);
  rect(menuHPad,menuVPad,width-menuHPad,height-menuVPad);
  
  strokeWeight(1);
  fill(lightC);
  rect(boxStartX,menuVPad+(2)*messageH,width-menuHPad*2,menuVPad+(3)*messageH);
  rect(boxStartX,menuVPad+(3.5)*messageH,width-menuHPad*2,menuVPad+(4.5)*messageH);
  rect(width/2-(textWidth("Log In")+pad*2),menuVPad+(5)*messageH,width/2+(textWidth("Log In")+pad*2),menuVPad+(6)*messageH);
  
  fill(textC);
  textAlign(CENTER,CENTER);
  text("BetaBox Project Editor",width/2,menuVPad+(1)*messageH);
  text("Log In",width/2,menuVPad+(5.5)*messageH);
  textAlign(LEFT,CENTER);
  text("User Name:",menuHPad*2,menuVPad+(2.5)*messageH);
  text("Password:",menuHPad*2,menuVPad+(4)*messageH);
  
  //resize text to fit
  
  String tempUsername2 = tempUsername;
  String tempPassword2 = tempPassword;
  
  if(millis()/500%2==0){
    if(focusedField == 0){
      tempUsername2 = tempUsername2+"|";
    } else if(focusedField == 1){
      tempPassword2 = tempPassword2+"|";
    }
  }
  
  text(trimChars(tempUsername2,((width-menuHPad*2)-boxStartX)-pad*4),boxStartX+pad*2,menuVPad+(2.5)*messageH);
  text(trimChars(obscureText(tempPassword2,true),((width-menuHPad*2)-boxStartX)-pad*4),boxStartX+pad*2,menuVPad+(4)*messageH);
  
  if(loginClick){
    if(mouseX > boxStartX && mouseX < width-menuHPad*2){
      if(mouseY > menuVPad+(2)*messageH && mouseY < menuVPad+(4.5)*messageH){
        if(mouseY < menuVPad+(3)*messageH){
          focusedField = 0;
        }
        if(mouseY > menuVPad+(3.5)*messageH){
          focusedField = 1;
        }
      }
    }
    if(mouseX > width/2-(textWidth("Log In")+pad*2) && mouseX < width/2+(textWidth("Log In")+pad*2)){
      if(mouseY > menuVPad+(5)*messageH && mouseY < menuVPad+(6)*messageH){
        login();
      }
    }
    
    loginClick = false;
  }
  /*
  String tempUsername = "";
  String tempPassword = "";
  int focusedField = 0;
  */
}

boolean login(){
  //messages.add(new Message("Attempting to log in with "+tempUsername+" and "+tempPassword));
  String[] dat = loadStrings("http://harvway.com/BetaBox/API/checkLogin.php?u="+tempUsername+"&p="+tempPassword);
  if(dat == null){
    messages.add(new Message("Login failed; Unable to connect to the login server"));
    return false;
  }
  if(dat.length == 1){
    if(dat[0].indexOf("Success ") == 0){
      clearance = int(dat[0].replace("Success ",""));
      if(clearance > 0){
        messages.add(new Message("Login successful; You are now logged in as \""+tempUsername+"\" with a clearance level of "+clearance));
        username = tempUsername;
        password = tempPassword;
        isMenu = true;
        textSizeMenu();
        return true;
      } else {
        messages.add(new Message("Login failed; you do not have the proper clearance level to use this program"));
        return false;
      }
    } else {
      messages.add(new Message("Login failed; The server returnd the following line:"));
      messages.add(new Message(dat[0]));
      return false;
    }
  } else {
    messages.add(new Message("Login failed; The server returnd the following lines:"));
    for(int i = 0; i < dat.length; i++){
      messages.add(new Message(dat[i]));
    }
    return false;
  }
}
