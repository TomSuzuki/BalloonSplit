
final int FlgInitialize = 0;
final int FlgTitle = 1;
final int FlgGameInitialize = 10;
final int FlgGame = 11;

int MasterFlg = FlgInitialize;

int mouseKey = 0;

final int BalloonNum = 32;

int GameLimit = 0;
int GameCount = 0;
int Balloon[][] = new int[BalloonNum][4];

color BalloonColor[] = new color[8];

void setup() {
  size(500, 500);
}

void draw() {

  background(128, 255, 255);

  switch(MasterFlg) {
  case FlgInitialize:
    MasterFlg = FlgTitle;

    BalloonColor[0] = color(255, 0, 0);
    BalloonColor[1] = color(0, 255, 0);
    BalloonColor[2] = color(0, 0, 255);
    BalloonColor[3] = color(255, 255, 0);
    BalloonColor[4] = color(255, 0, 255);
    BalloonColor[5] = color(0, 0, 0);
    BalloonColor[6] = color(128, 128, 128);
    BalloonColor[7] = color(255, 255, 255);
    break;
  case FlgTitle:
    MasterTitle();
    break;
  case FlgGameInitialize:
    MasterFlg = FlgGame;

    GameLimit = 60*3 + 60*30;
    GameCount = 0;
    for (int i = 0; i < BalloonNum; i++) Balloon[i][0] = 0;
    break;
  case FlgGame:
    MasterGame();
    break;
  }

  // マウスカーソル
  noFill();
  stroke(0, 0, 0);
  strokeWeight(1);
  ellipse(mouseX, mouseY, 16, 16);
  ellipse(mouseX, mouseY, 24, 24);
  line(mouseX-sin(radians(frameCount))*16, mouseY-cos(radians(frameCount))*16, mouseX+sin(radians(frameCount))*16, mouseY+cos(radians(frameCount))*16);
  line(mouseX-sin(radians(frameCount+90))*16, mouseY-cos(radians(frameCount+90))*16, mouseX+sin(radians(frameCount+90))*16, mouseY+cos(radians(frameCount+90))*16);
}

void MasterTitle() {

  fill(0, 0, 0);
  textSize(72);
  textAlign(CENTER, CENTER);
  text("BalloonSplit", 250, 200);

  pushMatrix();
  rotate(radians(90));
  fill(0, 0, 0);
  textSize(24);
  text("Click to start.", 80, -488);
  popMatrix();

  if (mouseKey == 1) {
    mouseKey = 0;
    MasterFlg = FlgGameInitialize;
  }
}

void MasterGame() {

  GameLimit = GameLimit - 1;

  // 描画
  for (int i = 0; i < BalloonNum; i++) if (Balloon[i][0] == 1) {
    if (Balloon[i][2] < -64) Balloon[i][0] = 0;
    Balloon[i][2] = Balloon[i][2] - 4;
    fill(BalloonColor[Balloon[i][3]]);
    noStroke();
    if (dist(mouseX, mouseY, Balloon[i][1], Balloon[i][2]) < 32) {
      fill(BalloonColor[Balloon[i][3]], 128);
    }
    ellipse(Balloon[i][1], Balloon[i][2], 64, 64);
  }

  // 表示
  if (GameLimit <= 60*30 && GameLimit > 0) {
    textAlign(CENTER, CENTER);
    fill(0, 0, 0);
    textSize(24);
    text(GameLimit/60+1, 250, 22);
  }
  textAlign(LEFT, CENTER);
  fill(0, 0, 0);
  textSize(36);
  text(GameCount+" Balloon", 40, 80);

  if (GameLimit > 60*30) {
    // カウントダウン
    textAlign(CENTER, CENTER);
    fill(0, 0, 0);
    textSize(72);
    text(GameLimit/60-30+1, 250, 200);
  } else if (GameLimit > 0) {
    // 処理
    if (GameLimit%10 == 0) {
      for (int i = 0; i < BalloonNum; i++) if (Balloon[i][0] == 0) {
        Balloon[i][0] = 1;
        Balloon[i][1] = int(random(500-36))+18;
        Balloon[i][2] = 560;
        Balloon[i][3] = int(random(8));
        break;
      }
    }

    // 描画
    for (int i = 0; i < BalloonNum; i++) if (Balloon[i][0] == 1) {
      if (dist(mouseX, mouseY, Balloon[i][1], Balloon[i][2]) < 32 && mouseKey == 1) {
        mouseKey = 0;
        Balloon[i][0] = 0;
        GameCount = GameCount + 1;
      }
    }
  } else {
    textAlign(CENTER, CENTER);
    fill(0, 0, 0);
    textSize(72);
    text("SCORE "+GameCount, 250, 200);

    if (GameLimit < -30*5) {
      if (mouseKey == 1) {
        mouseKey = 0;
        MasterFlg = FlgTitle;
      }
      pushMatrix();
      rotate(radians(90));
      fill(0, 0, 0);
      textSize(24);
      text("Click to title.", 80, -488);
      popMatrix();
    }
  }
}

// マウスを押した
void mousePressed() {
  mouseKey = 1;
}

// マウスを離した
void mouseReleased() {
  mouseKey = 0;
}