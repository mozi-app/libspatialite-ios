#import <Foundation/Foundation.h>
#import "include/LibSpatialite.h"

void setupSpatialite(sqlite3 *db_handle){
  // spatialite_init(0);
  puts("SpatiaLite integrated");

  const void *ptr;
  void *cache;
  cache = spatialite_alloc_connection();
  int verbose = 1;
  // spatialite_init(0);
  // puts("SpatiaLite integrated2");
  spatialite_init_ex (db_handle, cache, verbose);
  puts("SpatiaLite integrated4");
}
