#import <Foundation/Foundation.h>
#import "include/LibSpatialite.h"


//
//  init_ex.c
//  SpatiaLiteTest
//
//  Created by Vladyslav Shkodych on 2024.
//

#include <sqlite3.h>


int execute_query(sqlite3 *handle, const char *sql_query) {
  sqlite3_stmt *stmt;
  int ret;
  
  ret = sqlite3_prepare_v2(handle, sql_query, -1, &stmt, NULL);
  if (ret != SQLITE_OK) {
    printf("Failed to execute statement: %s\n", sqlite3_errmsg(handle));
    return -1;
  }
  
  printf("\nExecuting SQL query: %s\n", sql_query);
  
  /* Loop through the result rows */
  while ((ret = sqlite3_step(stmt)) == SQLITE_ROW) {
    int col_count = sqlite3_column_count(stmt);
    for (int i = 0; i < col_count; i++) {
      const char *col_text = (const char*)sqlite3_column_text(stmt, i);
      printf("result: %s ", col_text ? col_text : "NULL");
    }
    printf("\n");
  }
  printf ("\n\n");
  sqlite3_finalize(stmt);
  return ret;
}

int myopen (const char * filename) {
  int ret;
  sqlite3 *handle;
  void *cache;
  
  /* 1): Opening a connection to the DB */
  ret = sqlite3_open_v2 (filename, &handle, SQLITE_OPEN_READWRITE, NULL);
  if (ret != SQLITE_OK) {
    printf ("cannot open '%s': %s\n", filename, sqlite3_errmsg (handle));
    sqlite3_close (handle);
    return -1;
  }
  
  /* 2): Initializing SpatiaLite with the received pointer from the DB */
  cache = spatialite_alloc_connection();
  spatialite_init_ex(handle, cache, 1);
  
  /* 3): Query - check if a geometry point is valid */
  const char *sql_query_1 =
  "SELECT ST_IsValid(ST_GeomFromText('POINT(25.0 28.3)'));";
  execute_query(handle, sql_query_1);
  
  
//  ospital in toronto: 43.69592746085968, -79.32386417548666
//  Credit valley hospital: 43.55851402096621, -79.70378332905891
  const char *sql_query_distance =
//  "SELECT InitSpatialMetaData();"
//  "SELECT * FROM spatial_ref_sys WHERE srid IN (4326, 3857);"
  "SELECT ST_Distance("
  "Transform(MakePoint(-79.32386417548666, 43.69592746085968, 4326), 3857), "
  "Transform(MakePoint(-79.70378332905891, 43.55851402096621, 4326), 3857)"
  ") AS distance_in_meters;";
  execute_query(handle, sql_query_distance);
  
  /* Close the database connection */
  sqlite3_close(handle);
  
  return ret;
}



// void setupSpatialite(char *dbPath){
//   spatialite_init(0);
//   puts("SpatiaLite integrated");
//   myopen(dbPath);
// }


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
