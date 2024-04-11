// const esbuild = require("esbuild");
import * as esbuild from "esbuild";

const args = process.argv.slice(2);
const watch = args.includes("--watch");
const deploy = args.includes("--deploy");

const loader = {
  // Add loaders for images/fonts/etc, e.g. { '.svg': 'file' }
};

const plugins = [
  // Add and configure plugins here
];

let opts = {
  entryPoints: ["js/app.js", "js/app_tailwind.js"],
  bundle: true,
  target: "es2017",
  outdir: "../priv/static/assets",
  logLevel: "info",
  loader,
  plugins,
};

if (deploy) {
  opts = {
    ...opts,
    minify: true,
  };
}

// const promise = esbuild.build(opts)
const ctx = await esbuild.context(opts);

if (watch) {
  await ctx.watch();
}

await ctx.dispose(); // To free resources
