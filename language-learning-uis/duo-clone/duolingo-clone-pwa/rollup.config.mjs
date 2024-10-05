// rollup.config.js
import resolve from '@rollup/plugin-node-resolve';
import commonjs from '@rollup/plugin-commonjs';
import terser from '@rollup/plugin-terser'; 

export default {
  input: 'src/app.js',  // Entry point for your application
  output: {
    file: 'public/bundle.js',  // Output file
    format: 'iife',  // Immediately Invoked Function Expression, suitable for <script> tags
    name: 'App',  // Global variable name for your bundle
  },
  plugins: [
    resolve(),  // Allows Rollup to resolve modules from node_modules
    commonjs(),  // Converts CommonJS modules to ES6
    terser()  // Minifies the bundle for production
  ]
};
