# Vue 3 + TypeScript + Vite

This template should help get you started developing with Vue 3 and TypeScript in Vite. The template uses Vue 3 `<script setup>` SFCs, check out the [script setup docs](https://v3.vuejs.org/api/sfc-script-setup.html#sfc-script-setup) to learn more.

Learn more about the recommended Project Setup and IDE Support in the [Vue Docs TypeScript Guide](https://vuejs.org/guide/typescript/overview.html#project-setup).


#### ch01. Reference

#### ch02. Setup env
```
# path: .env
PORT=9001

VITE_ENV=local
VITE_BASE=/
VITE_API_URL=localhost:9011
```

#### ch03. Enable path alias
1. vite.config.ts
- "import path from 'path';"
- in defineConfig({...})
```ts
  resolve: {
    alias: {
      '@': path.resolve(__dirname, 'src'),
      // extensions: ['.mjs', '.js', '.ts', '.jsx', '.tsx', '.json', '.vue'],
    },
  },

  css: {
    preprocessorOptions: {
      css: {
        preprocessorOptions: {
          scss: {
            additionalData: `@import "@/assets/scss/base.scss";`,
            javascriptEnabled: true,
          },
        }
      },
    },
  },
```
2. package.json replace scripts.build "vue-tsc -b && vite build" with "vite build"
3. ~~tsconfig.json add "include": ["src/**/*.ts", "src/**/*.d.ts", "src/**/*.tsx", "src/**/*.vue"]~~
