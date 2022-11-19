int x = 410;
int xdir = -1;  //Change in horizontal position each time draw() executed
int y = 20;
int ydir = 12;  //Change in vertical position each time draw() exectuted

int xx = 160;
int xxdir = 1;  
int yy = 20;
int yydir = 8;

int xxx = 630;
int xxxdir = 1;  
int yyy = 20;
int yyydir = 7;

int score = 0; 
int lives = 3;

void setup()
{
   size (800,1000);
   reset();            //found the processing website
}

void reset()
{
  if(y > (height - 10))     // If ball bits bottom of screen then miss..
  {
    x = 410;
    y = 10;
  }
  if(yy > (height - 10))    // If ball bits bottom of screen then miss..
  {
    xx = 160;
    yy = 10;
  }
  if(yyy > (height - 10))   // If ball bits bottom of screen then miss..
  {
    xxx = 630; 
    yyy = 10; 
  }
  
  if((y>(height - 220)) && (abs(mouseX - x)<60))   // If ball has bit paddle then..
  {
    x = 410;
    y = 10;
    score++;
  }
  if((yy>(height - 220)) && (abs(mouseX - xx)<60))   // If ball has bit paddle then..
  { 
    xx = 160;
    yy = 10;
    score++;
  }
  if((yyy > (height - 220)) && (abs(mouseX - xxx) < 60))   // If ball has bit paddle then..
  {
    xxx = 630; 
    yyy = 10;
    score++;
  }
}

void draw()
{
  background(58,173,52);
  
  fill(43,40,133);
  rect(mouseX - 60,770,100,40); //goalkeeper body
  
  fill(107,89,54);
  rect(mouseX - 40,770,60,60); //goalkeeper head
   
  fill(255,255,255);
  rect(-20,400,900,30); //box
  
  fill(255,255,255);
  rect(25,870,750,20); //crossbar
  
  fill(255,255,255);
  rect(25,890,10,300); //net 1
  
  fill(255,255,255);
  rect(100,890,10,300); //net 2
  
  fill(255,255,255);
  rect(175,890,10,300); //net 3
  
  fill(255,255,255);
  rect(245,890,10,300); //net 4
  
  fill(255,255,255);
  rect(320,890,10,300); //net 5
  
  fill(255,255,255);
  rect(390,890,10,300); //net 6
  
  fill(255,255,255);
  rect(465,890,10,300); //net 7
  
  fill(255,255,255);
  rect(535,890,10,300); //net 8
  
  fill(255,255,255);
  rect(610,890,10,300); //net 9
  
  fill(255,255,255);
  rect(685,890,10,300); //net 10
  
  fill(255,255,255);
  rect(765,890,10,300); //net 11
  
  fill(255,255,255);
  rect(35,915,730,10);  //net 12
  
  fill(255,255,255);
  rect(35,960,730,10);  //net 13
  
  fill(255,255,255);    //Ball
  ellipse(x,y,40,40);   //Ball centered on x,y diameter 20
  
  fill(255,255,255);       
  ellipse(xx,yy,40,40);    
  
  fill(255,255,255);       
  ellipse(xxx,yyy,40,40);  
  
  textSize(26);
 
  x = x + xdir;                       // Update position
  if(x < 10)         xdir = -xdir;    // Reverse direction if hit boundary
  if(x > (width-10)) xdir = -xdir;
  
  xx = xx + xxdir;                       
  if(xx < 10)         xxdir = -xxdir;    
  if(xx > (width-10)) xxdir = -xxdir;
  
  xxx = xxx + xxxdir;                       
  if(xxx < 10)         xxxdir = -xxxdir;   
  if(xxx > (width-10)) xxxdir = -xxxdir;
  
  //Balls entering the goal
  y = y + ydir;
  if(y<10)  ydir = -ydir;
  
  if(y > (height - 10))           // If ball bits bottom of screen then miss..
  {
    ydir = -ydir; // Bounce
    lives--;
    if(lives == 0) exit();      // If lives is zero then quit
  }
  else
  {
    reset(); 
  }
  
  yy = yy + yydir;
  if(yy < 10)   yydir = -yydir;
  
  if(yy > (height - 10))           // If ball bits bottom of screen then miss..
  {
    yydir = -yydir; // Bounce
    lives--;
    if(lives == 0) exit();        // If lives is zero then quit
  }
  else
  {
    reset(); 
  }

  yyy = yyy + yyydir;
  if(yyy < 10)   yyydir = -yyydir;
  
  if(yyy > (height - 10))             // If ball bits bottom of screen then miss..
  {
    yyydir = -yyydir; // Bounce
    lives--;
    if(lives == 0) exit();          // If lives is zero then quit
  }
  else
  {
    reset(); 
  }

  //Balls saved by the keeper
  if((y > (height - 220)) && (abs(mouseX - x) < 60))   // If ball has bit paddle then..
  {
    ydir = -ydir;                // Bounce
    score++;
  } 
  else
  {
    reset();
  }

  if((yy>(height - 220))&&(abs(mouseX - xx)<60)) // If ball has bit paddle then..
  {
    yydir = -yydir;              // Bounce
    score++;
  }
  else
  {
    reset();
  }
  
  if((yyy > (height - 220)) && (abs(mouseX - xxx) < 60)) // If ball has bit paddle then..
  {
    yyydir = -yyydir; // Bounce
    score++;
  }
  else
  {
    reset(); 
  }
  
  fill(0,0,0);
  text("Lives:" + lives, 680, 30); //lives

  fill(0,0,0);
  text("Score:" + score, 680, 70); //score
}
