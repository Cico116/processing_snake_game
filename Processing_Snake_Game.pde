/*
** Processing Snake Game
** By Tony
** 2020/05/07
*/

//方格宽度
int grid = 20;

//背景颜色
int background_color = 244;

//蛇身初始长度
int snake_length = 2;

//蛇身最大长度
int snake_length_max = 500;

//蛇头坐标
int snake_head_x = 0;
int snake_head_y = 0;

// 保存组成蛇身的每个方格位置
int[] x = new int[snake_length_max];
int[] y = new int[snake_length_max];

//食物位置
int food_x;
int food_y;

//蛇运动方向
char snake_direction = 'R';
char snake_direction_temp;

//移动速度
int speed = 5;

//速度计算相关变量
int time_start;
int time_passed;
int time_interval;

//最高得分
int best_score = snake_length - 2;

//食物是否被吃掉
boolean food_eaten = true;

//游戏结束标识
boolean game_over = false;

//游戏开始标识
boolean game_start = false;

//暂停状态
int game_pause = 0;


void setup()
{
  size(600, 600);//画布大小
  frameRate(15);//帧数
  noStroke();//取消描边
  show_first_start();

  time_start = millis();//获取一次开始时间数据
}

void draw()
{
  if (keyPressed && (key == 'r' || key == 'R'))
  {
    if (game_start == false)
    {
      game_start = true;
    }
    if (game_over)
    {
      snake_init();
    }
  }

  if (game_over)
  {
    return;
  }

  time_passed = millis() - time_start; //计算出经过的时间
  time_interval = 1000 / speed; //计算移动间隔时间


  if (time_passed > time_interval && snake_direction != 'P' && game_start)//游戏刷新条件
  {
    background(background_color);

    //移动方向选择
    switch(snake_direction) {
    case 'L':
      snake_head_x -= grid;
      break;
    case 'R':
      snake_head_x += grid;
      break;
    case 'D':
      snake_head_y += grid;
      break;
    case 'U':
      snake_head_y -= grid;
      break;
    }

    //在指定长宽区域内随机产生食物
    draw_food(width, height);

    //蛇吃到食物
    if (snake_head_x == food_x && snake_head_y == food_y)
    {
      food_eaten = true; //可重新生成食物
      snake_length++;

      if ( snake_length%5 == 1) {
        speed++;
      }
      speed = min(20, speed);//控制最大速度
    }

    //重新画蛇身
    draw_snake();

    //判断蛇是否死亡
    if (check_snake_die())
    {
      return;
    }

    time_start = millis(); //重新获取时间
  }
}

//键盘事件
void keyPressed()
{
  if (key == 'p' || key == 'P')
  {
    game_pause++;
    if (game_pause%2 == 1)
    {
      snake_direction_temp = snake_direction;
      snake_direction = 'P';
    } else {
      snake_direction = snake_direction_temp;
    }
  }

  if (snake_direction != 'P'&& keyPressed && key == CODED)
  {
    switch(keyCode) {
    case LEFT:
      if (snake_direction != 'R') {
        snake_direction = 'L';
      }
      break;
    case RIGHT:
      if (snake_direction != 'L') {
        snake_direction = 'R';
      }
      break;
    case DOWN:
      if (snake_direction != 'U') {
        snake_direction = 'D';
      }
      break;
    case UP:
      if (snake_direction != 'D') {
        snake_direction = 'U';
      }
      break;
    }
  }
}

void draw_food(int max_width, int max_high)
{
  int food_out = 0; //判断食物是否在体内

  //食物填充颜色
  fill(#F71E1E); 

  //如果食物被吃掉，则随机生成一个
  if (food_eaten)
  {
    while (food_out == 0)
    {
      food_out = 1;
      food_x = int(random(0, max_width) / grid) * grid;
      food_y = int(random(0, max_high) / grid) * grid;

      for (int i=snake_length-1; i>=0; i--) {
        if ( food_x == x[i] && food_y == y[i] ) {
          food_out = 0;
        }
      }
    }
  }

  rect(food_x, food_y, grid, grid);
  food_eaten = false;
}

void draw_snake()
{
  //从尾部开始更新蛇身方块坐标
  for (int i=snake_length-1; i>0; i--) {
    x[i] = x[i-1];
    y[i] = y[i-1];
  }

  // 设置蛇头新的坐标
  x[0] = snake_head_x;
  y[0] = snake_head_y;

  // 设置蛇身填充颜色
  fill(#3874F6);

  // 开始画蛇
  for (int i=0; i<snake_length; i++) {
    rect(x[i], y[i], grid, grid);
  }
}

void show_first_start()
{
  pushMatrix();
  background(0);  
  translate(width/2, height/2 - 50);
  fill(255);  
  textAlign(CENTER); 
  textSize(96);
  text("Snake", 0, 0);

  fill(120);
  textSize(40);
  text("Press 'R' or 'r' to start.", 0, 260);
  popMatrix();
}

void show_game_over()
{
  game_over = true;

  pushMatrix();
  best_score = best_score > snake_length ? (best_score - 2 ): (snake_length - 2);

  background(0);  
  translate(width/2, height/2 - 50);
  fill(255);  
  textAlign(CENTER); 
  textSize(84);
  text(snake_length - 2 + "/" + best_score, 0, 0);

  fill(120);
  textSize(30);
  text("Score / Best", 0, 200);
  text("Game Over, Press 'R' or 'r' to restart.", 0, 260);
  popMatrix();
}

void snake_init()
{
  background(background_color);
  snake_length = 2;
  game_over = false;
  snake_head_x = 0;
  snake_head_y = 0;
  snake_direction = 'R';
  speed = 5;
}

boolean check_snake_die()
{
  // 撞墙了
  if ( snake_head_x < 0 || snake_head_x >= width || snake_head_y < 0 || snake_head_y >= height) {
    show_game_over();
    return true;
  }

  // 自己吃自己
  if ( snake_length > 2 ) {
    for ( int i=1; i<snake_length; i++ ) {
      if ( snake_head_x == x[i] && snake_head_y == y[i] ) {
        show_game_over();
        return true;
      }
    }
  }

  return false;
}
