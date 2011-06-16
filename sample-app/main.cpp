#include <curses.h>

#include "UIController.h"


int main (int argc, char const *argv[])
{
  uic::UIController uiController;
    
  initscr();
  raw();
  noecho();
  
  printw("Usage:\n");
  printw("'s' - saves the UI element at the current mouse position.\n");
  printw("'p' - performs a 'PRESS' action of the last stored UI element.\n");
  printw("'e' - exits the programm.\n");
  
  char c;
  do
  {
    c = getch();
    
    if(c == 's')
      uiController.saveUiElement(1);
    else if(c == 'p')
      uiController.performAction(1, uic::UIController::PRESS, false);
  
  } while(c != 'e');
  
  endwin();
    
  return 0;
}