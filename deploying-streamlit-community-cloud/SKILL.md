---
name: deploying-streamlit-community-cloud
description: Deploys Streamlit apps to Streamlit Community Cloud using the Streamlit CLI. Use when publishing an app or turning a local project into a GitHub repo for deployment.
---

# Deploying to Streamlit Community Cloud

Use this skill to deploy a Streamlit app to Streamlit Community Cloud via the
`streamlit cloud deploy` CLI command (Streamlit 1.54+).

## When to activate

- Publishing a Streamlit app to Community Cloud
- Converting a local project into a GitHub repo for deployment
- Triggering a deploy from the CLI

## Requirements

- **Streamlit 1.54+** (for `streamlit cloud deploy`)
- A GitHub repo with your app code
- A Community Cloud account connected to GitHub
- `gh` CLI installed and authenticated if a repo needs to be created

## Deployment flow

### 1) Verify Streamlit version

```bash
streamlit version
```

If `streamlit cloud deploy` is missing or Streamlit is <1.54, **tell the user
explicitly that they need Streamlit 1.54 for this skill to work** and ask them
to upgrade before continuing.

### 2) Check whether the current directory is a GitHub repo

```bash
git rev-parse --is-inside-work-tree
git remote -v
```

If the repo has a GitHub remote (URL contains `github.com`), run:

```bash
streamlit cloud deploy
```

### 3) If not a GitHub repo, offer to create one

If the current directory is not a git repo, or it has no GitHub remote, offer
to initialize and push it to the user's GitHub account. Then:

```bash
git init
git add -A
git commit -m "Initial commit"
gh auth status
gh repo create <repo-name> --source=. --remote=origin --push
```

Notes:

- If `gh auth status` fails, run `gh auth login` first.
- Use `--public` or `--private` depending on the user's preference.
- If there are already commits, skip the initial commit step.

Once the GitHub repo is created and pushed, run:

```bash
streamlit cloud deploy
```

## What the command does

`streamlit cloud deploy` opens the Streamlit Community Cloud deploy page with
the repository, branch, and app file pre-filled for the current GitHub repo.

## References

- [Deploy your app on Community Cloud](https://docs.streamlit.io/deploy/streamlit-community-cloud/deploy-your-app/deploy)
