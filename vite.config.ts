import { defineConfig } from 'vite'
import RailsPlugin from 'vite-plugin-rails'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [
    RailsPlugin({
      envVars: { RAILS_ENV: 'development' }
    }),
    react()
  ],
  server: {
    hmr: {
      host: 'vite.gona.test',
      clientPort: 443
    }
  }
})
