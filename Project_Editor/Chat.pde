
float messageH = 30;

ArrayList<Message> messages = new ArrayList<Message>();

void textSizeChat(){
  chatTextSize = resizeText("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM",width,0);
  textSize(chatTextSize);
  messageH = 1.5*(textAscent()+textDescent());
}


void drawChat(){
  
  textSize(chatTextSize);
  noStroke();
  textAlign(LEFT,CENTER);
  for (int i = 0; i < messages.size(); i++) {
    if(messages.get(i).display(messages.size()-i-1) == false){
      messages.remove(i);
      i--;
    }
  }
  
  if(isMenu == true || isTable == true){
    if(isMenu == false || menu != 0){
      fill(lightC);
      rect(width-messageH*2,height-messageH*2,width+messageH*2,height+messageH*2,messageH/2);
      stroke(textC);
      strokeWeight(4);
      rect(width-1.6*messageH,height-1.6*messageH,width-.4*messageH,height-.4*messageH,messageH/3);
    }
  }
}

class Message {
  
  int millis;
  String messageText;
  
  Message(String a){
    millis = millis()+10000;
    messageText = a;
  }
  
  boolean display(int a){
    float alpha = min(1,float(millis-millis())/1000);
    
    fill(lightC,alpha*200);
    rect(-messageH,height-(a+1)*messageH,textWidth(messageText)+pad*4,height-a*messageH,messageH/3);
    fill(textC,alpha*255);
    text(messageText,pad*2,height-(.5+a)*messageH);
    if(millis()>millis){
      return false;
    }
    return true;
  }
  
}
