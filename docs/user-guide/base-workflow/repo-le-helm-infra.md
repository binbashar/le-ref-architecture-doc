# Typical Workflow

## Add or remove apps to an environment
- Go to the directory of the environment you need to work with (shared, devstg, prd, ...)
- Edit `helmsman.yaml` to add/remove any charts you need
- Run helmsman in plan mode to preview your changes: `make plan`
- Review the plan to make sure helmsman will apply the changes you expect
- Run helmsman in apply mode: `make apply`