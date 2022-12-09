#!/bin/bash
quarto render docs
quarto render docs/ --to gfm --output-dir markdown/