# Editing the documentation

This site is built with [Zensical](https://zensical.org/). Markdown pages and
the `zensical.toml` configuration live in `docs/`.

Fill in `site_url` in `docs/zensical.toml` when hosting is configured. The
repository link defaults to the project's repository in the PSI Gitea `bec`
organization; update it if the repository is hosted elsewhere.
Set `tool.bec.docs_enabled` to
`true` in `pyproject.toml` to indicate that this project uses the documentation.
The separate `.gitea/workflows/rtd_deploy.yml` workflow checks this flag before
triggering Read the Docs on pushes to `main` or manual runs. Set the repository
secrets `RTD_WEBHOOK_URL` and `RTD_TOKEN` using the webhook details from your
Read the Docs project. The `.readthedocs.yaml` configuration installs the docs
dependencies, builds from `docs/zensical.toml`, and copies the site to Read the
Docs' HTML output directory.

## Preview locally

Run these commands from the repository root:

```bash
python -m venv .venv-docs
source .venv-docs/bin/activate
python -m pip install -e '.[docs]'
cd docs
zensical serve
```

Open the local URL printed by Zensical. The preview reloads after edits;
stop it with ++ctrl+c++.

To build the static site from `docs/`:

```bash
zensical build --strict
```

Output is written to `docs/site/`, which is ignored by Git.

## Adding a page

1. Create a Markdown file in the appropriate section, starting with one H1 heading.
2. Add its path to `project.nav` in `docs/zensical.toml`, relative to `docs/`.
3. Link to it from the relevant section overview.
4. Preview the page and check its links.

Use relative links to Markdown files. Place images and other assets inside
`docs/`. The `docs/plans/` directory is excluded from the published site and
can hold working notes.

## Markdown conventions

Tag fenced code blocks with a language, such as `python` or `bash`, for syntax
highlighting and copy buttons. Leave a blank line before lists and tables.
Indent nested content inside list items by four spaces.

Use admonitions for callouts:

```markdown
!!! note
    Add a helpful note here.
```

Content tabs, task lists, keyboard shortcuts such as `++ctrl+c++`, and heading
permalinks are also enabled in the configuration.
