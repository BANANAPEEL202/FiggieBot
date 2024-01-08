public class Order {
  String type;
  String player1;
  String player2;
  String suit;
  int price;

  public Order(String msg, Player[] playerList) {
    if (msg.contains("bid")) {
      type = "bid";
      player1 = getPlayer(msg.substring(0, msg.indexOf(":")), playerList);
      try {
        price = Integer.parseInt(msg.substring(msg.indexOf(":"), msg.indexOf(":")+3).replace(" ", "").replaceAll("[^0-9]", ""));
      }
      catch (Exception e) {
        println("ORDER PARSING ERROR: " + msg);
        price = -1;
      }
    } else if (msg.contains("sold")) {
      type = "sell";
      player1 = getPlayer(msg.substring(0, msg.indexOf("sold")), playerList);
      String secondHalf = msg.substring(msg.indexOf("sold"));
      player2 = getPlayer(msg.substring(secondHalf.indexOf("to")+2), playerList);
      try {
        price = Integer.parseInt(msg.substring(msg.lastIndexOf("at")+2).replace(" ", "").replaceAll("[^0-9]", ""));
      }
      catch (Exception e) {
        println("ORDER PARSING ERROR: " + msg);
        price = 0;
      }
    } else if (msg.contains("bought")) {
      type = "buy";
      player1 = getPlayer(msg.substring(0, msg.indexOf("bought")), playerList);
      player2 = getPlayer(msg.substring(msg.indexOf("from")+4, msg.indexOf("for")), playerList);
      try {
        price = Integer.parseInt(msg.substring(msg.indexOf("for")+3).replace(" ", "").replaceAll("[^0-9]", ""));
      }
      catch (Exception e) {
        println("ORDER PARSING ERROR: " + msg);
        price = 0;
      }
    } else {//offer
      type = "offer";
      player1 = getPlayer(msg.substring(0, msg.indexOf(":")), playerList);
      try {
        price = Integer.parseInt(msg.substring(msg.lastIndexOf("at")+2).replace(" ", "").replaceAll("[^0-9]", ""));
      }
      catch (Exception e) {
        println("ORDER PARSING ERROR: " + msg);
        price = 0;
      }
    }
    
    
    //no need to check for player 2 since only bids/offers use "YOU"

    getSuit(msg);
  }

  private void getSuit(String msg) {
    msg = msg.toLowerCase();
    if (msg.contains("spades")) {
      suit = "spades";
    } else if (msg.contains("clubs")) {
      suit = "clubs";
    } else if (msg.contains("diamonds")) {
      suit = "diamonds";
    } else if (msg.contains("hearts")) {
      suit = "hearts";
    } else {
      println("Trade Message parsing error");
    }
  }

  public String toString() {
    String msg;
    if (type.equals("bid")) {
      msg = player1 + ": " + price + " bid " + suit;
    } else if (type.equals("sell")) {
      msg = player1 + ": SOLD " + suit.toUpperCase() + " TO " + player2 + " AT " + price;
    } else if (type.equals("buy")) {
      msg = player1 + ": BOUGHT " + suit.toUpperCase() + " FROM " + player2+ " FOR " + price;
      ;
    } else {
      msg = player1 + ": " + suit + " at " + price;
    }
    return msg;
  }

  private String getPlayer(String name2, Player[] playerList) {
    if (name2.toLowerCase().equals("you")) {
      return playerList[4].name;
    }
    char[] name = name2.toLowerCase().toCharArray();
    int maxLCS = 0;
    String playerName = "";
    for (Player player : playerList) {
      if (player != null) {
        int currLCS = LCS(name, (player.name.toLowerCase()).toCharArray());
        if (currLCS > maxLCS) {
          maxLCS = currLCS;
          playerName = player.name;
        }
      }
    }
    return playerName;
  }

  int LCS(char X[], char Y[])
  {
    // Create a table to store
    // lengths of longest common
    // suffixes of substrings.
    // Note that LCSuff[i][j]
    // contains length of longest
    // common suffix of
    // X[0..i-1] and Y[0..j-1].
    // The first row and first
    // column entries have no
    // logical meaning, they are
    // used only for simplicity of program
    int m = X.length;
    int n = Y.length;
    int LCStuff[][] = new int[m + 1][n + 1];

    // To store length of the longest
    // common substring
    int result = 0;

    // Following steps build
    // LCSuff[m+1][n+1] in bottom up fashion
    for (int i = 0; i <= m; i++) {
      for (int j = 0; j <= n; j++) {
        if (i == 0 || j == 0)
          LCStuff[i][j] = 0;
        else if (X[i - 1] == Y[j - 1]) {
          LCStuff[i][j]
            = LCStuff[i - 1][j - 1] + 1;
          result = Integer.max(result,
            LCStuff[i][j]);
        } else
          LCStuff[i][j] = 0;
      }
    }
    return result;
  }
}
