import processing.sound.*;



int x,y;
int l,o,p;

class Drop {
  float t = random(width);
  float z = random(-200, -100);
  float j = random (0, 20);
  float u = map (j, 0, 20, 10, 20);
  float zspeed = random(4, 10);
  
  void fall() {
    z = z + zspeed;
    float grav = map (j, 0, 20, 0, 0.2);
    zspeed = zspeed + grav;
    
    if (z > height) {
      z = random (-200, -100);
      zspeed = map(j, 0 ,20 , 4, 10);
    }
  }
  
  void show() {
    float thick = map(j, 0 , 20, 1, 3);
    line(t, z, t, z+10);
  }
}

class Drop2 {
  float t = random(-width);
  float z = random(200, 100);
  float j = random (0, 20);
  float u = map (-j, 0, -20, -10, -20);
  float zspeed = random(4, 10);
  
  void fall() {
    z = z - zspeed;
    float grav = map (j, 0, 20, 0, 0.2);
    zspeed = zspeed + grav;
    
    if (z < -height) {
      z = random (200, 100);
      zspeed = map(-j, 0 ,-20 , -4, -10);
    }
  }
  
  void show() {
    float thick = map(j, 0 , 20, 1, 3);
    line(t, z, t, z-10);
  }
}

    
SoundFile file;
AudioIn input;
Amplitude analyzer;
FFT fft;

  


int scale = 5;

int bands = 128;

float r_width;

float[] sum = new float[bands];

float smooth_factor = 0.2;

float bounds = 250;

Drop[] drops = new Drop[500];

Drop2[] drops2 = new Drop2[500];

void setup() {
  size (1000, 500, P3D);
  background(255);
  smooth();
  
  input = new AudioIn(this, 0);
  r_width = width/float(bands);
  
  analyzer = new Amplitude(this);
  
  analyzer.input(input);
  
  file = new SoundFile(this, "avemaria.mp3");
  file.play(1, 0, 0.5, 0, 0); //116.3 for kpop
  
  fft = new FFT(this, bands);
  fft.input(file);
  for (int i = 0; i < drops.length; i++) {
    drops[i] = new Drop();
  }
    for (int i = 0; i < drops2.length; i++) {
    drops2[i] = new Drop2();
  }
}
float oa = 0;
float bo = 0;

void draw() {
  background(0);
  strokeWeight(3);
  lights();
  float voice = analyzer.analyze();
  bo = bo + voice*10;
  fill(0);
  translate(width/2, height/2, -1000);
  //rotateY(bo);
  //rotateX(bo);
  //sphere(200 + voice*250);

  fft.analyze();
  for (int i = 0; i < bands; i++) {
    oa = oa + 0.01*sum[i];
    sum[i] += (fft.spectrum[i] - sum[i]) * smooth_factor;
    stroke(((mouseX/255)*i), ((mouseY/255)*i), voice*255, (sum[i]*height)*200);
    drops[i].fall();
    drops[i].show();
    drops2[i].fall();
    drops2[i].show();
   circle( 200 + 250*voice , 200 + 250*voice , 200 + 250*voice );
   circle( -200 - 250*voice , -200 - 250*voice , -200 - 250*voice );
   box( 200 + 250*voice , 200 + 250*voice , 200 + 250*voice );
    if (keyPressed == true) {
      if (key == 'n') {
      rect( i*r_width, height/2, r_width, -sum[i]*height*scale );
      rect( -i*r_width, -height/2, -r_width, sum[i]*height*scale );
      }
      else if (key == 'm') {
      line( i*r_width, height/2, r_width, -sum[i]*height*scale );
      line( -i*r_width, -height/2, -r_width, sum[i]*height*scale );
      }
      else if (key == 'l') {
        box( 200 , 200 , 200 );
      }
      else {
    ellipse( i*r_width + (10*voice), height/2 + (10*voice), r_width + (200*voice), -sum[i]*height*scale + (200*voice));
    ellipse( -i*r_width + (10*voice), -height/2 + (10*voice), -r_width - (200*voice), sum[i]*height*scale + (200*voice));
      }
    //translate((10*voice), (10*voice), (10*voice));
    rotateY(oa/10);
    rotateX(oa/10);
    rotateZ(oa/20);
    }
    else if (keyPressed == false) {
    //circle(500, height/2, random(sum[i]*scale)+(sum[i]*height));
    ellipse( i*r_width + (10*voice), height/2 + (10*voice), r_width + (200*voice), -sum[i]*height*scale + (200*voice));
    ellipse( -i*r_width + (10*voice), -height/2 + (10*voice), -r_width - (200*voice), sum[i]*height*scale + (200*voice));
    //translate((sum[i]*height)/20 + (100*voice), -(sum[i]*height)/20 + (100*voice), (sum[i]*height)/20);
    rotateY(oa/10);
    rotateX(oa/10);
    rotateZ(oa/20);
    }
  }
  
}

void keyPressed() {
  if (key == 'a')
  x -= 20;
  if (key == 'd')
  x += 20;
  if (key == 's')
  y -= 20;
  if (key == 'w')
  y += 20;
}
