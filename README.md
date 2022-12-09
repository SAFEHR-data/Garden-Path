# FlowEHR end user documentation
Documentation built using [Quarto](https://quarto.org/) with `.qmd` and `.ipynb` files as source material.

## Repository structure
- Quarto `.qmd` documentation can be found within `docs/`
    - GitHub-renderable markdown documentation is in `docs/markdown`
- Jupyter notebooks with worked examples to be used within the TRE are given in `docs/notebooks`
    - corresponsing `requirements.txt` files are given per-notebook

## Developing documentation

### First-time setup
1. [Install Quarto](https://quarto.org/docs/get-started/)
2. Create a Python virtual environment
3. Install requirements with `pip install -r requirements.txt`
4. Install pre-commit hooks with `./bin/setup.sh`

### Create html docs locally
Calling `bin/render.sh` creates html docs within `docs/_site`
- Open `docs/_site/index.html` to browse the docs in html
- Markdown `.md` docs are created in `docs/markdown/`

### Create html docs within vscode
After installing the [VSCode extension for Quarto](https://marketplace.visualstudio.com/items?itemName=quarto.quarto), open a terminal within VSCode and run
```bash
quarto preview /Users/hmoss/End-User-Docs/README.md --no-browser --no-watch-input
s
```
to preview created documents within VSCode.