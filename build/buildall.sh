#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

echo "--------------- Build settings"
echo "Path of parent doc: $PARENT_DOC_PATH"
echo "Path of child docs: $CHILD_DOCS_PATH"
echo "Path of build target: $BUILD_TARGET_PATH"

# Check if provided parent docu path is a valid.
if [ ! -d "$PARENT_DOC_PATH" ]; then
  echo "Error: $PARENT_DOC_PATH is not a valid directory."
  exit 1
fi

# Check if provided parent docu path is a valid.
if [ ! -d "$CHILD_DOCS_PATH" ]; then
  echo "Error: $CHILD_DOCS_PATH is not a valid directory."
  exit 1
fi

# Create the build target directory if it doesn't exist.
mkdir -p ${BUILD_TARGET_PATH}

# Check if provided build target path is a valid.
if [ ! -d "$BUILD_TARGET_PATH" ]; then
  echo "Error: $BUILD_TARGET_PATH is not a valid directory."
  exit 1
fi

# Build the parent documentation.
echo "---------------"
echo "Start build parent"

cd $PARENT_DOC_PATH
mkdocs build -d ${BUILD_TARGET_PATH}

echo "End build parent"

# Handle child documentations.
for child_path in "$CHILD_DOCS_PATH"/*; do
  # Check if child documentation path is a valid directory.
  if [ -d "${child_path}" ]; then
    echo "---------------"
    echo "Start build ${child_path}"

    # Switch child documentation path.
    cd ${child_path}

    # Define target path child documentation.
    CHILD_BUILD_TARGET_PATH=${BUILD_TARGET_PATH}/$(basename ${child_path})

    # Build child documentation.
    mkdocs build -d ${CHILD_BUILD_TARGET_PATH}

    # Use assets, stylesheets, javascript, and css of parent documentation instead of the clone from the child documentation.
    find ${CHILD_BUILD_TARGET_PATH} -name "*.html" -exec sed -i 's#\("\(\.\./\)*\|"/\)\(assets\|stylesheets\|js\|css\)#\1../\3#g' {} \;

    # Remove the all directories in the child documentation that are not needed.
    rm -rf ${CHILD_BUILD_TARGET_PATH}/assets
    rm -rf ${CHILD_BUILD_TARGET_PATH}/stylesheets
    rm -rf ${CHILD_BUILD_TARGET_PATH}/overrides
    rm -rf ${CHILD_BUILD_TARGET_PATH}/misc
    rm -rf ${CHILD_BUILD_TARGET_PATH}/js
    rm -rf ${CHILD_BUILD_TARGET_PATH}/css
    rm -rf ${CHILD_BUILD_TARGET_PATH}/overrides

    # Remove the 404.html file in the root of the child documentation.
    rm -f ${CHILD_BUILD_TARGET_PATH}/404.html

    echo "End build ${child_path}"
  else
    echo "${child_path} cannot be found"
    exit 1
  fi
done
