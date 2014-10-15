/* imgsynth: 
 * Static image synthesis engine for testing various algebraic effects.
 *
 * The following triplets of two-variable functions which follow the form
 * R_f(x,y), G_f(x,y), B_f(x,y) for each color component R, G, B are currently 
 * tested:
 *
 * - GREY_XOR:   R_f(x,y) = x ^ y, G_f(x,y) = x ^ y, B_f(x,y) = x ^ y
 * - RGB_XOR:    R_f(x,y) = x, G_f(x,y) = y, B_f(x,y) = x ^ y
 * - RGB_ADD:    R_f(x,y) = x, G_f(x,y) = x + y, B_f(x,y) = x + y
 * - GREY_MUL:   R_f(x,y) = x * y, G_f(x,y) = x * y, B_f(x,y) = x * y
 * - RGB_MUL:    R_f(x,y) = x, G_f(x,y) = x * y, B_f(x,y) = x * y
 * - SEPIA:      R_f(x,y) = 224, G_f(x,y) = 132, B_f(x,y) = 40
 * - GRAD_RG:    R_f(x,y) = x, G_f(x,y) = y, B_f(x,y) = 0
 * - GRAD_RB:    R_f(x,y) = x, G_f(x,y) = 0, B_f(x,y) = y
 * - GREY_ADDSQ: R_f(x,y) = x*x+y*y, G_f(x,y) = x*x+y*y, B_f(x,y) = x*x+y*y
 * - GRAD_GB:    R_f(x,y) = 0, G_f(x,y) = x, B_f(x,y) = y
 * - ADDSUBXOR:  R_f(x,y) = x + y, G_f(x,y) = x - y, B_f(x,y) = x ^ y
 * - GREY_AVG:   R_f(x,y) = (x+y)>>1, G_f(x,y) = (x+y)>>1, B_f(x,y) = (x+y)>>1
 * - GREY_SUBSQ: R_f(x,y) = x*x-y*y, G_f(x,y) = x*x-y*y, B_f(x,y) = x*x-y*y
 * - RGB_SUBSQ:  R_f(x,y) = x, G_f(x,y) = x*x-y*y, B_f(x,y) = x*x-y*y
 * - GREY_MAX:   R_f(x,y) = MAX(x,y), G_f(x,y) = MAX(x,y), B_f(x,y) = MAX(x,y)
 * - GREY_MIN:   R_f(x,y) = MIN(x,y), G_f(x,y) = MIN(x,y), B_f(x,y) = MIN(x,y)
 *
 * to which optionals masks can be applied.
 */

int HEIGHT=256;
int WIDTH=256;

int GREY_XOR   = 0x00;
int RGB_XOR    = 0x01;
int RGB_ADD    = 0x02;
int GREY_MUL   = 0x03;
int RGB_MUL    = 0x04;
int SEPIA      = 0x05;
int GRAD_RG    = 0x06;
int GRAD_RB    = 0x07;
int GREY_ADDSQ = 0x08;
int GRAD_GB    = 0x09;
int ADDSUBXOR  = 0x0A;
int GREY_AVG   = 0x0B;
int GREY_SUBSQ = 0x0C;
int RGB_SUBSQ  = 0x0D;
int GREY_MAX   = 0x0E;
int GREY_MIN   = 0x0F;

// SPARTAN3AN
//int MASK       = 0xF0;
// FULLRGB
int MASK       = 0xFF;

//int[][] img    = new int[WIDTH][HEIGHT];
int mode       = GREY_XOR;

int avg(int x, int y)
{
  return (((x) + (y)) >> 1);
}

color imgsynth(int mode, int x, int y)
{
  color c;
  int red=0, green=0, blue=0;
  int xyxor;
  int xyadd;
  int xymul;
  int xysub;
  int xsqr;
  int ysqr;
  int xysqradd;
  int xysqrsub;
  int xyavgexpr;

  xyxor = x ^ y;
  xyadd = x + y;
  xymul = x * y;
  xysub = x - y;
  xsqr = x * x;
  ysqr = y * y;
  xysqradd = xsqr + ysqr;
  xysqrsub = xsqr - ysqr;
  xyavgexpr = avg(x, y);
  if (mode == GREY_XOR) {
    red   = xyxor;
    green = xyxor;
    blue  = xyxor;
  } else if (mode == RGB_XOR) {
    red   = x;
    green = y;
    blue  = xyxor;         
  } else if (mode == RGB_ADD) {
    red   = x;
    green = xyadd;
    blue  = xyadd;         
  } else if (mode == GREY_MUL) {
    red   = xymul;
    green = xymul;
    blue  = xymul;
  } else if (mode == RGB_MUL) {
    red   = x;
    green = xymul;
    blue  = xymul;         
  } else if (mode == SEPIA) {
    red   = 224;
    green = 132;
    blue  =  40;         
  } else if (mode == GRAD_RG) {
    red   = x;
    green = y;
    blue  = 0;
  } else if (mode == GRAD_RB) {
    red   = x;
    green = 0;
    blue  = y;
  } else if (mode == GREY_ADDSQ) {
    red   = xysqradd;
    green = xysqradd;
    blue  = xysqradd;
  } else if (mode == GRAD_GB) {
    red   = 0;
    green = x;
    blue  = y;
  } else if (mode == ADDSUBXOR) {
    red   = xyadd;
    green = xysub;
    blue  = xyxor;
  } else if (mode == GREY_AVG) {
    red   = xyavgexpr;
    green = xyavgexpr;
    blue  = xyavgexpr;          
  } else if (mode == GREY_SUBSQ) {
    red   = xysqrsub;
    green = xysqrsub;
    blue  = xysqrsub;
  } else if (mode == RGB_SUBSQ) {
    red   = x;
    green = xysqrsub;
    blue  = xysqrsub;
  } else if (mode == GREY_MAX) {
    red   = max(x, y);
    green = max(x, y);
    blue  = max(x, y);
  } else if (mode == GREY_MIN) {
    red   = min(x, y);
    green = min(x, y);
    blue  = min(x, y);
  } else {
    red   = 0xFF;
    green = 0xFF;
    blue  = 0xFF;         
  }
  red   = red   & MASK;
  green = green & MASK;
  blue  = blue  & MASK;
  c = color(red, green, blue);
  return (c);
}

void setup()
{
//  int x, y;

  size(WIDTH, HEIGHT);
  frameRate(60);
  
  /* Initialize to all empty sites */
//  for (x = 0 ; x < WIDTH; x++) {
//    for (y = 0 ; y < HEIGHT; y++) {
//      img[x][y] = 0x00;
//    }
//  }
}

void draw()
{
  int x, y;
  color c;

  update();
 
  for (x = 0 ; x < WIDTH; x++) {
    for (y = 0; y < HEIGHT; y++) {
      c = imgsynth(mode, x, y);
      stroke(c);
      point(x, y);
    }
  }
}

void update()
{
  // Select mode.
  if (keyPressed) {
    switch (key) {
    case '0': mode = GREY_XOR; break;
    case '1': mode = RGB_XOR; break;
    case '2': mode = RGB_ADD; break;
    case '3': mode = GREY_MUL; break;
    case '4': mode = RGB_MUL; break;
    case '5': mode = SEPIA; break;
    case '6': mode = GRAD_RG; break;
    case '7': mode = GRAD_RB; break;
    case '8': mode = GREY_ADDSQ; break;
    case '9': mode = GRAD_GB; break;
    case 'a': mode = ADDSUBXOR; break;
    case 'b': mode = GREY_AVG; break;
    case 'c': mode = GREY_SUBSQ; break;
    case 'd': mode = RGB_SUBSQ; break;
    case 'e': mode = GREY_MAX; break;
    case 'f': mode = GREY_MIN; break;
    default: break;
    }
  }
}
