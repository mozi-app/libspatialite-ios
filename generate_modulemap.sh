#!/bin/bash

# Directory containing headers (pass as argument or default to "include/")
HEADERS_DIR=${1:-include}
OUTPUT_FILE=${2:-module.modulemap}

# Ensure the headers directory exists
if [ ! -d "$HEADERS_DIR" ]; then
    echo "Error: Directory '$HEADERS_DIR' does not exist."
    exit 1
fi

# Create the module.modulemap file
echo "module libspatialite {" > "$OUTPUT_FILE"

# Recursively find all header files (*.h) in the directory
find "$HEADERS_DIR" -type f -name "*.h" | while read -r HEADER; do
    # Get the relative path of the header file (relative to the HEADERS_DIR)
    RELATIVE_PATH=${HEADER#$HEADERS_DIR/}
    echo "    header \"$RELATIVE_PATH\"" >> "$OUTPUT_FILE"
done

# Finalize the module
echo "    export *" >> "$OUTPUT_FILE"
echo "}" >> "$OUTPUT_FILE"

echo "Generated module.modulemap in $OUTPUT_FILE"