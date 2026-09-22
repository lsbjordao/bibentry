# Bibentry Extension For Quarto

A Quarto extension that replicates LaTeX's `\bibentry` command functionality. It lets you display the full bibliography-formatted entry for a citation at the point of use while keeping normal Pandoc/Quarto citation syntax unchanged.

## Installing

```bash
quarto add fredguth/bibentry
```

This installs the extension under the `_extensions` subdirectory. If you use version control, you will usually want to check that directory in.

## Using

Add the filter to the document YAML:

```yaml
filters:
  - bibentry
```

Then add the `.bibentry` class to a normal citation:

```qmd
[@key]{.bibentry}
```

A normal citation remains a normal citation:

```qmd
This is the usual citation form [@key].
```

The `.bibentry` form instead renders the corresponding **bibliography-layout entry from the active CSL style** at that location.

## Inline and nested use

`bibentry` replaces only the marked citation span, so surrounding text is preserved:

```qmd
For publication details, see [@key]{.bibentry} and compare the discussion above.
```

It also works in nested inline contexts, including native Pandoc/Quarto footnotes:

```qmd
A proposition supported by a full bibliographic footnote.^[See [@key]{.bibentry}]
```

This is useful in legal, historical, philosophical, and other humanities writing where full bibliographic references are commonly placed in footnotes.

## CSL and bibliography behavior

The extension uses Pandoc's own cite processor. Therefore the full entry follows the document's normal bibliography configuration, including `bibliography:` and `csl:` metadata.

For example:

```yaml
bibliography: refs.bib
csl: my-style.csl
```

With a numeric CSL style, bibliography numbering and ordering are preserved because the extension runs citeproc once in the context of the complete document rather than independently for every `.bibentry` occurrence.

Entries rendered only through `.bibentry` are kept in the final References section through Pandoc's `nocite` metadata; no format-specific hidden HTML or Typst content is required.

## Output formats

The replacement is produced as Pandoc AST, so it remains writer-neutral. The implementation has regression coverage for HTML, LaTeX/PDF-oriented output, and DOCX, and is compatible with other Pandoc writers such as Typst.

## Example

```qmd
---
title: "My Document"
bibliography: refs.bib
filters:
  - bibentry
---

A normal citation remains normal [@hallal2010].

The full bibliography entry can appear inline: [@hallal2010]{.bibentry}.

It can also appear in a native footnote.^[See [@hallal2010]{.bibentry}]

## References
::: {#refs}
:::
```

See the complete example in [`example.qmd`](example.qmd).

## Tests

If Pandoc is available locally:

```bash
./tests/run.sh
```

The regression suite checks standalone and true-inline replacement, nested footnote rendering, bibliography preservation, DOCX/LaTeX output, and numeric CSL ordering.
