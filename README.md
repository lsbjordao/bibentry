# Bibentry Extension For Quarto

A Quarto extension that replicates LaTeX's `\bibentry` command functionality. This filter allows you to display full bibliography entries inline within your document text, while preserving the original citation for the References section.

## Installing

```bash
quarto add fredguth/bibentry
```

This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

## Using

Add the filter to your document's YAML header:

```yaml
filters:
  - bibentry
```

Then use the `.bibentry` class on citations to display the full bibliography entry inline:

```qmd
[@key]{.bibentry}
```

The extension will:
- Render the full CSL-formatted bibliography entry at that location
- Keep the original citation hidden but present for the References section
- Support multiple output formats (HTML, Typst, etc.)

## Example

```qmd
---
title: "My Document"
bibliography: refs.bib
filters:
  - bibentry
---

This study [@hallal2010]{.bibentry} shows important findings.

## References
::: {#refs}
:::
```

This will display the full bibliography entry for `hallal2010` inline, while still including it in the References section.

See the complete example: [example.qmd](example.qmd)
