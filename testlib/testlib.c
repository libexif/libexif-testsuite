#include "config.h"

#define N_(string) string

const char *testlib_test(void);

static const char *testlib_string = N_("This is the dummy library");

const char *testlib_test(void) {
  return testlib_string;
}
