BASE_FOLDER=./wasi-sdk-24.0-x86_64-linux
$BASE_FOLDER/bin/clang --target=wasm32-wasi -O3 -emit-llvm -c hello.c -o hello.bc --sysroot=$BASE_FOLDER/share/wasi-sysroot
llc -march=wasm32 -filetype=obj -o hello.o hello.bc
$BASE_FOLDER/bin/clang  --target=wasm32-wasi -o hello.wasm hello.o -lc -lm -Wl,--export-all -Wl,--no-entry --sysroot=$BASE_FOLDER/share/wasi-sysroot
