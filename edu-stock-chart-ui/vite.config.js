import { defineConfig } from 'vite';

export default defineConfig({
  server: {
    port: 5173,
    // /api 로 시작하는 요청은 Spring Boot(8080)로 넘긴다
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true,
      },
    },
  },
  build: {
    outDir: 'dist',
  },
});
