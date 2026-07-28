"""Sphinx directive that embeds an SVG inline and wraps it in a zoomable viewer.

An SVG referenced as ``![alt](file.svg)`` becomes an ``<img>`` tag, and browsers
render such images as static pictures: hyperlinks inside the SVG are not
clickable. Embedding the SVG markup directly into the page keeps those links
alive. The accompanying ``svg-viewer.js`` / ``svg-viewer.css`` then add zoom,
pan and an expanded overlay on top of the inlined graphic.

Usage in Markdown::

    ```{svg-viewer} ./architecture.drawio.svg
    :alt: Safety Architecture Diagram
    ```
"""

from __future__ import annotations

import re
from pathlib import Path

from docutils import nodes
from docutils.parsers.rst import directives
from sphinx.application import Sphinx
from sphinx.util import logging
from sphinx.util.docutils import SphinxDirective

logger = logging.getLogger(__name__)

_XML_PROLOG = re.compile(r"<\?xml[^>]*\?>|<!DOCTYPE[^>]*>", re.IGNORECASE)
_SVG_OPEN_TAG = re.compile(r"<svg\b[^>]*>", re.IGNORECASE)
_SVG_SIZE_ATTR = re.compile(r'\s(?:width|height)="[^"]*"', re.IGNORECASE)
_ID_ATTR = re.compile(r'\sid="([^"]+)"')


def _namespace_ids(svg: str, prefix: str) -> str:
    """Prefix all element IDs so several inlined SVGs cannot collide.

    Inlining moves the SVG into the page's global ID space, where a duplicate
    ``id`` would make gradients, clip paths or markers resolve to the wrong
    element.
    """
    ids = set(_ID_ATTR.findall(svg))
    for id_ in sorted(ids, key=len, reverse=True):
        quoted = re.escape(id_)
        svg = re.sub(rf'(\sid=")({quoted})(")', rf"\g<1>{prefix}\g<2>\g<3>", svg)
        svg = re.sub(rf"(url\(#){quoted}(\))", rf"\g<1>{prefix}{id_}\g<2>", svg)
        svg = re.sub(
            rf'((?:xlink:)?href="#){quoted}(")', rf"\g<1>{prefix}{id_}\g<2>", svg
        )
    return svg


def _prepare_svg(raw: str, prefix: str, alt: str) -> str:
    """Turn a standalone SVG file into markup that can be inlined into HTML."""
    svg = _XML_PROLOG.sub("", raw).strip()

    match = _SVG_OPEN_TAG.search(svg)
    if match is None:
        raise ValueError("no <svg> element found")

    open_tag = match.group(0)
    # Drop the intrinsic size so the graphic scales with its container; the
    # viewBox that drawio exports keeps the aspect ratio intact.
    new_tag = _SVG_SIZE_ATTR.sub("", open_tag)
    if alt:
        new_tag = new_tag[:-1] + f' role="img" aria-label="{alt}">'
    svg = svg[: match.start()] + new_tag + svg[match.end() :]

    return _namespace_ids(svg, prefix)


class SVGViewerDirective(SphinxDirective):
    """Embed an SVG inline, wrapped in an interactive zoom/pan viewer."""

    required_arguments = 1
    final_argument_whitespace = True
    has_content = False
    option_spec = {
        "alt": directives.unchanged,
        "caption": directives.unchanged,
        "class": directives.class_option,
    }

    def run(self) -> list[nodes.Node]:
        rel_path, abs_path = self.env.relfn2path(self.arguments[0].strip())
        self.env.note_dependency(rel_path)

        try:
            raw = Path(abs_path).read_text(encoding="utf-8")
        except OSError as err:
            logger.warning(
                "svg-viewer: cannot read %s (%s)", abs_path, err, location=self.get_location()
            )
            return [nodes.Text("")]

        alt = self.options.get("alt", "")
        prefix = f"sv{self.env.new_serialno('svg-viewer')}-"

        try:
            svg = _prepare_svg(raw, prefix, alt)
        except ValueError as err:
            logger.warning(
                "svg-viewer: %s in %s", err, abs_path, location=self.get_location()
            )
            return [nodes.Text("")]

        classes = " ".join(["svg-viewer", *self.options.get("class", [])])
        caption = self.options.get("caption", "")
        caption_html = (
            f'<figcaption class="svg-viewer__caption">{caption}</figcaption>'
            if caption
            else ""
        )

        html = f"""<figure class="{classes}" data-svg-viewer>
  <div class="svg-viewer__stage" tabindex="0" role="group"
       aria-label="{alt or 'Diagram'} – interactive viewer">
    <div class="svg-viewer__canvas">{svg}</div>
    <div class="svg-viewer__toolbar" role="toolbar" aria-label="Diagram controls">
      <button type="button" class="svg-viewer__btn" data-action="zoom-out"
              title="Zoom out" aria-label="Zoom out">&#8722;</button>
      <button type="button" class="svg-viewer__btn" data-action="reset"
              title="Reset view" aria-label="Reset view">&#8634;</button>
      <button type="button" class="svg-viewer__btn" data-action="zoom-in"
              title="Zoom in" aria-label="Zoom in">&#43;</button>
      <button type="button" class="svg-viewer__btn" data-action="expand"
              title="Enlarge" aria-label="Enlarge diagram">&#10530;</button>
    </div>
  </div>
  <p class="svg-viewer__hint">Click the diagram to enlarge. Links inside the
  diagram stay clickable.</p>
  {caption_html}
</figure>"""

        return [nodes.raw("", html, format="html")]


def _register_assets(app: Sphinx) -> None:
    """Make the viewer's own CSS/JS available without touching html_static_path."""
    app.config.html_static_path.append(str(Path(__file__).parent / "static"))


def setup(app: Sphinx) -> dict:
    app.connect("builder-inited", _register_assets)
    app.add_directive("svg-viewer", SVGViewerDirective)
    app.add_css_file("svg-viewer.css")
    app.add_js_file("svg-viewer.js")

    return {
        "version": "1.0",
        "parallel_read_safe": True,
        "parallel_write_safe": True,
    }
