import processing.net.*;
import java.util.Arrays;
import java.util.Collections;
Client myClient;
Player redPlayer = null;
Player yellowPlayer = null;
Player greenPlayer = null;
Player bluePlayer = null;
Player youPlayer = null;
Player[] playerList = new Player[5];
ArrayList<Order> orderHistory = new ArrayList<Order>();
PImage background;
PFont bold, regular;
ArrayList<Order> spadeOrders = new ArrayList<Order>();
ArrayList<Order> clubOrders = new ArrayList<Order>();
ArrayList<Order> diamondOrders = new ArrayList<Order>();
ArrayList<Order> heartOrders = new ArrayList<Order>();
ArrayList<Button> buttonList = new ArrayList<Button>();
color mainColor = color(0, 0, 0);
boolean DARK = true;
boolean synced = true;
boolean swapped = false;
String globalMsg = "Awaiting messages...";

int editIndex = -1;
String editTemp;

final static boolean DEV = false;


void setup() {
  //fullScreen();
  size(1180, 750);
  //size(10, 10);
  background = loadImage("Figgie Bot Background.png");
  bold = createFont("Nunito-Bold.ttf", 24);
  regular = createFont("Nunito-Regular.ttf", 24);
  noStroke();
  myClient = new Client(this, "127.0.0.1", 9090);
  youPlayer = new Player("YOU", "YOU");
  playerList[4] = youPlayer;
  if (DEV) {
    redPlayer = new Player("Player 1", "Red");
    playerList[0] = redPlayer;
    yellowPlayer = new Player("Player 2", "Yellow");
    playerList[1] = yellowPlayer;
    greenPlayer = new Player("Player 3", "Green");
    playerList[2] = greenPlayer;
    bluePlayer = new Player("Player 4", "Blue");
    playerList[3] = bluePlayer;
  }

  if (DARK) {
    mainColor = color(255, 255, 255);
    background = loadImage("Figgie Bot Background Dark.png");
  }

  buttonList.add(new Button(885, 518, "New Round", 0));
  buttonList.add(new Button(1033, 518, "Count Cards", 1));
  buttonList.add(new Button(885, 584, "Load Players", 2));
  buttonList.add(new Button(1033, 584, "Swap Colors", 3));
}

void draw() {
  image(background, 0, 0);
  if (!DEV) {
    String msg = myClient.readString();
    if (msg != null && !(msg.contains("Game") || msg.contains("Settings")) && !msg.contains("Payout") && !msg.contains("Trade Log")) {
      globalMsg = msg;
      parseMsg(msg);
    }
  }
  int index = 0;
  for (Player player : playerList) {
    if (player!= null) {
      //trades charts
      ArrayList[] data = {player.spades.getBuys(), player.spades.getSells(), player.clubs.getBuys(), player.clubs.getSells(),
        player.diamonds.getBuys(), player.diamonds.getSells(), player.hearts.getBuys(), player.hearts.getSells()};
      float x = 133+271*index;
      float y = 74.3; //top of bar at max height
      drawBarChart(data, x, y, true);

      //bids/offers charts
      ArrayList[] data2 = {player.spades.getBids(), player.spades.getOffers(), player.clubs.getBids(), player.clubs.getOffers(),
        player.diamonds.getBids(), player.diamonds.getOffers(), player.hearts.getBids(), player.hearts.getOffers()};
      x = 133+271*index;
      y = 283;
      drawBarChart(data2, x, y, false);
      index++;
    }
  }
  drawTable();
  drawCounter();
  drawNames();
  if (!synced) {
    drawBorder();
  }
  drawButtons();
  drawConnectionStatus();
}


void keyPressed() {
  
  if (editIndex != -1) {
   Player player = playerList[editIndex];
    if (key == RETURN || key == ENTER) {
    player.name = player.name.substring(0, player.name.indexOf("|"));
    editIndex = -1;
  }
  else if (key == DELETE || key == BACKSPACE) {
     if (player.name.length() > 1){
    player.name = player.name.substring(0, player.name.indexOf("|")-1) + "|";
     }
  }
  else if (keyCode == SHIFT) {
    
  }
  else {
    player.name = player.name.substring(0, player.name.indexOf("|")) + key + "|";
  }

  }
  
}

private void parseMsg(String msg) {
  synced = true;
  println(msg);
  if (msg.substring(0, 3).equals("R: ")) {
    redPlayer = new Player(msg.substring(3), "Red");
    playerList[0] = redPlayer;
  } else if (msg.substring(0, 3).equals("Y: ")) {
    yellowPlayer = new Player(msg.substring(3), "Yellow");
    playerList[1] = yellowPlayer;
  } else if (msg.substring(0, 3).equals("G: ")) {
    greenPlayer = new Player(msg.substring(3), "Green");
    playerList[2] = greenPlayer;
  } else if (msg.substring(0, 3).equals("B: ")) {
    bluePlayer = new Player(msg.substring(3), "Blue");
    playerList[3] = bluePlayer;
  } else if (msg.substring(0, 3).equals("M: ")) {
    youPlayer = new Player(msg.substring(3), "YOU");
    playerList[4] = youPlayer;
  } else if (msg.equals("NOT SYNCED")) {
    synced = false;
  } else if (msg.equals("SYNCED")) {
    synced = true;
  } else if (msg.substring(0, 6).equals("Cards:")) {
    String[] parts = msg.split(":");
    try{
    youPlayer.numSpades += Integer.parseInt(parts[1]);
    youPlayer.numClubs += Integer.parseInt(parts[2]);
    youPlayer.numDiamonds += Integer.parseInt(parts[3]);
    youPlayer.numHearts += Integer.parseInt(parts[4]);
    }
    catch (Exception e){
      println("Count Cards Error");
      globalMsg = "ERROR COUNTING CARDS";
    }
    
  } else { //trade message
    Order order = new Order(msg, playerList);
    globalMsg = order.toString();
    orderHistory.add(order);

    if (order.type.equals("buy") || order.type.equals("sell")) {
      if (order.suit.equals("spades")) {
        spadeOrders.add(order);
      } else if (order.suit.equals("clubs")) {
        clubOrders.add(order);
      } else if (order.suit.equals("diamonds")) {
        diamondOrders.add(order);
      } else if (order.suit.equals("hearts")) {
        heartOrders.add(order);
      }
    }


    for (Player player : playerList) {
      if (player != null) {
        player.process(order);
      }
    }
  }
}

void mouseClicked() {
  int output = -1;
  for (Button button : buttonList) {
    output = Math.max(output, button.click(mouseX, mouseY));
  }

  if (output == 0) {//new round
    if (redPlayer != null) {
      redPlayer = new Player(redPlayer.name, "Red");
      playerList[0] = redPlayer;
    }
    if (yellowPlayer != null) {
      yellowPlayer = new Player(yellowPlayer.name, "Yellow");
      playerList[1] = yellowPlayer;
    }
    if (greenPlayer != null) {
      greenPlayer = new Player(greenPlayer.name, "Green");
      playerList[2] = greenPlayer;
    }
    if (bluePlayer != null) {
      bluePlayer = new Player(bluePlayer.name, "Blue");
      playerList[3] = bluePlayer;
    }
    youPlayer = new Player(youPlayer.name, "YOU");
    playerList[4] = youPlayer;
    orderHistory = new ArrayList<Order>();
    spadeOrders = new ArrayList<Order>();
    clubOrders = new ArrayList<Order>();
    diamondOrders = new ArrayList<Order>();
    heartOrders = new ArrayList<Order>();
  } else if (output == 1) {// count cards
    myClient.write("COUNT CARDS");
  } else if (output == 2) {//load players
    redPlayer = null;
    yellowPlayer = null;
    greenPlayer = null;
    bluePlayer = null;
    youPlayer = new Player("YOU", "YOU");
    playerList = new Player[5];
    playerList[4] = youPlayer;
    orderHistory = new ArrayList<Order>();
    spadeOrders = new ArrayList<Order>();
    clubOrders = new ArrayList<Order>();
    diamondOrders = new ArrayList<Order>();
    heartOrders = new ArrayList<Order>();
    myClient.write("LOAD PLAYERS");
    println("LOAD PLAYERS SENT");
  } else if (output == 3) {// swap colors
    if (swapped == false) {
      swapped = true;
      Player[] newPlayerList = new Player[5];
      newPlayerList[0] = playerList[2];
      newPlayerList[1] = playerList[3];
      newPlayerList[2] = playerList[1];
      newPlayerList[3] = playerList[0];
      newPlayerList[4] = playerList[4];
      if (playerList[3] == null) {
        newPlayerList[1] = playerList[4];
      }
      playerList = newPlayerList;
      background = loadImage("Figgie Bot Background Swapped.png");
    } else {
      swapped = false;
      Player[] newPlayerList = new Player[5];
      newPlayerList[2] = playerList[0];
      newPlayerList[3] = playerList[1];
      newPlayerList[1] = playerList[2];
      newPlayerList[0] = playerList[3];
      newPlayerList[4] = playerList[4];
      playerList = newPlayerList;
      background = loadImage("Figgie Bot Background Dark.png");
    }
  }
  if (editIndex == -1){
  for (int i = 0; i < 4; i++) {
    int x = 105+i*271;
    int y = 27;
    if (x < mouseX && mouseX < x+238 && y < mouseY && mouseY < y+36) {
      if (playerList[i] != null) {
        editIndex = i;
        playerList[i].name = "|";
      }
      else if (i == 3) {//for case where there are 4 players
        editIndex = 4; 
        playerList[4].name = "|";
      }
  }
    
}
int x = 910;
    int y =672;
    if (x < mouseX && mouseX < x+270 && y < mouseY && mouseY < y+32) {
      editIndex = 4;
      playerList[4].name = "|";
    }
  }
}

public void drawBarChart(ArrayList[] data, float startX, float startY, boolean drawMidText) {


  float maxHeight = 90.0;

  for (int i = 0; i < 8; i+=2)
  {

    // middle text
    if (drawMidText) {
      //top
      fill(#2DFE54);
      int x = i/2*52;
      float rectHeight = maxHeight*data[i].size()/8;
      rect(startX+x, startY+maxHeight-rectHeight, 30, rectHeight);

      //bottom
      fill(#DD0000);
      int y = 126;
      rectHeight = maxHeight*data[i+1].size()/8;
      rect(startX+x, startY+y, 30, rectHeight);

      fill(mainColor);
      textFont(regular);
      textSize(22);
      textAlign(RIGHT);
      text((int)(data[i].size()-data[i+1].size()), startX+x+8, startY+maxHeight+27);

      //bar text
      textAlign(CENTER);
      textSize(24);
      text(data[i].size(), startX+x+15, startY+(maxHeight)/2+5);
      text(data[i+1].size(), startX+x+15, startY+y+(maxHeight)/2+5);
    } else {
      //top
      fill(#2DFE54);
      int x = i/2*52;
      float rectHeight = maxHeight*data[i].size()/10;
      rect(startX+x, startY+maxHeight-rectHeight, 30, rectHeight);

      //bottom
      fill(#DD0000);
      int y = 126;
      rectHeight = maxHeight*data[i+1].size()/10;
      rect(startX+x, startY+y, 30, rectHeight);

      fill(mainColor);
      textFont(regular);
      text(Integer.toString(median(data[i])), startX+x+15, startY+(maxHeight)/2+5);
      text(Integer.toString(median(data[i+1])), startX+x+15, startY+y+(maxHeight)/2+5);
    }
  }
}

public void drawTable() {
  for (int i = 0; i < 4; i++) {
    fill(mainColor);
    textFont(regular);
    textSize(26);
    textAlign(CENTER);
    ArrayList<Order> data;
    float x = 180;
    float y = 708;
    if (i == 0) {
      data = spadeOrders;
      text(youPlayer.getProfit("spades"), x+i*62, y);
    } else if (i == 1) {
      data = clubOrders;
      text(youPlayer.getProfit("clubs"), x+i*62, y);
    } else if (i == 2) {
      data = diamondOrders;
      text(youPlayer.getProfit("diamonds"), x+i*62, y);
    } else {
      data = heartOrders;
      text(youPlayer.getProfit("hearts"), x+i*62, y);
    }

    int volume = data.size();

    y = 595;
    text(Integer.toString(volume), x+i*62, y);

    y = 633;
    text(Double.toString(getOrdersAverage(data)), x+i*62, y);

    y = 671;
    if (data.size() != 0) {
      text(data.get(data.size()-1).price, x+i*62, y);
    } else {
      text(0, x+i*62, y);
    }
  }
}

public void drawCounter() {
  int spades = 0;
  int clubs = 0;
  int diamonds = 0;
  int hearts = 0;
  int total;
  for (Player player : playerList) {
    if (player!= null) {
      spades += player.numSpades;
      clubs += player.numClubs;
      diamonds += player.numDiamonds;
      hearts += player.numHearts;
    }
  }
  total = spades + clubs + diamonds + hearts;
  fill(mainColor);
  textFont(regular);

  textAlign(CENTER);

  textSize(40);
  text(spades, 585, 595);
  textSize(25);
  if (total != 0) {
    text(Math.round((double)spades/total*100) + "%", 585, 620);
  } else {
    text("0%", 585, 620);
  }

  textSize(40);
  text(diamonds, 780, 595);
  textSize(25);
  if (total != 0) {
    text(Math.round((double)diamonds/total*100) + "%", 780, 620);
  } else {
    text("0%", 780, 620);
  }

  textSize(40);
  text(clubs, 585, 695);
  textSize(25);
  if (total != 0) {
    text(Math.round((double)clubs/total*100) + "%", 585, 720);
  } else {
    text("0%", 585, 720);
  }

  textSize(40);
  text(hearts, 780, 695);
  textSize(25);
  if (total != 0) {
    text(Math.round((double)hearts/total*100) + "%", 780, 720);
  } else {
    text("0%", 780, 720);
  }

  textSize(40);
  text(Math.round(total/40.0*100) + "%", 735, 533);
}

public int median(ArrayList<Integer> data)
{
  if (data.size() == 0) {
    return 0;
  }
  if (data.size() == 1) {
    return data.get(0);
  }
  Collections.sort(data);

  int middle = data.size()/2;
  if (data.size()%2 == 1) {
    middle = (data.get(data.size()/2) + data.get(data.size()/2 - 1))/2;
  } else {
    middle = data.get(data.size() / 2);
  }
  return middle;
}

public <T> T[] concatenate(T[] array1, T[] array2) {
  T[] result = Arrays.copyOf(array1, array1.length + array2.length);
  System.arraycopy(array2, 0, result, array1.length, array2.length);
  return result;
}

public double getOrdersAverage(ArrayList<Order> data) {
  double sum = 0;
  for (Order order : data) {
    sum += order.price;
  }
  return (double)Math.round(sum/(double)data.size()*10.0)/10.0;
}

public void drawNames() {
  int i = 0;
  for (Player player : playerList) {
    if (player != null) {
      fill(player.colorValue);
      textFont(bold);
      textSize(27);
      textAlign(CENTER);
      text(player.name, 225+271*i, 55);
      i++;
    }
  }
  textAlign(RIGHT);
  textSize(30);
  fill(#FFFFFF);
  text(playerList[4].name, 1165, 710-15);
}

public void drawBorder() {
  int width = 8;
  fill(#DC0813);
  rect(0, 0, 1180, width); //top
  rect(0, 750-width, 1180, width); //bottom
  rect(0, 0, width, 750); //left
  rect(1180-width, 0, width, 750); //right
}

public void drawButtons() {
  for (Button button : buttonList) {
    button.display();
  }
}

public void drawConnectionStatus() {

  textAlign(LEFT);
  textSize(18);
  if (editIndex != -1) {
    fill(#FDD805);
    textAlign(RIGHT);
    circle(1165-textWidth("Editing " + playerList[editIndex].Color)-10, 729-15, 10);
    text("Editing " + playerList[editIndex].Color, 1165, 735-15);
  }
  else if (myClient.active()) {
    fill(#2DFE54);
    circle(1040, 729-15, 10);
    text("CONNECTED", 1050, 735-15);
  } else {
    fill(#FF0000);
    circle(1005, 729-15, 10);
    text("NOT CONNECTED", 1015, 735-15);
  }

  fill(#CFCFCF);
  textSize(10);
  textAlign(RIGHT);
  text(globalMsg, 1165, 737);
}
