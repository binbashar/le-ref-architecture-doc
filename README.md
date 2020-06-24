<div align="center">
    <img src="./docs/assets/images/logos/binbash.png" 
    alt="binbash" width="250"/>
</div>
<div align="right">
  <img src="./docs/assets/images/logos/binbash-leverage-terraform.png"
  alt="leverage" width="130"/>
</div>

# Binbash Leverage Reference Architecture

## Overview
This repository contains all files used to create Binbash Leverage Reference Documentation

## Documentation
Check it out [here](https://leverage.binbash.com.ar-doc/).

## Development / Contributing

1. Clone the repo locally
2. Config your MkDocs env including the navigation tree directory via `mkdocs.yml` file.
3. Spin up your MkDocs local dev web server environment (`http://localhost:8000`) (real time updates we'll be shown) via `Makefile` cmd
```bash
 make docs-live          
```
4. Update necessary `*.md` files inside the `docs/` folder and check your updates through the browser
5. To deploy (via new `gh-pages` branch) use:
```bash
make docs-deploy-gh
``` 
6. And create your PR from `gb-pages` to `master` branch.

### TODO
- Improve readme
- Configure CircleCI for relese mgmt
- Several sections needs completion or update 


