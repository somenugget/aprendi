import { defineConfig } from 'vite'
import FullReload from 'vite-plugin-full-reload'
import RubyPlugin from 'vite-plugin-ruby'

export default defineConfig({
  plugins: [
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
