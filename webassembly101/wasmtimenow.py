from wasmtime import Store, Module, Instance, Func, FuncType


# Import the custom loader for `*.wasm` files
import wasmtime.loader
# Assuming `your_wasm_file.wasm` is in the python load path...
import hello 
import fast_align

# Now you're compiled and instantiated and ready to go!
result = hello.main(1,1)
print(result)
fast_align.main()
