# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = "CutiePy"
copyright = "2022, Bobby Chen"
author = "Bobby Chen"
release = "0.1.0"

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    "myst_parser",
    "sphinx.ext.autodoc",
    "sphinx.ext.napoleon",
    "sphinxext.opengraph",
    "sphinx_inline_tabs",
    "sphinx_copybutton",
]

templates_path = ["_templates"]


# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = "furo"
html_static_path = ["_static"]

# Autodoc
autodoc_class_signature = "separated"
autodoc_typehints = "description"
autodoc_member_order = "bysource"

# OpenGraph
ogp_site_url = "https://cutiepy.org/"
ogp_image = "http://cutiepy.org/img/logo.png"
