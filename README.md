<a href="https://github.com/binbashar">
    <img src="https://raw.githubusercontent.com/binbashar/le-ref-architecture-doc/master/docs/assets/images/logos/binbash-leverage-banner.png" width="1032" align="left" alt="binbash"/>
</a>
<br clear="left"/>

# binbash Leverage™ Documentation

[![Documentation Status](https://img.shields.io/badge/docs-leverage.binbash.co-blue)](https://leverage.binbash.co)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![GitHub Issues](https://img.shields.io/github/issues/binbashar/le-ref-architecture-doc)](https://github.com/binbashar/le-ref-architecture-doc/issues)

## Overview

This repository contains the comprehensive documentation for **binbash Leverage™**, an enterprise-grade AWS infrastructure-as-code ecosystem that accelerates cloud deployment by up to 10x.

**Live Documentation:** [leverage.binbash.co](https://leverage.binbash.co)

### What is Leverage?

Leverage is a complete AWS cloud infrastructure framework consisting of:

- **🏗️ Reference Architecture**: Production-ready, multi-account AWS infrastructure following AWS Well-Architected Framework
- **📚 Infrastructure Library**: 50+ Terraform/OpenTofu modules covering all AWS services
- **⚡ CLI Tool**: Python-based orchestration tool for infrastructure lifecycle management

## 🚀 Getting Started

### Documentation Structure

The documentation covers everything you need to know about Leverage:

- **Concepts**: Core principles and architecture overview
- **Try Leverage**: Step-by-step tutorial to deploy your first AWS infrastructure
- **User Guide**: Comprehensive implementation guides for all components
- **How It Works**: Deep dives into architecture and design decisions
- **Work With Us**: Community, support, and contribution information

### Repository Structure

- **`master` branch**: Documentation source code (Markdown files)
- **`gh-pages` branch**: Auto-deployed documentation site
- **`docs/`**: All documentation content organized by topic
- **`material/`**: Custom MkDocs Material theme overrides
- **`mkdocs.yml`**: Site configuration and navigation structure

## 🤝 Contributing

We welcome contributions to improve the documentation and the entire binbash Leverage ecosystem!

### Contributing to Documentation

1. **Fork** this repository
2. **Clone** your fork and set up the development environment:
   ```bash
   git clone https://github.com/YOUR_USERNAME/le-ref-architecture-doc.git
   cd le-ref-architecture-doc
   make init-makefiles  # First time only
   make docs-live       # Visit http://localhost:8000
   ```
3. **Make your changes** and test locally
4. **Submit a pull request** with clear description

### Contributing to Other Leverage Projects

Interested in contributing to the broader Leverage ecosystem?

- **[Reference Architecture](https://github.com/binbashar/le-tf-infra-aws)**: AWS infrastructure code
- **[CLI Tool](https://github.com/binbashar/leverage)**: Command-line interface
- **[Terraform Modules](https://github.com/topics/binbash-terraform)**: 50+ AWS modules

**Detailed Guidelines**: See our [Contributing Guide](CONTRIBUTING.md) for documentation-specific guidelines, or visit our [comprehensive contributing guide](https://leverage.binbash.co/work-with-us/contributing/) for all projects. 

## 🛠️ Development

### Technology Stack

- **Documentation Generator**: [MkDocs Material](https://squidfunk.github.io/mkdocs-material/)
- **Development Environment**: Docker-based for consistency
- **Auto-Deployment**: CircleCI pipeline to GitHub Pages
- **Theme**: Custom Material theme with binbash branding

### Available Commands

```bash
make help                    # Show all available commands
make init-makefiles         # Initialize external makefile dependencies
make docs-live              # Start local development server
make docs-deploy-gh         # Deploy to GitHub Pages
make docs-check-dead-links  # Validate all links (requires GNU tools)
```

### Diagrams and Assets

- **Editable Diagrams**: Located in `docs/assets/diagrams/editable/` (DrawIO format)
- **Static Images**: Exported diagrams and screenshots in `docs/assets/images/`
- **Logos**: Brand assets in `docs/assets/images/logos/`

## 📞 Support

- **Documentation**: [leverage.binbash.co](https://leverage.binbash.co)
- **Community**: [GitHub Discussions](https://github.com/binbashar/leverage/discussions)
- **Issues**: [Report bugs or request features](https://github.com/binbashar/le-ref-architecture-doc/issues)
- **Contact**: [leverage@binbash.co](mailto:leverage@binbash.co)

## 📄 License

Copyright © 2017-2025 [binbash](https://www.binbash.co). This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE.md) file for details.

---

**Made with ❤️ by the [binbash](https://www.binbash.co) team**
