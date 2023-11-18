import { nodeResolve } from "@rollup/plugin-node-resolve";

export default {
  publicDir: "./public",
  build: {
    outDir: "./dist",
  },
  plugins: [nodeResolve()],
};
