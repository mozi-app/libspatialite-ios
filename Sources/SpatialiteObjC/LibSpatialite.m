#import <Foundation/Foundation.h>
#import "include/LibSpatialite.h"

void setupSpatialite(sqlite3 *db_handle){
  // spatialite_init(0);
//   puts("SpatiaLite integrated");

  const void *ptr;
  void *cache;
//  cache = spatialite_alloc_connection();
  int verbose = 1;
  
//  sqlite3 *db;
//
//  // Open an in-memory SQLite database
//  if (sqlite3_open(":memory:", &db) != SQLITE_OK) {
//      fprintf(stderr, "Failed to open SQLite database: %s\n", sqlite3_errmsg(db));
//      return 1;
//  }
//
//  
//  sqlite3_stmt *stmt;
//      const char *sql = "SELECT spatialite_version();";
//
//  // Prepare the SQL statement
//      if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
//          fprintf(stderr, "Failed to prepare SQL statement: %s\n", sqlite3_errmsg(db));
//          sqlite3_close(db);
//          return 1;
//      }
//
//      // Execute the query
//      if (sqlite3_step(stmt) == SQLITE_ROW) {
//          const unsigned char *version = sqlite3_column_text(stmt, 0);
//          printf("SpatiaLite version: %s\n", version);
//      } else {
//          fprintf(stderr, "Failed to retrieve SpatiaLite version\n");
//      }
//
//      // Clean up
//      sqlite3_finalize(stmt);
  
//   spatialite_init(0);
//   spatial_ref_sys_init (db_handle, 0);
  // puts("SpatiaLite integrated2");
//  spatialite_init_ex (db_handle, cache, verbose);
  
  puts(sqlite3_libversion());
  int a, b;
  
  sqlite3_status(0, &a, &b, 0);

//  sqlite3_db_status(db_handle, 0, &a, &b, 0);
  
  char *errMsg;
  int rc = sqlite3_exec(db_handle, "SELECT 1", 0, 0, &errMsg);
  if (rc != 0) {
    puts(errMsg);
    puts("SpatiaLite integrated6 failed");
  } else {
    puts("SpatiaLite integrated6");
  }
}
