
import ddf.minim.*;
import ddf.minim.analysis.*;
BeatDetect beat;
BeatListener bl;

// Objetos necessários para trabalhar com som
Minim minim;
AudioPlayer batida;
AudioPlayer inicio;
AudioPlayer fim;
AudioPlayer pulo;

//Configurações de tamanho de janela e sprite
PImage[] vetIMG = new PImage[4]; 
PImage im; //declara a imagem a ser carregada 

//int telaL, telaA; //define a tela em largura e altura referente à resolução do monitor
int telaL = 1366; //1280;
int telaA = 768;  //1024;
int larguraS = 96, alturaS = 104; //103 110
int janelaX = 0, janelaY = 0; //seta para o ponto 0,0
int janelaL = larguraS+50, janelaA = alturaS+80; //tamanhos das janelas em altura e largura
int xC = telaL/2 - janelaL/2, yC = telaA*2/3; //calcula a posição das janelas em relação ao tamanho do monitor/tela
int xD = telaL*2/3, yD = telaA/2 - janelaA/2; //calcula a posição das janelas em relação ao tamanho do monitor/tela
int i = 0;

int spriteControla[] = new int[4]; //vetor que passa na imagem e define qual sprite será exibido 

// Configurações de animacao inicial
int delay = 150;
int telaJogo = 0;
int start = 0;

//ANIMAÇÕES PERSONAGEM
int COSTAS = 2; 
int ANDANDO = 9;
int PARADO = 2;
int PULANDO = 0;
int modo = PARADO; //define o modo de início da animação como parado; quando o "flag" muda, então o modo muda.

class BeatListener implements AudioListener {
  private BeatDetect beat;
  private AudioPlayer source;
  
  BeatListener(BeatDetect beat, AudioPlayer source) {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }
  
  void samples(float[] samps) {
    beat.detect(source.mix);
  }
  
  void samples(float[] sampsL, float[] sampsR) {
    beat.detect(source.mix);
  }
}

void rotateLeft(){ //método que define quando o bonequinho será rotacionado para a esquerda
  int k;
  int value = spriteControla[3];
  int auce;
  for (k = 3; k > 0; k--){
    auce = spriteControla[k-1]; 
    spriteControla[k-1] = spriteControla[k]; 
    spriteControla[k] = auce;
  }
  spriteControla[0] = value;   
}

void rotateRight(){ //método que define quando o bonequinho será rotacionado para a direita
  int k;
  int value = spriteControla[0]; //salva em uma variável a posição 0 do vetor da imagem
  int auce; //auceliar
  for (k = 0; k < 3; k++){
    auce = spriteControla[k+1]; 
    spriteControla[k+1] = spriteControla[k]; 
    spriteControla[k] = auce;
  }
  spriteControla[3] = value;
}

void andar() { //método que define quando o bonequinho está andando 
  int j;
  if (modo == ANDANDO) return;
  if (spriteControla[0] < 4){
    for (j = 0; j < 4; j++)
      spriteControla[j] += 4; //o vetor passa pelos índices j(primeira coluna) da imagem e salva, dando a ilusão do movimento
  }
  modo = ANDANDO;
  delay = 80;
  inicio.play();
  i = 0;
}

void parar(){ //método que define quando o bonequinho está parado
  int j;
  if (spriteControla[0] > 3){
    for (j = 0; j < 4; j++)
      spriteControla[j] -= 4; //o vetor volta j índices na imagem na primeira linha, onde o boneco tem diferentes posições de momento dando a ideia de piscar os olhos 
  }
  modo = PARADO;
  delay = 150;
  i = 0;
}

void pular(){ //método que define quando o bonequinho está pulando
  int j;
  stop();
  if (trava == 1) return;
  if (spriteControla[0] < 4){
    for (j = 0; j < 4; j++)
      spriteControla[j] += 4; //o vetor volta j índices na imagem na primeira linha, onde o boneco tem diferentes posições de momento dando a ideia de piscar os olhos 
  }
  //file.play();
  modo = PULANDO;
  //pulo = minim.loadFile("jump00.wav");
  pulo.play();
  pulo.rewind();
  delay = 150;
  i = 2;
  velocidade = -15;
}

void startMusic(){
  minim = new Minim(this); // Instancia o objeto
  pulo = minim.loadFile("jump00.wav"); // Carrega o som pulo que está dentro da pasta 'data'
  //inicio = minim.loadFile("inicio.mp3"); // Carrega o som do inicio que está dentro da pasta 'data'
  //inicio = minim.loadFile("nebulatechno.mp3");
  //inicio = minim.loadFile("399821__raimonddd__awesome-background-melody-music.mp3");
  inicio = minim.loadFile("Game of Thrones - Malta feat. Família Lima.mp3");
  //inicio = minim.loadFile("Sweet Dreams (Are Made Of This) - X-Men Apocalypse  Quicksilver Theme Song.mp3");
  //inicio = minim.loadFile("Vitas - 7th Element (russian blblblblbl).mp3");
  //inicio = minim.loadFile("Eurythmics - Sweet Dreams (Are Made Of This) (Official Video).mp3");
  //inicio = minim.loadFile("JOGA O BUM BUM TAMTAM (Karaoke Version) - Mc Fioti.mp3");
  batida = minim.loadFile("batida.wav"); // Carrega o som batida que está dentro da pasta 'data'
  fim = minim.loadFile("gameovi.wav"); // Carrega o som game over que está dentro da pasta 'data'
  inicio.play();
  //inicio.loop();
  //beat.setSensitivity(300);
  //bl = new BeatListener(beat, inicio); 
  beat = new BeatDetect(); 
}

void verificaWin(){ 
  if (inicio.isPlaying()){
    start = 1;
  }else
    if (!inicio.isPlaying() && start == 1)
      vitoria();
}

void setup() {
  int j;
  frameRate(5);
  im = loadImage("spriteLink2.png");
  //file = new SoundFile(this, "jump.wav");
  // Inicializa os vetores de imagem e de controle
  for (j = 0; j < 4; j++){
    vetIMG[j] = createImage(janelaL,janelaA,RGB);
    spriteControla[j] = j;
  }
  modo = PARADO;
  //size(640,512);
  //size(1366, ); //tamanho monitor apresentacao
  fullScreen();
  //background(0); //define como cor de fundo preto(cor 0)
  //criaPedra();
  background(255);
  telaA = height;
  telaL = width;
  xC = telaL/2 - janelaL/2;
  yC = telaA*2/3; //calcula a posição das janelas em relação ao tamanho do monitor/tela
  xD = telaL*2/3;
  yD = telaA/2 - janelaA/2; //calcula a posição das janelas em relação ao tamanho do monitor/tela
}

void telaA() {
  translate(larguraS/2 + xC, telaA/3 - janelaA/2);
}

void telaB() {
  translate(larguraS/2 + xD, janelaA/2 + yD);
  rotate(PI/2);
}

void telaC() {
  translate(larguraS/2 + xC, janelaA/2 + yC);
  rotate(PI); 
}

void telaD() {
  translate(telaL/3 - larguraS, janelaA/2 + yD);
  rotate(-PI/2); 
}

// MECANICAS JOGO
int pararTempo = 0;
int corPedra = 255;
int trava = 0;
int travaColisao = 0;
int score = 0;
float gravidade = 1;
float velocidade = 0;
float velocidadeP = 10;
int intervaloPedra = 250;
float ultimaPedra = 0;
ArrayList<int[]> pedras = new ArrayList<int[]>();
ArrayList<int[]> pedrasFC = new ArrayList<int[]>();
//[posX,PosY,width,height,flagColision]

void criaPedra(){
  beat.detect(inicio.mix);
  if ( beat.isOnset() ) {
      println("Y " + inicio.mix.get(0));
      if (pedras.size() > 1 && (width-35 < (pedras.get(pedras.size()-1)[0]+35/2))) return;
      int[] pedra = {width, vetIMG[0].height/2 - 35/2, 35, 35, 0};
      pedras.add(pedra);
      ultimaPedra = millis();
      //break;
    }
  /*
  if (millis() - ultimaPedra > intervaloPedra) {
    int[] pedra = {width, vetIMG[0].height/2 - 50/2, 50, 50};
    pedras.add(pedra);
    ultimaPedra = millis();
  }
  */
}

void removePedra(int j){
    if(pedras.get(j)[0] < -1*width)
      pedras.remove(j);
}

void desenhaPedra(int j){
  if(!pedras.isEmpty()){
    pushMatrix();
    fill(corPedra);
    if (spriteControla[0]%2 == 0){
      telaB();
      if (spriteControla[1] == 1 || spriteControla[1] == 5){
        rect(-1*pedras.get(j)[0], pedras.get(j)[1], pedras.get(j)[2], pedras.get(j)[3]);
      }
      else
        rect(pedras.get(j)[0], pedras.get(j)[1], pedras.get(j)[2], pedras.get(j)[3]);
    }
    else{
      telaA();
      if (spriteControla[0] == 1 || spriteControla[0] == 5){
        rect(-1*pedras.get(j)[0], pedras.get(j)[1], pedras.get(j)[2], pedras.get(j)[3]);
      }
      else
        rect(pedras.get(j)[0], pedras.get(j)[1], pedras.get(j)[2], pedras.get(j)[3]);
    }
    rectMode(CENTER);
    popMatrix();
    
    pushMatrix();
    fill(corPedra);
    if (spriteControla[0]%2 == 0){
      telaD();
      if (spriteControla[3] == 1 || spriteControla[1] == 5){
        rect(pedras.get(j)[0], pedras.get(j)[1], pedras.get(j)[2], pedras.get(j)[3]);
      }
      else
        rect(-1*pedras.get(j)[0], pedras.get(j)[1], pedras.get(j)[2], pedras.get(j)[3]);
    }
    else{
      telaC();
      if (spriteControla[0] == 1 || spriteControla[0] == 5){
        rect(pedras.get(j)[0], pedras.get(j)[1], pedras.get(j)[2], pedras.get(j)[3]);
      }
      else
        rect(-1*pedras.get(j)[0], pedras.get(j)[1], pedras.get(j)[2], pedras.get(j)[3]);
    }
    rectMode(CENTER);
    popMatrix();
  }
}

void movePedra(int j){
  if(!pedras.isEmpty())
     pedras.get(j)[0] -= velocidadeP;
}

void colisaoPedra(int j){
  if (pedras.isEmpty() || pedras.get(j)[4] == 1) return;
  if (janelaX + (vetIMG[3].width/2) > pedras.get(j)[0] &&
  janelaX - (vetIMG[3].width/2) < pedras.get(j)[0] + pedras.get(j)[2] &&
  janelaY + (vetIMG[3].height/2) > pedras.get(j)[1] &&
  janelaY - (vetIMG[3].height/2) < pedras.get(j)[1] + pedras.get(j)[3]){
   // println("acertou!");
    //gameOver();
    batida.play();
    batida.rewind();
    travaColisao = 1;
    pedras.get(j)[4] = travaColisao;
    score-=250;
    corPedra-=50;
    if (inicio.mix.get(0) < 0)
      rotateRight();
    else
      rotateRight();
    if (score < -10000)
      gameOver();
  }
  else
    score();
}

void desenhaPedraFC(int j){
   if(!pedras.isEmpty() && (pedras.get(j)[0] - vetIMG[3].width/2) < 50 && (pedras.get(j)[0] - vetIMG[3].width/2) > -50- vetIMG[3].width){
    pushMatrix();
    fill(corPedra);
    if (spriteControla[0]%2 != 0)
      telaB();
    else
      telaA();
    rectMode(CENTER); 
    if ((pedras.get(j)[0] - vetIMG[3].width/2) != 0)
    rect(janelaX, pedras.get(j)[1], pedras.get(j)[2]*8/(pedras.get(j)[0] - vetIMG[3].width/2), pedras.get(j)[3]*8/(pedras.get(j)[0] - vetIMG[3].width/2));
    popMatrix();
    
    pushMatrix();
    fill(corPedra);
    if (spriteControla[0]%2 != 0)
      telaD();
    else
      telaC();
    rectMode(CENTER); 
    rect(janelaX, pedras.get(j)[1], pedras.get(j)[2]*8/(pedras.get(j)[0] - vetIMG[3].width/2), pedras.get(j)[3]*8/(pedras.get(j)[0] - vetIMG[3].width/2));
    popMatrix();
  }
}

void pedraHandler() {
  for (int j = 0; j < pedras.size(); j++){
    removePedra(j);
    movePedra(j);
    desenhaPedra(j);
    desenhaPedraFC(j);
    colisaoPedra(j);
  }
}

void gravidade(){
  //if (modo == PULANDO)
    velocidade += gravidade;
    janelaY += velocidade;
}

void manterNoChao(){
  if (janelaY >= 0){
    janelaY = 0;
    velocidade = 0;
    trava = 0;
  }
}

void score() {
  score++;
}

void printScore(){
  textAlign(CENTER);
  fill(255);
  textSize(30); 
  text(score, 0, -100);
}

// TELAS
void telaInicial(){
  background(0);

  // Lado A
  pushMatrix();
  if (spriteControla[0] == COSTAS)
    vetIMG[0].copy(im, larguraS * 0, alturaS * spriteControla[0] , larguraS, alturaS, 0, 0, janelaL, janelaA);
  else
    vetIMG[0].copy(im, larguraS * i, alturaS * spriteControla[0] , larguraS, alturaS, 0, 0, janelaL, janelaA);
  telaA();
  //imageMode(CENTER);
  image(vetIMG[0], janelaX, janelaY);
  textAlign(CENTER);
  scale(-1,1);
  text("Click to start", 0, -100);
  popMatrix();

  // Lado B
  pushMatrix();
  if (spriteControla[1] == COSTAS)
    vetIMG[1].copy(im, larguraS * 0, alturaS * spriteControla[1] , larguraS, alturaS, 0, 0, janelaL, janelaA);
  else
    vetIMG[1].copy(im, larguraS * i, alturaS * spriteControla[1] , larguraS, alturaS, 0, 0, janelaL, janelaA);
  telaB();
  //imageMode(CENTER);
  image(vetIMG[1], janelaX, janelaY);
  textAlign(CENTER);
  scale(-1,1);
  text("Click to start", 0, -100);
  popMatrix();
  
  // Lado C
  pushMatrix();
  if (spriteControla[2] == COSTAS)
    vetIMG[2].copy(im, larguraS * 0, alturaS * spriteControla[2] , larguraS, alturaS, 0, 0, janelaL, janelaA);
  else
    vetIMG[2].copy(im, larguraS * i, alturaS * spriteControla[2] , larguraS, alturaS, 0, 0, janelaL, janelaA);
  telaC();
  //imageMode(CENTER); //joga o centro da imagem no 0,0 para rotacionar PI graus
  image(vetIMG[2], janelaX, janelaY);
  textAlign(CENTER);
  scale(-1,1);
  text("Click to start", 0, -100);  
  popMatrix();
  
  // Lado D 
  pushMatrix();
  if (spriteControla[3] == COSTAS)
    vetIMG[3].copy(im, larguraS * 0, alturaS * spriteControla[3] , larguraS, alturaS, 0, 0, janelaL, janelaA);
  else
    vetIMG[3].copy(im, larguraS * i, alturaS * spriteControla[3] , larguraS, alturaS, 0, 0, janelaL, janelaA);
  telaD();
  imageMode(CENTER);
  image(vetIMG[3], janelaX, janelaY);
  textAlign(CENTER);
  scale(-1,1);
  text("Click to start", 0, -100);
  popMatrix();
  
  if ( i < modo ) //isso quer dizer que, o i verfica o modo(parado = 3, andando = 9) e passa as posições do vetor(linha)
    i++;
  else
    i = 0; //volta para o primeiro e percorre tudo de novo
  
}

void telaVitoria(){
   background(0);
  pushMatrix();
  textAlign(CENTER);
  fill(255);
  telaA();
  scale(-1,1);
  textSize(30);
  text("SCORE: " + score, 0, 0 - 100);
  scale(-1,1);
  textSize(30);
  text("Você VENCEU", 0, 0 - 20);
  scale(-1,1);
  textSize(15);
  text("Click to Restart", 0, 0 + 10);
  popMatrix();
  
  pushMatrix();
  textAlign(CENTER);
  fill(255);
  telaB();
  scale(-1,1);
  textSize(30);
  text("SCORE: " + score, 0, 0 - 100);
  scale(-1,1);
  textSize(30);
  text("Você VENCEU", 0, 0 - 20);
  scale(-1,1);
  textSize(15);
  text("Click to Restart", 0, 0 + 10);
  popMatrix();
  
  pushMatrix();
  textAlign(CENTER);
  fill(255);
  telaC();
  scale(-1,1);
  textSize(30);
  text("SCORE: " + score, 0, 0 - 100);
  scale(-1,1);
  textSize(30);
  text("Você VENCEU", 0, 0 - 20);
  scale(-1,1);
  textSize(15);
  text("Click to Restart", 0, 0 + 10);
  popMatrix();
  
  pushMatrix();
  textAlign(CENTER);
  fill(255);
  telaD();
  scale(-1,1);
  textSize(30);
  text("SCORE: " + score, 0, 0 - 100);
  scale(-1,1);
  textSize(30);
  text("Você VENCEU", 0, 0 - 20);
  scale(-1,1);
  textSize(15);
  text("Click to Restart", 0, 0 + 10);
  popMatrix();
}

void telaGameOver() {
  background(0);
  pushMatrix();
  textAlign(CENTER);
  fill(255);
  telaA();
  scale(-1,1);
  textSize(30);
  text("SCORE: " + score, 0, 0 - 100);
  scale(-1,1);
  textSize(30);
  text("Game Over", 0, 0 - 20);
  scale(-1,1);
  textSize(15);
  text("Click to Restart", 0, 0 + 10);
  popMatrix();
  
  pushMatrix();
  textAlign(CENTER);
  fill(255);
  telaB();
  scale(-1,1);
  textSize(30);
  text("SCORE: " + score, 0, 0 - 100);
  scale(-1,1);
  textSize(30);
  text("Game Over", 0, 0 - 20);
  scale(-1,1);
  textSize(15);
  text("Click to Restart", 0, 0 + 10);
  popMatrix();
  
  pushMatrix();
  textAlign(CENTER);
  fill(255);
  telaC();
  scale(-1,1);
  textSize(30);
  text("SCORE: " + score, 0, 0 - 100);
  scale(-1,1);
  textSize(30);
  text("Game Over", 0, 0 - 20);
  scale(-1,1);
  textSize(15);
  text("Click to Restart", 0, 0 + 10);
  popMatrix();
  
  pushMatrix();
  textAlign(CENTER);
  fill(255);
  telaD();
  scale(-1,1);
  textSize(30);
  text("SCORE: " + score, 0, 0 - 100);
  scale(-1,1);
  textSize(30);
  text("Game Over", 0, 0 - 20);
  scale(-1,1);
  textSize(15);
  text("Click to Restart", 0, 0 + 10);
  popMatrix();
  //fim.play();
}

float lastBeat = 0;
float newBeat = 0;
int framerate = 12;
ArrayList<Float> beatsVet = new ArrayList<Float>();
int beatsVetMax = 100;

//Calcula o framerate baseado na fila dos tempos dos beats
int calcMediaBeats(){
  float media = 0;
  for(int j = 0; j < beatsVet.size(); j++){
    media += beatsVet.get(j);
  }
  return (int)media/beatsVet.size();
}

//Seta o framerate de acordo com a batida da música
void setFrameRate(){
  if ( beat.isOnset() ){ 
    newBeat = millis();
    if (beatsVet.size() < beatsVetMax)
      beatsVet.add(newBeat-lastBeat);
    else{
      beatsVet.remove(0);
      beatsVet.add(newBeat-lastBeat);
    }
      
    framerate = calcMediaBeats()/10;
        println(framerate);
    lastBeat = newBeat;
  }
  frameRate(framerate);
}

void gamePlay(){
  background(0);
  setFrameRate(); //seta o frame (velocidade do jogo) -> ocorre conforme a música
  criaPedra();
  
  if (janelaY < 0){
    modo = PULANDO;
    trava = 1;
  }
  andar();
  
  // Lado A
  pushMatrix();
  if (spriteControla[0] == COSTAS)
    vetIMG[0].copy(im, larguraS * 0, alturaS * spriteControla[0] , larguraS, alturaS, 0, 0, janelaL, janelaA);
  else
    vetIMG[0].copy(im, larguraS * i, alturaS * spriteControla[0] , larguraS, alturaS, 0, 0, janelaL, janelaA);
  telaA();
  //imageMode(CENTER);
  image(vetIMG[0], janelaX, janelaY);
  popMatrix();

  // Lado B
  pushMatrix();
  if (spriteControla[1] == COSTAS)
    vetIMG[1].copy(im, larguraS * 0, alturaS * spriteControla[1] , larguraS, alturaS, 0, 0, janelaL, janelaA);
  else
    vetIMG[1].copy(im, larguraS * i, alturaS * spriteControla[1] , larguraS, alturaS, 0, 0, janelaL, janelaA);
  telaB();
  //imageMode(CENTER);
  image(vetIMG[1], janelaX, janelaY);
  popMatrix();
  
  // Lado C
  pushMatrix();
  if (spriteControla[2] == COSTAS)
    vetIMG[2].copy(im, larguraS * 0, alturaS * spriteControla[2] , larguraS, alturaS, 0, 0, janelaL, janelaA);
  else
    vetIMG[2].copy(im, larguraS * i, alturaS * spriteControla[2] , larguraS, alturaS, 0, 0, janelaL, janelaA);
  telaC();
  //imageMode(CENTER); //joga o centro da imagem no 0,0 para rotacionar PI graus
  image(vetIMG[2], janelaX, janelaY);
  popMatrix();
  
  // Lado D 
  pushMatrix();
  if (spriteControla[3] == COSTAS)
    vetIMG[3].copy(im, larguraS * 0, alturaS * spriteControla[3] , larguraS, alturaS, 0, 0, janelaL, janelaA);
  else
    vetIMG[3].copy(im, larguraS * i, alturaS * spriteControla[3] , larguraS, alturaS, 0, 0, janelaL, janelaA);
  telaD();
  imageMode(CENTER);
  image(vetIMG[3], janelaX, janelaY);
  popMatrix();
  
  //delay(delay);
  
  pushMatrix();
  telaA();
  scale(-1,1);
  printScore();
  popMatrix();
  
  pushMatrix();
  telaB();
  scale(-1,1);
  printScore();
  popMatrix();
  
  pushMatrix();
  telaC();
  scale(-1,1);
  printScore();
  popMatrix();
  
  pushMatrix();
  telaD();
  scale(-1,1);
  printScore();
  popMatrix();
  
  pedraHandler();
  gravidade();
  manterNoChao();
  
  if ( i < modo ) //isso quer dizer que, o i verfica o modo(parado = 3, andando = 9) e passa as posições do vetor(linha)
    i++;
  else
    i = 0; //volta para o primeiro e percorre tudo de novo
    
  verificaWin();
}

void draw() {
  if (telaJogo == 0)
    telaInicial();
  else if (telaJogo == 1)
    gamePlay();
  else if (telaJogo == 2)
    telaGameOver();
  else if (telaJogo == 3)
    telaVitoria();
}

// CONTROLES DE JOGO
void keyPressed() { //método que define qual ação o bonequinho vai fazer
  if (keyCode == LEFT){ //se a tecla esquerda for pressionada, então o bonequinho rotaciona para a esquerda dele(nossa direita olhando de frente)
    rotateLeft();
  }
  if (keyCode == RIGHT){ //se a tecla direita for pressionada, então o bonequinho rotaciona para a direita dele(nossa esquerda olhando de frente)
    rotateRight();
  }
  if (keyCode == UP){ //se a tecla para cima for pressionada, então o bonequinho seta a "flag" para andando e então começa a andar
    andar();
  }
  if (keyCode == DOWN){ //se a tecla para baixo for pressionada, então o bonequinho seta a "flag" para parado e então volta à ação piscar
    parar();
  }
  if (keyCode == ' '){ //se a tecla para baixo for pressionada, então o bonequinho seta a "flag" para parado e então volta à ação piscar
    pular();
  }
}

public void mousePressed() {
  // if we are on the initial screen when clicked, start the game
  if (telaJogo==0) {
    startGame();
  }
  if (telaJogo==2)
    restart();
  if (telaJogo == 3)
    restart();
}

void startGame() { 
  telaJogo=1;
  startMusic();
  i = 0;
}

void gameOver() {
  telaJogo=2;
}

void vitoria(){
   telaJogo = 3; 
}

void restart() {
  telaJogo = 1;
  pedras.clear();
  janelaY = 0;
  score = 0;
  stop();
  
  inicio.play();
  inicio.loop();
  
  int j;
  im = loadImage("spriteLink2.png");
  //file = new SoundFile(this, "jump.wav");
  // Inicializa os vetores de imagem e de controle
  for (j = 0; j < 4; j++){
    spriteControla[j] = j;
  }
  modo = PARADO;
  //size(640,512);
  //size(1366, ); //tamanho monitor apresentacao
  //background(0); //define como cor de fundo preto(cor 0)
  criaPedra();
  background(255);
  //setup();
}

void stop() {

  // Importante para interromper o som!
  //batida.close();
  
  //minim.stop();
  //super.stop();
  
  //pulo.close();
  //minim.stop();
  //super.stop();
  
  //inicio.close();
  //minim.stop();
  //super.stop();
  
  //fim.close();
  //minim.stop();
  //super.stop();
  
}