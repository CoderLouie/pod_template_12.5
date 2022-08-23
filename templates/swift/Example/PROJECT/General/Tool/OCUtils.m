//
//  OCUtils.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import "OCUtils.h"

#import <sys/time.h>
 
double OCBenchmark(void (^block)(void)) { 
    
    struct timeval t0, t1;
    gettimeofday(&t0, NULL);
    block();
    gettimeofday(&t1, NULL);
    return (double)(t1.tv_sec - t0.tv_sec) * 1e3 + (double)(t1.tv_usec - t0.tv_usec) * 1e-3;
}
 
