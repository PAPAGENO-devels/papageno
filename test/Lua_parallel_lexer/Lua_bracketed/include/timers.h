#ifndef __TIMERS_H_
#define __TIMERS_H_

#include <time.h>
#include <stdint.h>

#ifdef __MACH__
#include <mach/clock.h>
#include <mach/mach.h>
#endif

inline static void portable_clock_gettime(struct timespec *ts) {
#ifdef __MACH__ // OS X does not have clock_gettime, use clock_get_time
  clock_serv_t cclock;
  mach_timespec_t mts;
  host_get_clock_service(mach_host_self(), CALENDAR_CLOCK, &cclock);
  clock_get_time(cclock, &mts);
  mach_port_deallocate(mach_task_self(), cclock);
  ts->tv_sec = mts.tv_sec;
  ts->tv_nsec = mts.tv_nsec;
#else
  clock_gettime(CLOCK_REALTIME, ts);
#endif
}

double compute_time_interval(struct timespec *start, struct timespec *end){
  
  double total_time=0.0;
  long int delta_ns, delta_s;
  if (start->tv_nsec==end->tv_nsec) {
    if (start->tv_sec==end->tv_sec){
     total_time=(double) (end->tv_sec - start->tv_sec);
    }
    else {
      return total_time;
    }
  }
  if (start->tv_nsec < end->tv_nsec){
    delta_ns=end->tv_nsec - start->tv_nsec;
    delta_s=end->tv_sec - start->tv_sec;
    return ((double) delta_s)+ ((double) delta_ns)/1000000000.0;
  }

  if (start->tv_nsec >= end->tv_nsec){
    delta_ns= (1000000000-start->tv_nsec) + end->tv_nsec;
    delta_s = end->tv_sec - (start->tv_sec + 1);
    return ((double) delta_s)+ ((double) delta_ns)/1000000000.0;
  } 
  return -1.0f;
}

#endif
