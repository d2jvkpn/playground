import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';

import path from 'path';

// https://vite.dev/config/
export default defineConfig({
  plugins: [vue()],

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
        },
      },
    },
  },
})
