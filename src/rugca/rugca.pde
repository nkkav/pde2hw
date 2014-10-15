/* rugca: 
 * Generic implementation of a rug-like automaton (2D).
 *
 * Rug rules are averaging rules using the full range of 256 possible states. To 
 * update itself in a Rug rule, every cell takes four steps. 
 * 1) Every cell calculates the sum of its 8-neighborhood states. 
 * 2) Every cell calculates the average neighbor state by dividing the sum by 
 *    8 and throwing out any remainder. 
 * 3) Every cell computes its new state by adding an increment (incr) to the 
 *    average neighbour state. 
 * 4) As a final step, new state is taken modulo 256.
 */

int XSIZE = 160;
int YSIZE = 120;
//int XSIZE = 320;
//int YSIZE = 240;
//int XSIZE = 640;
//int YSIZE = 480;
int i, j, k, x, y;
int u, sum, nval;

int[][] img_temp = new int[XSIZE][YSIZE];
int[][] img_work = new int[XSIZE][YSIZE];
int [] x_offset = {-1, 0, 1, 1, 1, 0,-1,-1};
int [] y_offset = {-1,-1,-1, 0, 1, 1, 1, 0};  
int incr=3;

void setup()
{
  size(XSIZE, YSIZE);
  frameRate(60);
  
  /* Initialize to all empty sites */
  for (x = 0 ; x < XSIZE; x++) {
    for (y = 0 ; y < YSIZE; y++) {
      img_temp[x][y] = 0x00;
    }
  }
}

void draw()
{
  int t;
  int r, g, b;
  color c;
 
  for (x = 0 ; x < XSIZE; x++) {
    for (y = 0; y < YSIZE; y++) {
      t = img_temp[x][y];
      /* Decode the RGB encoding of the specified color.
       * This scheme can only allow for up to 256 distinct colors 
       * (essentially: R3G3B2).
       */
      r = ((t >> 5) & 0x7) << 5;
      g = ((t >> 2) & 0x7) << 5;
      b = ((t     ) & 0x3) << 6;
      c = color(r, g, b);
      stroke(c);
      point(x, y);
    }
  }

  update();
}

void update()
{
  // Calculate next grid state.
  for (x = 1; x < XSIZE-1; x++) {
    for (y = 1; y < YSIZE-1; y++) {
      sum = 0;
      for (k = 0; k < 8; k++) {
        u     = img_temp[x+x_offset[k]][y+y_offset[k]];
        sum   = sum + u;
      }
      // Averaging sum.
      sum = sum >> 3;
      // Increment current state, modulo 256.
      nval = (sum + incr) & 0xFF;
      img_work[x][y] = nval;      
    }      
  }
            
  // Copy back current generation.
  for (x = 0; x < XSIZE; x++) {
    for (y = 0; y < YSIZE; y++) {
      img_temp[x][y] = img_work[x][y];
    }
  }
}

