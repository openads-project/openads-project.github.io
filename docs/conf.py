# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'Open Automated Driving Systems'
copyright = '2026, Institute for Automotive Engineering (ika) - RWTH Aachen University'
author = 'Institute for Automotive Engineering (ika), RWTH Aachen University'
release = '1.0.0'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    'myst_parser',  # Support for Markdown
    'sphinx_design',
    'sphinx.ext.autodoc',
    'sphinx.ext.napoleon',
    'sphinx.ext.viewcode',
    'sphinx.ext.intersphinx',
]

templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']

# MyST Parser configuration
myst_enable_extensions = [
    "colon_fence",
    "deflist",
    "html_image",
    "attrs_inline"
]
myst_heading_anchors = 3

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'pydata_sphinx_theme'
# html_static_path = ['_static']

html_sidebars = {
    'start/start': [],
    'design/design': [],
    'openadshowcases/openadshowcases': [],
    'openadsuite/tools': [],
}

# PyData Theme configuration
html_theme_options = {
    "github_url": "https://github.com/openads-project/openads-project.github.io",
    "use_edit_page_button": True,
    "show_toc_level": 2,
    "navigation_depth": 3,
    "navbar_align": "left",
    "header_links_before_dropdown": 8,
    "logo": {
        "image_light": "assets/openads.ico",
        "image_dark": "assets/openads.ico"
    }
}

html_favicon = 'assets/openads.ico'

html_context = {
    "github_user": "openads-project",
    "github_repo": "openads-project.github.io",
    "github_version": "init",  # TODO: change to main
    "doc_path": "docs",
}

html_show_sourcelink = False

# Intersphinx configuration
intersphinx_mapping = {
    'python': ('https://docs.python.org/3', None),
}
