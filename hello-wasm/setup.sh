#!/bin/bash

# Exit the script on any error
set -e

# Function to install Emscripten if it's not installed
install_emscripten() {
  if [ ! -d "$HOME/emsdk" ]; then
    echo "Installing Emscripten SDK..."
    git clone https://github.com/emscripten-core/emsdk.git $HOME/emsdk
    cd $HOME/emsdk
    ./emsdk install latest
    ./emsdk activate latest
    source ./emsdk_env.sh
  else
    echo "Emscripten SDK already installed."
  fi
}

# Function to create project structure
setup_project() {
  PROJECT_NAME=$1
  echo "Setting up project: $PROJECT_NAME..."

  mkdir -p $PROJECT_NAME/src
  mkdir -p $PROJECT_NAME/build
  cd $PROJECT_NAME

  # Create a sample C file
  cat << EOF > src/main.c
#include <stdio.h>

int main() {
    printf("Hello, WebAssembly!\\n");
    return 0;
}
EOF

  echo "Project structure created."
}

# Function to compile C to WebAssembly using Emscripten
compile_wasm() {
  PROJECT_NAME=$1
  # cd $PROJECT_NAME

  echo "Compiling C code to WebAssembly..."
  source $HOME/emsdk/emsdk_env.sh

  emcc src/main.c -o build/main.html \
      -s WASM=1 \
      -s "EXPORTED_FUNCTIONS=['_main']" \
      -s "EXTRA_EXPORTED_RUNTIME_METHODS=['ccall', 'cwrap']"

  echo "Compilation complete. Check the build directory for the output files."
}

# Check if project name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <project-name>"
  exit 1
fi

PROJECT_NAME=$1

# Install Emscripten if necessary
# install_emscripten

# Set up the project
# setup_project $PROJECT_NAME

# Compile the C code to WebAssembly
compile_wasm $PROJECT_NAME

echo "Setup complete. Open build/main.html in a browser to view the output."

