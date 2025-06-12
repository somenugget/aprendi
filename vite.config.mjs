import { defineConfig } from 'vite'
import FullReload from 'vite-plugin-full-reload'
import RubyPlugin from 'vite-plugin-ruby'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [
    tailwindcss(),
    RubyPlugin(),
    FullReload(
      [
        'config/routes.rb',
        'config/locales/**/*',
        'app/views/**/*',
        'app/components/**/*',
      ],
      {
        delay: 250,
      },
    ),
  ],
  server: {
    hmr: {
      port: 3036,
    },
  },
})
