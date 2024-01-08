public class Suit{
  ArrayList<Integer> buy = new ArrayList<Integer>();
  ArrayList<Integer> sell= new ArrayList<Integer>();
  ArrayList<Integer> bid= new ArrayList<Integer>();
  ArrayList<Integer> offer= new ArrayList<Integer>();
  String type;
  
  public Suit(String type){
    this.type = type;
    if (DEV) {
      for (int i = 0; i < 2; i++) {
        buy.add(i);
        sell.add(i);
        bid.add(i);
        offer.add(i);
      }
    }
  }
  
  public ArrayList<Integer> getBuys() {
    return buy;
  }
  
   public ArrayList<Integer> getSells() {
    return sell;
  }
  
   public ArrayList<Integer> getBids() {
    return bid;
  }
  
   public ArrayList<Integer> getOffers() {
    return offer;
  }
  
 
  
  
 
  
}
