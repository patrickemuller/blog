# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal blog application built with Rails 8. Posts are written in Markdown with syntax highlighting via Rouge, and URLs are generated using FriendlyId slugs. Full-text search is powered by Searchkick (OpenSearch/Elasticsearch). Authentication uses Devise with minimal configuration (users can only sign in, not register).

## Development Commands

### Running the Application

```bash
# Start development server with Tailwind CSS watcher
bin/dev

# Start Rails server only
bin/rails server

# Access development server at http://localhost:3000
```

### Testing

```bash
# Run all tests
bin/rails test
```

### Database

```bash
# Run migrations
bin/rails db:migrate

# Rollback last migration
bin/rails db:rollback

# Reset database (drop, create, migrate, seed)
bin/rails db:reset
```

### Code Quality

```bash
# Run RuboCop linter (uses rubocop-rails-omakase)
bundle exec rubocop

# Auto-correct violations
bundle exec rubocop -A

# Run Brakeman security scanner
bundle exec brakeman
```

### Search Indexing

```bash
# Reindex all posts for Searchkick
bin/rails searchkick:reindex CLASS=Post
```

## Architecture

### Markdown Rendering

Posts are written in Markdown and rendered to HTML with syntax highlighting:

- `Post#formatted_body` (app/models/post.rb:12) renders Markdown using Redcarpet
- `SyntaxHighlighting` (app/parsers/syntax_highlighting.rb) integrates Rouge for code highlighting
- Output is sanitized to allow only safe HTML tags and attributes

### URL Slugs

Posts use FriendlyId for human-readable URLs:

- `Post.friendly.find(params[:id])` (app/controllers/posts_controller.rb:64) finds by slug or ID
- Slugs are automatically generated from post titles
- Stored in dedicated `friendly_id_slugs` table for history tracking

### Full-Text Search

Posts are searchable using Searchkick:

- `Post.search(query)` (app/controllers/posts_controller.rb:7) performs full-text search
- Configured with `word_start` and `word_middle` matching on title and body
- Search requires OpenSearch or Elasticsearch running locally or configured via environment

### Authentication

- Uses Devise for user authentication (`User` model)
- Registration disabled via `skip: [:registrations]` in routes
- Only authenticated users can create, edit, or delete posts
- Public users can view all posts

## Key Models

- **Post** - Blog posts with Markdown content
  - Validates presence of `title` and `body`
  - Uses FriendlyId for slug generation from title
  - Indexed by Searchkick for full-text search
  - `formatted_body` method renders Markdown with syntax highlighting

- **User** - Authenticated users who can manage posts
  - Minimal Devise configuration (database authenticatable, rememberable, validatable)
  - No registration - users must be created directly in database

## Styling

- Uses Tailwind CSS via `tailwindcss-rails`
- Development watcher automatically rebuilds styles via `bin/dev`
- Assets served via Propshaft (modern Rails asset pipeline)
