import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
  plugins: [
    vue({
      template: {
        compilerOptions: {
          isCustomElement: tag => ['vue-advanced-chat', 'emoji-picker'].includes(tag)
        }
      }
    })
  ]
});
