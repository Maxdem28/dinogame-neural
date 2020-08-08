int h;
float pX;
float pY;
float speedPY = 0;
float gravity;
float velO = -2;
float accO = -0.001;
int spawn = 0;
float spawnRate = 2.0;
ArrayList<Obstac> obstacles;
ArrayList<Dino> Dinosaurs;
int obstaclesUpdate = 172;
float score = 0;
float dist1 ;
float dist2 ;
int countDeaths = 0;
int gen = 1;
int best = 0;
float dist11;
float dist22;
int player = 2;  //p = 1: You play. Jump with spacebar. p = 2: AI Plays.
int ndin = 50;  //min: 2, max: what your pc can handle.
int dinoHeight = 30;
int dinoWidth = 10;
int alive = ndin;

void setup() {
  frameRate(144);
  size(700, 300);
  h = (height/4)*3;
  pX = width/10;
  pY = h;
  gravity = 0.18;
  obstacles = new ArrayList<Obstac>();
  Dinosaurs = new ArrayList<Dino>();
  for (int i = 0; i<ndin; i++)
  {
    Dino dino = new Dino();
    Dinosaurs.add(dino);
  }
}

void draw() {
  background(255);
  fill(0);   
  line(0, h+dinoHeight, width, h+dinoHeight);
  if (player == 1) {
    fill(100);
    rect(pX, pY, dinoWidth, dinoHeight);
    fill(0);
  }

  textSize(20);
  if (player == 2) {
    text("Best: "+best, width*5/8, height/10);
  }
  text(-int(score/100), width*7/8, height/10);
  if (player == 1) {
    pY+=speedPY;
    if (pY<=h) speedPY+=gravity;
    if (pY>h) { 
      speedPY = 0;
      pY = h;
    }
  }
  if (-score/100 > best) best = -int(score/100);
  velO+=accO;
  score+=velO;
  if (spawn >= obstaclesUpdate) {
    Obstac new_obs = new Obstac();
    obstacles.add(new_obs);
    spawn = 0;
    spawnRate += 1/144;
    obstaclesUpdate = int(random(70, 180));
  }
  for (int i = 0; i<obstacles.size(); i++) {
    Obstac a = obstacles.get(i);
    a.update();
    a.show();
    if (player == 2) {
      for (int j = 0; j<ndin; j++)
      {
        Dino l = Dinosaurs.get(j);
        if (a.check(l.pY1) && l.death == false) {
          l.death = true;
          countDeaths+=1;
          alive--;
          l.score = -int(score/100);
        }
      }
    } else {
      if (a.check(pY)) frameRate(0);
    }
    if (a.outOfScreen()) obstacles.remove(0);
  }
  if(obstacles.size()  > 2)
  {
     if(obstacles.get(0).x>pX)
     {
       dist1 = obstacles.get(0).x;
       dist2 = obstacles.get(0).dx ;
       dist11 = obstacles.get(1).x;
       dist22 = obstacles.get(1).dx;
       
     }
     else 
     {
       dist1 = obstacles.get(1).x;
       dist2 = obstacles.get(1).dx ;
       dist11 = obstacles.get(2).x;
       dist22 = obstacles.get(2).dx;
     }
  }
    if(obstacles.size()  == 2)
  {
     if(obstacles.get(0).x>pX)
     {
       dist1 = obstacles.get(0).x;
       dist2 = obstacles.get(0).dx ;
       dist11 = obstacles.get(1).x;
       dist22 = obstacles.get(1).dx;
       
     }
     else 
     {
        dist1 = obstacles.get(1).x;
        dist2 = obstacles.get(1).dx;
        dist11 = 10000;
        dist22 = 0;
     }
  }

  if(obstacles.size() == 1)
  {
     if(obstacles.get(0).x>pX)
     {
       dist1 = obstacles.get(0).x;
       dist2 = obstacles.get(0).dx ;
       dist11 = 10000;
       dist22 = 0;
     }
     else 
     {
        dist1 = 10000;
        dist2 = 0;
        dist11 = 10000;
        dist22 = 0;
        
     }
  }
  else if(obstacles.size() == 0)
  {
        dist1 = 10000;
        dist2 = 0;
        dist11 = 10000;
        dist22 = 0;
  }
  spawn += random(1, int(spawnRate));
  if (player == 2) {
    for (int i = 0; i<ndin; i++)
    {
      Dinosaurs.get(i).drw();
    }

    if (countDeaths == ndin)
    {
      velO = -2;
      gen++;
      spawn = 0;
      spawnRate = 2;
      score = 0;
      bubblesort();
      randomize();
      countDeaths = 0;
      alive = ndin;
      obstacles.clear();
      for (int i = 0; i<ndin; i++)
      {
        Dinosaurs.get(i).death = false;
      }
    }
  }
  if (player == 2) {
    fill(0);
    text("Alive: "+alive, width*6/20, height/10);
    text("Generation: "+gen, width/20, height/10);
  }
}

void keyPressed() {
  if (key==' ' && pY>=h) speedPY-=5.8;
}
void keyReleased()
{
  if (pY>h-50)
  {
    speedPY += 1.25;
  }
}

class Obstac {

  int x = width + int(random(30, 100));
  float y = h;
  int dx = int(random(20, 50));
  int dy = dinoHeight;
  void update() {
    x += velO;
  }
  void show() {
    rect(x, y, dx, dy);
  }
  boolean check(float pY2) {
    if ((x<=pX && pX<=x+dx && pY2+dinoHeight>=y) || (x<=pX+dinoWidth && pX+dinoWidth<=x+dx && pY2+dinoHeight>=y))
      return true;
    return false;
  }
  boolean outOfScreen() {
    return (x+dx<0);
  }
}

class Dino {

  float[][] IL = new float[5][4];
  float[][] L2 = new float[4][3];
  float[][] L3= new float[3][2];
  float[][] L4 = new float[2][1];
  float[] H1 = new float[5];
  float[] H2 = new float[4];
  float[] H3 = new float[3];
  float[] H4 = new float[2];
  float out;
  int score = 0;
  float pY1 = h;
  float speedPY1 = 0;
  int r = int(random(0, 255));
  int b = int(random(0, 255));
  int g = int(random(0, 255));
  boolean death = false;

  Dino()
  {
    for (int i = 0; i<5; i++)
    {
      for (int j = 0; j<2; j++)
      {
        float a = random(-10, 10);
        IL[i][j] = a;
      }
    }
    for (int i = 0; i<4; i++)
    {
      for (int j = 0; j<3; j++)
      {
        float a = random(-10, 10);
        L2[i][j] = a;
      }
    }
    for (int i = 0; i<3; i++)
    {
      for (int j = 0; j<2; j++)
      {
        float a = random(-10, 10);
        L3[i][j] = a;
      }
    }
    for (int i = 0; i<2; i++)
    {
      for (int j = 0; j<1; j++)
      {
        float a = random(-10, 10);
        L4[i][j] = a;
      }
    }
  }
  float salto()
  {
    H1[0] = dist1-80;
    H1[1] = dist2;
    H1[2] = -1*velO*10; 
    H1[3] = dist11;
    H1[4] = dist22;

    for (int i = 0; i<4; i++)
    {
      float sum = 0;
      for (int j = 0; j<5; j++)
      {

        sum+= IL[j][i]*H1[j];
      }
      float m = sig(sum);
      H2[i] = m;
    }
    for (int i = 0; i<3; i++)
    {
      float sum = 0;
      for (int j = 0; j<4; j++)
      {

        sum+= L2[j][i]*H1[j];
      }
      float m = sig(sum);
      H2[i] = m;
    }
    for (int i = 0; i<2; i++)
    {
      float sum = 0;
      for (int j = 0; j<3; j++)
      {

        sum+= L3[j][i]*H1[j];
      }
      float m = sig(sum);
      H2[i] = m;
    }
    for (int i = 0; i<1; i++)
    {
      float sum = 0;
      for (int j = 0; j<2; j++)
      {
        sum+= L4[j][i]*H2[j];
      }
      float m = sig(sum);
      out = m;
    }

    return out;
  }

  float sig(float b)
  {
    return 1/(1+exp(-b));
  }

  void drw()
  {

    pY1+=speedPY1;
    if (pY1<=h) speedPY1+=gravity;
    if (pY1>h) { 
      speedPY1 = 0;
      pY1 = h;
    }
    float m = salto();
    if (m>0.5 && pY1>=h)
    {
      speedPY1-=5.8;
    }
    if (!death)
    {
      fill(r, b, g);
      rect(pX, pY1, dinoWidth, dinoHeight);
    }
  }
}

void bubblesort()
{
  for (int i = 0; i<ndin; i++)
  {
    for (int j = 1; j<ndin; j++)
    {
      Dino first = Dinosaurs.get(j-1);
      Dino second = Dinosaurs.get(j);
      if (second.score>first.score)
      {
        Dinosaurs.set(j-1, second);
        Dinosaurs.set(j, first);
      }
    }
  }
}

void randomize()
{
  for (int i = ndin/2; i<ndin; i++)
  {
    int a = int(random(0, ndin/2));
    int b = int(random(0, ndin/2));
    for (int j = 0; j<5; j++)
    {
      int x = int(random(0, 4));
      for (int z = 0; z<x; z++)
      {
        Dinosaurs.get(i).IL[j][z] = Dinosaurs.get(a).IL[j][z];
      }
      for (int z = x; z<4; z++)
      {
        Dinosaurs.get(i).IL[j][z] = Dinosaurs.get(b).IL[j][z];
      }
      float s = random(-10, 10);
      x = int(random(0, 2));
      Dinosaurs.get(i).IL[j][x] = s;
    }
    for (int j = 0; j<4; j++)
    {
      int x = int(random(0, 3));
      for (int z = 0; z<x; z++)
      {
        Dinosaurs.get(i).L2[j][z] = Dinosaurs.get(a).L2[j][z];
      }
      for (int z = x; z<3; z++)
      {
        Dinosaurs.get(i).L2[j][z] = Dinosaurs.get(b).L2[j][z];
      }
      float s = random(-10, 10);
      x = int(random(0, 2));
      Dinosaurs.get(i).L2[j][x] = s;
    }
    for (int j = 0; j<3; j++)
    {
      int x = int(random(0, 2));
      for (int z = 0; z<x; z++)
      {
        Dinosaurs.get(i).L3[j][z] = Dinosaurs.get(a).L3[j][z];
      }
      for (int z = x; z<2; z++)
      {
        Dinosaurs.get(i).L3[j][z] = Dinosaurs.get(b).L3[j][z];
      }
      float s = random(-10, 10);
      x = int(random(0, 2));
      Dinosaurs.get(i).L3[j][x] = s;
    }
    for (int j = 0; j<2; j++)
    {
      int x = int(random(0, 1));
      for (int z = 0; z<x; z++)
      {

        Dinosaurs.get(i).L4[j][z] = Dinosaurs.get(a).L4[j][z];
      }
      for (int z = x; z<1; z++)
      {
        Dinosaurs.get(i).L4[j][z] = Dinosaurs.get(b).L4[j][z];
      }
      float s = random(-10, 10);
      x = int(random(0, 1));
      Dinosaurs.get(i).L4[j][x] = s;
    }
  }
  for (int i = ndin/3; i<ndin/2; i++)
  {
    int a = int(random(0, ndin/3));
    int b = int(random(0, ndin/3));
   for (int j = 0; j<5; j++)
    {
      int x = int(random(0, 4));
      for (int z = 0; z<x; z++)
      {
        Dinosaurs.get(i).IL[j][z] = Dinosaurs.get(a).IL[j][z];
      }
      for (int z = x; z<4; z++)
      {
        Dinosaurs.get(i).IL[j][z] = Dinosaurs.get(b).IL[j][z];
      }
      float s = random(-10, 10);
      x = int(random(0, 2));
      Dinosaurs.get(i).IL[j][x] = s;
    }
    for (int j = 0; j<4; j++)
    {
      int x = int(random(0, 3));
      for (int z = 0; z<x; z++)
      {
        Dinosaurs.get(i).L2[j][z] = Dinosaurs.get(a).L2[j][z];
      }
      for (int z = x; z<3; z++)
      {
        Dinosaurs.get(i).L2[j][z] = Dinosaurs.get(b).L2[j][z];
      }
      float s = random(-10, 10);
      x = int(random(0, 2));
      Dinosaurs.get(i).L2[j][x] = s;
    }
    for (int j = 0; j<3; j++)
    {
      int x = int(random(0, 2));
      for (int z = 0; z<x; z++)
      {
        Dinosaurs.get(i).L3[j][z] = Dinosaurs.get(a).L3[j][z];
      }
      for (int z = x; z<2; z++)
      {
        Dinosaurs.get(i).L3[j][z] = Dinosaurs.get(b).L3[j][z];
      }
      float s = random(-10, 10);
      x = int(random(0, 2));
      Dinosaurs.get(i).L3[j][x] = s;
    }
    for (int j = 0; j<2; j++)
    {
      int x = int(random(0, 1));
      for (int z = 0; z<x; z++)
      {

        Dinosaurs.get(i).L4[j][z] = Dinosaurs.get(a).L4[j][z];
      }
      for (int z = x; z<1; z++)
      {
        Dinosaurs.get(i).L4[j][z] = Dinosaurs.get(b).L4[j][z];
      }
      float s = random(-10, 10);
      x = int(random(0, 1));
      Dinosaurs.get(i).L4[j][x] = s;
    }
  }
}
