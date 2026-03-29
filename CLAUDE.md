# Aprendi — notes for Claude

Aprendi is a Rails app for learning vocabulary: study sets, terms, folders, tests, streaks, reminders, and optional OAuth (Google, Facebook, Twitter).

## Stack

- **Ruby** 3.4.4 · **Rails** 8.1 · **PostgreSQL**
- **Hotwire**: Turbo + Stimulus (`app/frontend`, Vite)
- **CSS**: Tailwind CSS 4 (`app/frontend/entrypoints/tailwind.css`, Vite)
- **UI**: ViewComponent (`app/components`), shared pieces under `UI::` (e.g. `UI::ButtonComponent`, `UI::EmptyStateComponent`)
- **Auth**: Devise + OmniAuth
- **Jobs**: Good Job (`/good_job` for admin email in env)
- **Component previews**: Lookbook in development (`/lookbook`)

## Layout of the codebase

| Area | Path |
|------|------|
| Controllers | `app/controllers/` |
| Models | `app/models/` |
| ERB views | `app/views/` |
| ViewComponents | `app/components/` |
| Stimulus | `app/frontend/controllers/` |
| Vite entrypoints | `app/frontend/entrypoints/` |
| Background work | `app/jobs/`, `app/services/` (ServiceActor, etc.) |
| Specs | `spec/` (RSpec, FactoryBot, Capybara/Cuprite) |

## Conventions

- **Components**: Prefer `ApplicationComponent` subclasses; many use `extend Dry::Initializer` and `option` for constructor args. Reuse `UI::*` before adding new primitives.
- **Strong params**: Controllers often use `params.expect(...)` (Rails 8 style). Keep permitted keys tight.
- **I18n**: Copy in `config/locales/en.yml` where the app already uses `t()` / `I18n.t`.

## When changing the UI

- Match existing Tailwind / Flowbite patterns and dark mode classes (`dark:`) used nearby.
- Empty list UX: use `UI::EmptyStateComponent` with `message`, `action_text`, and `action_href`.

## General rules

- Don't run `bundle exec zeitwerk:check`
- Run `bundle exec rubocop -A` and tests after the task is done
