
#include "svdpi.h"

int state = 0;

void update_state()
{
    state++;
}

int get_state()
{
    return state;
}
