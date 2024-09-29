import { defineConfig } from 'vite';

// https://vitejs.dev/config/
export default defineConfig({
    build: {
        outDir: 'Koha/Plugin/Xyz/Paulderscheid/Pomodoro/assets',
        rollupOptions: {
            input: 'src/index.ts',
            output: {
                entryFileNames: '[name].js',
                chunkFileNames: '[name].js',
                assetFileNames: '[name][extname]',
            },
        },
        target: 'esnext',
        sourcemap: false,
    },
    server: {
        open: '/src/index.html',
        port: 3000,
    }
});
