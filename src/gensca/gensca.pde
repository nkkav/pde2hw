/* gensca: 
 * Generic implementation of the Generations automaton (2D, outer totalistic 
 * with decay).
 *
 * Generations rules are defined in the "S/B/C" form, where:
 * S - defines counts of alive neighbors necessary for a cell to survive,
 * B - defines counts of alive neighbors necessary for a cell to be born.
 * C - defines the count of states cells can have (including 0 state).
 */

int XSIZE = 160;
int YSIZE = 120;
//int XSIZE = 320;
//int YSIZE = 240;
int i, j, k, x, y;
int u, cs, alive;
boolean survival, birth;

int[][] img_temp = new int[XSIZE][YSIZE];
int[][] img_work = new int[XSIZE][YSIZE];
int [] x_offset = {-1, 0, 1, 1, 1, 0,-1,-1};
int [] y_offset = {-1,-1,-1, 0, 1, 1, 1, 0};

void setup()
{
  size(XSIZE, YSIZE);
  frameRate(60);
  
  /* Initialize to all empty sites */
  for (x = 0 ; x < XSIZE; x++) {
    for (y = 0 ; y < YSIZE; y++) {
      img_temp[x][y] = ((x*y) >> 8) & 0x1;
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
       * This scheme can only allow for up to 8 distinct colors 
       * (essentially: RGB3).
       */
      r = ((t >> 2) & 0x1) * 255;
      g = ((t >> 1) & 0x1) * 255;
      b = ((t     ) & 0x1) * 255;
      c = color(r, g, b);
      stroke(c);
      point(x, y);
    }
  }

  update();
}

void update()
{
  // Sample rulesets for the Generations automaton.
  //-----------------------------------------------  
  // Bombers: 345/24/25
  // Fireworks: 2/13/21
  // BelZhab: 23/23/8
  // Spirals: 2/234/5 
  // Brain6: 6/246/3
//  int c=3;
  // Starwars: 345/2/4
  // Cooties: 23/2/8
  int c=8;
  // Meteorguns: 01245678/3/8
  // Starbows: 347/23/8

  // Calculate next grid state.
  for (x = 1; x < XSIZE-1; x++) {
    for (y = 1; y < YSIZE-1; y++) {
      alive = 0;
      for (k = 0; k < 8; k++) {
        u = img_temp[x+x_offset[k]][y+y_offset[k]];
        if (u == 1) {
          alive++;
        }
      }
      cs = img_temp[x][y];
      if (cs >= 1) {
        // Brain 6
//        survival = ((cs == 1) && (alive == 6));
        // Cooties
        survival = ((cs == 1) && ((alive == 2) || (alive == 3)));
       if (survival) {          
          img_work[x][y] = img_temp[x][y];
        } else {          
          img_work[x][y] = img_temp[x][y] + 1;
          if (img_work[x][y] == c) {
            img_work[x][y] = 0;
          }
        }
      } else if (cs == 0) {
        // Birth.
        // Brain 6
//        birth = ((alive == 2) || (alive == 4) || (alive == 6));
        // Cooties
        birth = ((alive == 2));
        if (birth) {          
          img_work[x][y] = 1;
        } else {
          img_work[x][y] = 0;
        }
      }      
    }      
  }
        
  // Copy back current generation.
  for (x = 0; x < XSIZE; x++) {
    for (y = 0; y < YSIZE; y++) {
      img_temp[x][y] = img_work[x][y];
    }
  }
}
