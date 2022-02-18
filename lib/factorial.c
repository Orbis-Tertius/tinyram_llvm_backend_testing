unsigned int isFactorial6(unsigned int x) {
  unsigned int result = 1;

  for (unsigned int i = 1; i <= x; i++) {
   result = result * i;
  }

  return (result == 720);
}
