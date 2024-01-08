public class Player {
  Suit spades;
  Suit clubs;
  Suit diamonds;
  Suit hearts;
  String name;
  String Color;
  color colorValue;
  
  int numSpades = 0;
  int numClubs = 0;
  int numDiamonds = 0; 
  int numHearts = 0;
  
  public Player(String name, String Color) {
    this.name = name;
    this.Color = Color;
    if (Color.equals("Red")){
      colorValue = color(171, 0, 4);
    }
    if (Color.equals("Yellow")){
      colorValue = color(231, 144, 1);
    }
    if (Color.equals("Green")){
      colorValue = color(23, 167, 1);
    }
    if (Color.equals("Blue")){
      colorValue = color(40, 115, 224);
    }
    spades = new Suit("Spades");
    clubs = new Suit("Clubs");
    diamonds = new Suit("Diamonds");
    hearts = new Suit("Hearts");  
  }
  
  public void process(Order order){
    if (order.type.equals("bid")) {
      if(order.player1.equals(name)) {
        if (order.suit.equals("spades")) {
          spades.bid.add(order.price);
        }
        else if (order.suit.equals("clubs")) {
          clubs.bid.add(order.price);
        }
        else if (order.suit.equals("diamonds")) {
          diamonds.bid.add(order.price);
        }
        else if (order.suit.equals("hearts")) {
          hearts.bid.add(order.price);
        }
      }
    }
    else if (order.type.equals("offer")) {
      if(order.player1.equals(name)) {
        if (order.suit.equals("spades")) {
          spades.offer.add(order.price);
        }
        else if (order.suit.equals("clubs")) {
          clubs.offer.add(order.price);
        }
        else if (order.suit.equals("diamonds")) {
          diamonds.offer.add(order.price);
        }
        else if (order.suit.equals("hearts")) {
          hearts.offer.add(order.price);
        }
      }
    }
    else if (order.type.equals("buy")) {
      if(order.player1.equals(name)) {
        if (order.suit.equals("spades")) {
          spades.buy.add(order.price);
        }
        else if (order.suit.equals("clubs")) {
          clubs.buy.add(order.price);
        }
        else if (order.suit.equals("diamonds")) {
          diamonds.buy.add(order.price);
        }
        else if (order.suit.equals("hearts")) {
          hearts.buy.add(order.price);
        }
      }
      else if(order.player2.equals(name)) {
        if (order.suit.equals("spades")) {
          spades.sell.add(order.price);
        }
        else if (order.suit.equals("clubs")) {
          clubs.sell.add(order.price);
        }
        else if (order.suit.equals("diamonds")) {
          diamonds.sell.add(order.price);
        }
        else if (order.suit.equals("hearts")) {
          hearts.sell.add(order.price);
        }
      }
    }else if (order.type.equals("sell")) {
      if(order.player1.equals(name)) {
        if (order.suit.equals("spades")) {
          spades.sell.add(order.price);
        }
        else if (order.suit.equals("clubs")) {
          clubs.sell.add(order.price);
        }
        else if (order.suit.equals("diamonds")) {
          diamonds.sell.add(order.price);
        }
        else if (order.suit.equals("hearts")) {
          hearts.sell.add(order.price);
        }
      }
      else if(order.player2.equals(name)) {
        if (order.suit.equals("spades")) {
          spades.buy.add(order.price);
        }
        else if (order.suit.equals("clubs")) {
          clubs.buy.add(order.price);
        }
        else if (order.suit.equals("diamonds")) {
          diamonds.buy.add(order.price);
        }
        else if (order.suit.equals("hearts")) {
          hearts.buy.add(order.price);
        }
      }
    }
    numSpades = Math.max(numSpades, -1*(spades.getBuys().size() - spades.getSells().size()));
    numClubs = Math.max(numClubs, -1*(clubs.getBuys().size() - clubs.getSells().size()));
    numDiamonds = Math.max(numDiamonds, -1*(diamonds.getBuys().size() - diamonds.getSells().size()));
    numHearts = Math.max(numHearts, -1*(hearts.getBuys().size() - hearts.getSells().size()));
  }
  
  public int getProfit(String suit){
    Suit data;
    if (suit.equals("spades")){
      data = spades;
    }
    else if (suit.equals("clubs")){
      data = clubs;
    }
    else if (suit.equals("diamonds")){
      data = diamonds;
    }
    else if (suit.equals("hearts")){
      data = hearts;
    }
    else{
      println("Profit Error");
      return -1;
    }
    int profit = 0;
    for (Integer num: data.buy) {
      profit -= num;
    }
    for (Integer num: data.sell) {
      profit += num;
    }
    return profit;
  }
  
  
 
}
