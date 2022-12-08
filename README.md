# FlowEHR end user documentation

## Create html docs locally
Calling `bin/render.sh` creates html docs within `docs/_site`. Open `docs/_site/index.html` to browse the docs.

## Create html docs within vscode
After installing the [VSCode extension for Quarto](https://marketplace.visualstudio.com/items?itemName=quarto.quarto), open a terminal within VSCode and run
```bash
quarto preview /Users/hmoss/End-User-Docs/README.md --no-browser --no-watch-input
s
```
to preview created documents within VSCode.