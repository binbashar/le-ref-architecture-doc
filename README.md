<a href="https://github.com/binbashar">
    <img src="https://raw.githubusercontent.com/binbashar/le-ref-architecture-doc/master/docs/assets/images/logos/binbash-leverage-banner.png" width="1032" align="left" alt="Binbash"/>
</a>
<br clear="left"/>

# Binbash Leverage™ Documentation

## Overview
This repository contains all files used to create 
[Binbash Leverage Reference Documentation](https://leverage.binbash.com.ar)

### Branches
- `master`   --> contains the source code
- `gh-pages` --> deployable (builded) version

## Deployed Documentation
Check it out [here](https://leverage.binbash.com.ar/).

## Development / Contributing

1. Clone the repo locally
2. Config your MkDocs env including the navigation tree directory via `mkdocs.yml` file.
3. Spin up your MkDocs local dev web server environment (`http://localhost:8000`) (real time updates we'll be shown) (docker daemon needed) via `Makefile` cmd
```bash
 make init-makefiles # needed only the first time
 make docs-live          
```
4. Update necessary `*.md` files inside the `docs/` folder and check your updates through the local environment
browser 
5. And create your PR from `BBL-XXX` to `master` branch.
6. The Github Pages site [https://leverage.binbash.com.ar](https://leverage.binbash.com.ar/) will be automatically deployed 
via CircleCI job to the `gh-pages` branch (currently being built from this branch).
    - It currently uses the `make docs-deploy-gh` cmd which could be locally executed if needed too.

### TODO
- Several sections needs completion or update. 

## About Diagrams

Some of them have editable version under `docs/assets/diagrams/editable`.

Others are directly exported from `https://docs.google.com/presentation/d/1t2SWgWlGvuIOqYHkpzxQSVLafI_MCsA3gNz6Kkyf6TE/edit#slide=id.p6`.
