#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <ctype.h>
#include "parser.h"


int main(int argc, char **argv)
{
  int32_t c, threads;
  char *file_name;

  /* Get input parameters. */
  threads = 1;
  file_name = NULL;
  c = getopt(argc, argv, ":j:");
  while (c != -1) {
    switch (c) {
      case 'j':
        threads = atoi(optarg);
        break;
      default:
        if (optopt == 'j')
          fprintf(stdout, "Option -%c requires an argument.\n", optopt);
        else if (isprint(optopt))
          fprintf(stdout, "Unknown option `-%c'.\n", optopt);
        else
          fprintf(stdout, "Unknown option character `\\x%x'.\n", optopt);
        return 0;
    }
    c = getopt(argc, argv, ":j:");
  }
  if (optind == argc - 1) {
    file_name = argv[argc - 1];
  } else {
    fprintf(stdout, "Parallel Parser\n Usage: %s [-j threads] filename\n", argv[0]);
    return 0;
  }
  parse(threads, threads, file_name);

  return 0;
}
