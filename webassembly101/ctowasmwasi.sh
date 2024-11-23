/opt/wasi-sdk/bin/clang --target=wasm32-wasi -O3 -emit-llvm -c hello.c -o hello.bc --sysroot=/opt/wasi-sdk/share/wasi-sysroot
llc -march=wasm32 -filetype=obj -o hello.o hello.bc
/opt/wasi-sdk/bin/clang  --target=wasm32-wasi -o hello.wasm hello.o -lc -lm -Wl,--export-all -Wl,--no-entry --sysroot=/opt/wasi-sdk/share/wasi-sysroot
