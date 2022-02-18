#include "lib/special.h"
#include "lib/factorial.h"

int main(void) {
  long long int _read = readTape(1);
  struct TapeRead* r = (struct TapeRead*)&_read;
  if (r->finished == 1) {
    return 0;
  } else {
    return isFactorial6(r->word);
  }
}

