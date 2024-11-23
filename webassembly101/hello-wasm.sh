clang --target=wasm32-wasi -O3 -emit-llvm -c hello.c -o hello.bc
llc -march=wasm32 -filetype=obj -o hello.o hello.bc
clang --target=wasm32-wasi -o hello.wasm hello.o -lc -lm -Wl,--export-all -Wl,--no-entry
