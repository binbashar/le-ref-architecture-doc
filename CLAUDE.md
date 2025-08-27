# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the documentation repository for **binbash Leverage™**, a comprehensive AWS cloud infrastructure reference architecture built with MkDocs Material. The site is deployed at https://leverage.binbash.co and documents a production-ready AWS infrastructure-as-code ecosystem.

## Common Commands

### Development
```bash
make init-makefiles         # Initialize external makefile dependencies (first time only)
make docs-live              # Start local development server at http://localhost:8000
make docs-check-dead-links  # Check if documentation contains dead links
make help                   # Show all available commands
```

### Deployment
```bash
make docs-deploy-gh   # Deploy to GitHub Pages
```

### Additional Available Commands
```bash
make circleci-validate-config    # Validate CircleCI configuration
make changelog-init             # Initialize git-chglog
make changelog-{major|minor|patch}  # Generate changelog for release
make release-{major|minor|patch}    # Create releases
```

## Architecture and Structure

### Build System
- **MkDocs Material**: Static site generator with Docker-based builds
- **Modular Makefiles**: External makefile dependencies from `le-dev-makefiles` (v0.2.18)
- **Docker Required**: All operations require Docker daemon running

### Key Directories
- `docs/` - Markdown documentation source files
- `docs/assets/` - Images, diagrams, stylesheets, and static assets
- `docs/assets/diagrams/editable/` - Editable DrawIO diagram sources
- `material/overrides/` - Custom MkDocs Material theme templates
- `site/` - Generated static HTML output (auto-generated)
- `@bin/makefiles/` - External makefile dependencies (auto-generated)

### Configuration Files
- `mkdocs.yml` - Complete MkDocs configuration with navigation structure
- `Makefile` - Build automation entry point
- `.cursor/rules/doc-binbash-leverage.mdc` - AI assistant guidelines for the Leverage documentation ecosystem

## Content Organization

The documentation follows a structured approach:

1. **Concepts** - Introduction and core concepts
2. **Try Leverage** - Getting started guides
3. **User Guide** - Comprehensive documentation covering:
   - AWS Reference Architecture
   - Leverage CLI usage
   - Infrastructure library modules
   - Troubleshooting guides
4. **Work With Us** - Community and business information

## Development Workflow

### Local Development
1. Ensure Docker daemon is running
2. Run `make init-makefiles` (first time only)
3. Run `make docs-live` for real-time preview at http://localhost:8000
4. Edit Markdown files in `docs/` directory
5. Changes appear automatically in browser

### Content Guidelines
- Follow existing content structure and navigation defined in `mkdocs.yml`
- Place images in `docs/assets/images/` with appropriate subdirectories
- Use DrawIO for editable diagrams, store sources in `docs/assets/diagrams/editable/`
- Follow binbash Leverage terminology and concepts as defined in `.cursor/rules/doc-binbash-leverage.mdc`

### Deployment Process
- **Branches**: `master` for source, `gh-pages` for deployed site
- **CI/CD**: Automatic deployment via CircleCI when merged to master
- **Manual Deploy**: Use `make docs-deploy-gh` if needed

## Technical Notes

### Dependencies
- Docker container uses `squidfunk/mkdocs-material` image
- External makefiles from `binbashar/le-dev-makefiles` repository
- Material theme customizations in `material/` directory

### Site Configuration
- Multi-language support (English/Spanish)
- Google Analytics integration
- Dark/light mode toggle
- Navigation tabs and search functionality
- Custom favicon and branding

### Diagram Management
- Editable sources in `docs/assets/diagrams/editable/` (DrawIO format)
- Some diagrams exported from shared Google Slides presentation
- Export PNGs to `docs/assets/images/diagrams/` for documentation use
- Use consistent naming conventions for diagrams across the documentation

## Important Instructions for AI Assistants

### binbash Leverage Context
This documentation covers the **binbash Leverage™** ecosystem - an enterprise-grade AWS infrastructure-as-code framework. When working with this repository, you should understand:

- **Reference Architecture**: Production-ready, multi-account AWS infrastructure following AWS Well-Architected Framework
- **Infrastructure Library**: 50+ Terraform/OpenTofu modules for AWS services
- **Leverage CLI**: Python-based orchestration tool for managing infrastructure lifecycle
- **Multi-layered Architecture**: Network, Security, Shared, and Apps layers with clear separation of concerns
- **Multi-account Strategy**: Management, Security, Shared, and Application accounts with AWS Organizations

### Content Guidelines
- Follow binbash Leverage terminology and architectural concepts as defined in `.cursor/rules/doc-binbash-leverage.mdc`
- Maintain consistency with existing documentation structure and navigation
- Reference the comprehensive knowledge base in `.cursor/rules/doc-binbash-leverage.mdc` for accurate technical details
- Always consider the multi-account, multi-layer context when making recommendations