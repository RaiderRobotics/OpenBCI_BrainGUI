import processing.video.*;
Movie video;
PGraphics GRAPH;
PGraphics BRAIN3D;
float angOffset = 0.1;
float mag;
int fpr = 144;
int renderWidth, renderHeight;
PShape[] brainShape = new PShape[8]; 

DataInterpreter data;

void setup() {
  size(1024, 768,P2D);
  renderWidth = int(width*0.5);
  renderHeight = int(height*0.5);
  GRAPH = createGraphics(width,renderHeight,P2D);
  BRAIN3D = createGraphics(renderWidth,renderHeight,P3D);
  setupBrain();
  video = new Movie(this, "movie.mov");
  video.frameRate(10);
  video.loop();
  background(0);
  for(int i = 0; i<8; i++){;
    colourChanger(int(random(255)),int(random(255)),int(random(255)),i);
  }
  frameRate(24);

  //Test data interpreter
  data = new DataInterpreter().load("1").load("2", "3", "4");
}

void movieEvent(Movie m) {
  m.read();
}

void setupBrain() {
  brainShape[0] = loadShape("lhPareital.obj");//may need to increase memory on processing
  brainShape[1] = loadShape("rhPareital.obj");
  brainShape[2] = loadShape("lhFrontal.obj");
  brainShape[3] = loadShape("rhFrontal.obj");
  brainShape[4] = loadShape("lhOccipital.obj");
  brainShape[5] = loadShape("rhOccipital.obj");
  brainShape[6] = loadShape("lhTemporal.obj");
  brainShape[7] = loadShape("rhTemporal.obj");
  for(int i=0; i<8; i++){
   brainShape[i].translate(0,0);
   brainShape[i].scale(2.25);
   brainShape[i].rotateX(HALF_PI);
  }
}    


void draw() {    
  BRAIN3D.beginDraw();
  BRAIN3D.lights();
  BRAIN3D.background(255);
  renderBrain();
  BRAIN3D.camera(renderWidth/2.0, renderHeight/4.0, (renderHeight/2.0) / tan(PI*30.0 / 180.0), 0, 0, 0, 0, 1, 0);
  BRAIN3D.endDraw();
  angOffset = angOffset + 0.1;
  if(frameCount%11==0){   
    mag = height/4.0*random(1);
  }
  GRAPH.beginDraw();
  GRAPH.background(255);
  for (int i = 0; i< width; i++){
    GRAPH.point(i, sin(i*((2*TWO_PI)/width)-angOffset)*mag+renderHeight/2.0);
  }
  GRAPH.endDraw();
  image(BRAIN3D, width/2,0); 
  image(video, 0, 0, width/2.0, height/2.0);
  image(GRAPH, 0,height/2.0);

  //TODO Test data
  data.tick();
  if(data.loaded) {
      System.out.println(data.list.size());
  }
}


void colourChanger(int r, int g, int b, int lobe){
  brainShape[lobe].setFill(color(r,g,b));
}

void renderBrain(){
  for(int i = 0; i<8; i++){
    BRAIN3D.shape(brainShape[i],0,0);
    brainShape[i].rotateY(HALF_PI/fpr);
  }
}
