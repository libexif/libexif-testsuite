#include "config.h"

#define N_(string) string

static const char *testlib_string = N_("This is the dummy library");

const char *testlib_test();

const char *testlib_test() {
  return testlib_string;
}
