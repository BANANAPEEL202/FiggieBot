public class Button {
  int x;
  int y;
  String text;
  int time = -1;
  int out;

  public Button(int x, int y, String text, int out) {
    this.x = x;
    this.y = y;
    this.text = text;
    this.out = out;
  }

  public void display() {
    

    if (time != -1) {
      int growth = -2;
      fill(#CFCFCF);
      rect(x-growth, y-growth, 125+growth*2, 44+growth*2, 12);
      fill(#141720);
      textFont(bold);
      textSize(17);
      textAlign(CENTER);
      text(text, x+(125+growth)/2, y+(44+growth)/2+6);
    } else {
      fill(#FFFFFF);
      rect(x, y, 125, 44, 12);
      fill(#141720);
      textFont(bold);
      textSize(18);
      textAlign(CENTER);
      text(text, x+125/2, y+44/2+6);
    }

    if (time != -1) {
      time--;
    }
  }

  public int click(float mouseX, float mouseY) {
    if (x < mouseX && mouseX < x+125 && y < mouseY && mouseY < y+44) {
      time = 10;
      return out;
    }
    return -1;
  }
}
