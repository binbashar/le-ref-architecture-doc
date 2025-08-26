# Contributing to binbash Leverage Documentation

Thank you for your interest in contributing to the **binbash Leverage** documentation! This repository contains the comprehensive documentation for the Leverage ecosystem, and we welcome contributions from the community.

## 📚 About This Repository

This repository contains the source code for the [Leverage documentation website](https://leverage.binbash.co), built with MkDocs Material. The documentation covers:

- **Concepts**: Introduction and core principles
- **Try Leverage**: Getting started guides
- **User Guide**: Comprehensive implementation documentation
- **How It Works**: Architecture deep dives
- **Work With Us**: Community and business information

## 🚀 Quick Start

### Prerequisites

- **Docker**: Required for running the documentation locally
- **Git**: For version control
- **Make**: For running build commands

### Local Development

1. **Fork and Clone**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/le-ref-architecture-doc.git
   cd le-ref-architecture-doc
   ```

2. **Initialize Environment**:
   ```bash
   make init-makefiles  # First time only
   ```

3. **Start Development Server**:
   ```bash
   make docs-live
   ```
   Visit [http://localhost:8000](http://localhost:8000) for live preview.

4. **Check for Issues**:
   ```bash
   make docs-check-dead-links  # Verify all links work
   ```

## 📋 How to Contribute

### 1. Planning Your Contribution

- **Check Issues**: Look for existing [documentation issues](https://github.com/binbashar/le-ref-architecture-doc/issues?q=is%3Aissue+is%3Aopen+label%3Adocumentation)
- **Discuss First**: For major changes, create an issue to discuss your proposal
- **Small Fixes**: Minor corrections can be submitted directly as PRs

### 2. Types of Contributions

#### Content Improvements
- Fix typos, grammar, and formatting
- Improve clarity and readability
- Add missing information
- Update outdated content
- Add practical examples

#### New Documentation
- Tutorials and how-to guides
- Architecture explanations
- Best practices documentation
- Troubleshooting guides

#### Technical Improvements
- Fix broken links
- Improve navigation structure
- Enhance visual elements
- Optimize performance

### 3. Contribution Workflow

1. **Create a Branch**:
   ```bash
   git checkout -b docs/your-improvement-description
   ```

2. **Make Changes**:
   - Edit Markdown files in the `docs/` directory
   - Follow our [style guide](#writing-style-guide)
   - Test changes locally with `make docs-live`

3. **Validate Changes**:
   ```bash
   make docs-check-dead-links
   ```

4. **Commit Changes**:
   ```bash
   git add .
   git commit -m "docs: brief description of changes"
   ```

5. **Submit Pull Request**:
   - Use our [PR template](#pull-request-guidelines)
   - Provide clear description of changes
   - Reference any related issues

## 📝 Writing Style Guide

### General Principles

- **Clear and Concise**: Use simple, direct language
- **User-Focused**: Write from the user's perspective
- **Actionable**: Provide specific, executable instructions
- **Consistent**: Follow existing patterns and terminology

### Formatting Standards

#### Headings
```markdown
# Page Title (H1 - only one per page)
## Main Section (H2)
### Subsection (H3)
#### Details (H4)
```

#### Code Blocks
```markdown
# For shell commands
```bash
leverage aws configure
```

# For configuration files
```yaml
site_name: binbash Leverage
```

# For Terraform
```hcl
resource "aws_instance" "example" {
  ami = "ami-12345678"
}
```
```

#### Links and References
```markdown
# Internal links (preferred)
[Installation Guide](/user-guide/leverage-cli/installation/)

# External links
[AWS Documentation](https://docs.aws.amazon.com/)

# Reference-style links for repeated URLs
[binbash Leverage][leverage-home]

[leverage-home]: https://leverage.binbash.co
```

#### Admonitions
```markdown
!!! info "Information"
    Use for helpful tips and additional information.

!!! warning "Warning"
    Use for important caveats and potential issues.

!!! danger "Important"
    Use for critical information and breaking changes.

!!! example "Example"
    Use for code examples and practical demonstrations.
```

### Content Guidelines

#### Technical Accuracy
- Test all code examples
- Verify command outputs
- Keep version information current
- Reference official sources

#### Terminology
- Use "Leverage" when referring to the entire ecosystem
- Use "Reference Architecture" for the AWS infrastructure code
- Use "Leverage CLI" for the command-line tool
- Be consistent with AWS service names

#### Structure
- Start with overview/introduction
- Provide prerequisites
- Include step-by-step instructions
- Add troubleshooting information
- Link to related documentation

## 🔍 Pull Request Guidelines

### PR Title Format
Use conventional commit format:
```
docs: brief description of changes
docs(section): description for specific section changes
fix(docs): description for bug fixes
feat(docs): description for new features
```

### PR Description Template
```markdown
## Description
Brief description of what this PR changes.

## Type of Change
- [ ] Content improvement (typos, clarity, accuracy)
- [ ] New documentation
- [ ] Technical fix (links, formatting)
- [ ] Structure/navigation improvement

## Testing
- [ ] Tested locally with `make docs-live`
- [ ] Checked for broken links with `make docs-check-dead-links`
- [ ] Verified all code examples work

## Related Issues
Fixes #issue_number (if applicable)
```

### Review Process

1. **Automated Checks**: PRs run through CI/CD validation
2. **Content Review**: Maintainers review for accuracy and style
3. **Technical Review**: Check for broken links and formatting
4. **Approval**: Requires approval from project maintainers
5. **Merge**: Maintainers will merge approved changes

## 🔒 Security Guidelines

### Security-Related Documentation

- **Never include**: Real credentials, private keys, or sensitive information
- **Use placeholders**: `YOUR_AWS_ACCOUNT_ID`, `YOUR_REGION`, etc.
- **Security vulnerabilities**: Report privately to [security@binbash.co](mailto:security@binbash.co)

### Sensitive Content Review

For documentation involving security configurations:
1. Create a private fork for initial development
2. Request security review before making public
3. Follow coordinated disclosure for security-related content

## 🛠️ Project Structure

```
le-ref-architecture-doc/
├── docs/                    # Documentation source files
│   ├── assets/              # Images, diagrams, styles
│   ├── concepts/            # Introduction and concepts
│   ├── try-leverage/        # Getting started guides
│   ├── user-guide/          # Comprehensive documentation
│   ├── how-it-works/        # Architecture details
│   └── work-with-us/        # Community information
├── material/               # Theme customizations
│   └── overrides/           # Custom templates
├── mkdocs.yml              # Site configuration
├── Makefile                # Build automation
└── README.md               # Repository information
```

## Recognition

We appreciate all contributions to the documentation:

- **Contributors**: Listed in commit history and release notes
- **Significant Contributions**: Acknowledged in documentation
- **Outstanding Contributors**: May be invited to join the documentation team

## 📞 Support and Resources

### Getting Help

- **Documentation Issues**: [Create an issue](https://github.com/binbashar/le-ref-architecture-doc/issues/new)
- **Direct Support**: [leverage@binbash.co](mailto:leverage@binbash.co)

### Additional Resources

- [Leverage Documentation](https://leverage.binbash.co) - Published documentation
- [MkDocs Material](https://squidfunk.github.io/mkdocs-material/) - Theme documentation
- [Markdown Guide](https://www.markdownguide.org/) - Markdown syntax reference
- [Conventional Commits](https://www.conventionalcommits.org/) - Commit message format

### Complementary Contributing Guide

For detailed information about contributing to to Other Leverage Framework Projects
inside our ecosystem (not just documentation), see our comprehensive [Contributing Guide](https://leverage.binbash.co/work-with-us/contributing/).

---

**Thank you for helping make Leverage documentation better!** 🚀

Your contributions help users deploy AWS infrastructure faster, more securely, and with greater confidence.
