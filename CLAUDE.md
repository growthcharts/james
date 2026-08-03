# james — release/maintenance instructions for Claude

`james` is the R/OpenCPU backend package (server-side functions: `draw_chart()`,
`embed_chart()`, `embed_tanner()`, `request_site()`, etc.). This file is the
Claude-readable translation of `qmd/JAMES_version_maintainance.qmd` — read
that file too if you need the full rationale, but this is the checklist to
actually follow. Don't ask the user to point you at the qmd file; just do
this.

## Source of truth: OpenAPI spec

- **Canonical source**: `inst/spec/openapi.in.yaml` (has `@@Version@@` placeholders).
- **Generated output**: `inst/www/openapi.yaml`, produced by `james:::update_openapi_spec()`.
- **`jamesdocker`'s `config/openapi.yaml`** is a periodically-synced *copy* of
  `james`'s generated `inst/www/openapi.yaml` — never edit it directly. If an
  endpoint's arguments change, edit `inst/spec/openapi.in.yaml` here, then sync
  jamesdocker afterward (see jamesdocker's own CLAUDE.md).

## When you fix/bump a dependency (e.g. `bdsreader`, `tannerly`) in its own repo

`DESCRIPTION`'s version constraint (e.g. `bdsreader (>= 0.33.1)`) is not
enough on its own — `james` is `renv`-managed, and `renv.lock` pins an exact
commit sha per GitHub dependency, independent of what `DESCRIPTION` merely
requires as a minimum. Bumping only `DESCRIPTION` leaves `renv.lock` (and
therefore `renv::restore()`, and therefore the next `jamesdocker` build)
pointing at the old, unfixed commit. After committing and pushing the fix in
the dependency's own repo:

```r
renv::install("growthcharts/<pkg>@<branch-or-tag>")  # e.g. "growthcharts/bdsreader@master"
renv::status()     # confirm it reports the version/sha as out-of-sync
renv::snapshot(type = "explicit")  # writes the new version+sha into renv.lock
```

Then re-run `devtools::check()` — this is also the point to confirm a
previously-known dependency bug is actually fixed, not just check that
nothing new broke. Commit `DESCRIPTION` + `renv.lock` together with the
version bump in the same commit; don't split them.

## When you change an R function's arguments/behavior

1. Edit the function in `R/`.
2. `devtools::document()` to regenerate `man/*.Rd`.
3. Add/update tests in `tests/testthat/`.
4. Update `inst/spec/openapi.in.yaml` (search for `<fn>_arguments`) if the
   function is exposed as an API endpoint.
5. Run `devtools::check()`. If the `dcat` example (`?dcat`) fails with a
   `dplyr::summarise()`/`dscore` "type=list; target=double" error: this was
   traced to a real bug in `bdsreader::read_bds()` (fixed in `bdsreader`
   0.33.1) — a `varName`-keyed item picked up independently by both the
   generic sideload path and the ddi/D-score sideload path, with no
   deduplication between them, producing a duplicate `(age, yname)` row that
   made `pivot_wider()` emit a list-column. If you hit this again with a
   current `bdsreader`, it's a new regression, not the same known issue —
   investigate rather than assuming it's unrelated to your change (that
   assumption was wrong once already).
6. **New endpoint gotcha**: adding a new R function is not enough to make it
   reachable via a short path (e.g. `/tanner/embed`) — that requires a
   `RewriteRule` in `jamesdocker`'s `config/james_rewrites.conf`. Check the
   existing endpoints there for the pattern (`^/charts/embed` etc.) and add
   the missing one; otherwise the function is only reachable via the full
   `/ocpu/library/james/R/<fn>` path.

## Version bump + docs sync (STEP 2 of the qmd recipe)

Bump `DESCRIPTION`'s `Version:` — minor for a new feature (`1.x.0`), patch
for a fix/small addition (`1.x.y`). Then:

```r
devtools::document()  # if not already done
james:::update_openapi_spec()  # regenerates inst/www/openapi.yaml with the new version + spec
james:::update_version_files(
  "inst/www/index.html",
  "vignettes/articles/_getting_started.qmd",
  "DESCRIPTION"
)
```

Update `NEWS.md` with a new `# james X.Y.Z (Month Year)` section.

Commit this as its own commit (function changes were commit 1; this is commit 2).

## Rebuilding documentation (STEP 3)

**Before rendering anything**, make sure `james` itself is actually
*installed* (not just `devtools::load_all()`'d) in whatever R session will do
the rendering — `system.file(..., package = "james")` (used by vignette
chunks to locate test data) silently returns `""` if the package isn't
installed, `file.copy()` then silently fails, and the vignette renders with
missing/empty data without erroring. Confirm with:

```r
system.file("testdata", "client_tanner.json", package = "james")  # must not be ""
```

If empty: `devtools::install(dependencies = FALSE, upgrade = "never")` from
this directory (renv-aware — running from elsewhere may install into the
wrong library).

Render against **production** (`target_host <- "test"` in
`_getting_started.qmd`'s host chunk, the default) whenever possible — a
feature you just deployed to `jamesdocker` needs to actually be live on
`james.groeidiagrammen.nl` first, or the render will fail (403/404) on that
section. If production isn't updated yet, you can render against a local
container instead (temporarily edit `target_host <- "dev"` and
`dev = "http://localhost:<port>"`), but **revert those two lines back to
`"test"`/`8080` before committing** — don't leave the qmd pointed at a local
port. Re-render against production for real once it's deployed, and mention
in the commit message that you did.

```r
# Step 1: render _getting_started.qmd in place
quarto::quarto_render(input = "vignettes/articles/_getting_started.qmd")

# Step 2-4: move rendered file + assets into docs/articles/, fix internal refs
file.rename("vignettes/articles/_getting_started.html", "docs/articles/getting_started.html")
from <- "vignettes/articles/_getting_started_files"
to <- "docs/articles/getting_started_files"
ok <- file.rename(from, to)
if (!ok) {
  dir.create(to, recursive = TRUE, showWarnings = FALSE)
  file.copy(from = list.files(from, full.names = TRUE, all.files = TRUE, no.. = TRUE),
            to = to, recursive = TRUE, overwrite = TRUE)
  unlink(from, recursive = TRUE)
}
html <- readLines("docs/articles/getting_started.html")
html <- gsub("_getting_started_files/", "getting_started_files/", html, fixed = TRUE)
writeLines(html, "docs/articles/getting_started.html")
```

Then the `dcat_calculate_examples.qmd` vignette and `pkgdown::build_site()`:

```r
quarto::quarto_render(input = "vignettes/articles/dcat_calculate_examples.qmd")
pkgdown::build_site()
```

**Known issue**: `dcat_calculate_examples.qmd` currently fails to render
against production (HTTP 400 — the same pre-existing `dscore`/`dcat` bug
noted above). Since `pkgdown::build_site()` calls `build_articles()`
internally and aborts entirely if any vignette fails to render, this means
`build_site()` will fail too. Workaround: build the pieces that don't depend
on the broken vignette instead —

```r
pkgdown::build_reference()
pkgdown::build_home()
pkgdown::build_news()
```

— and leave `docs/articles/dcat_calculate_examples.html` untouched (don't
try to regenerate it). Mention this in the commit message so it's clear it
wasn't forgotten.

Finally, copy pre-rendered articles back over pkgdown's placeholders (usually
a no-op if the earlier `file.rename` steps already put them in place —
`file.copy()` returning `FALSE`/`logical(0)` here is expected, not an error):

```r
file.copy("vignettes/articles/getting_started.html", "docs/articles/getting_started.html", overwrite = TRUE)
file.copy("vignettes/articles/dcat_calculate_examples.html", "docs/articles/dcat_calculate_examples.html", overwrite = TRUE)
```

**Clean up before committing**: `system.file()`-copied test fixtures (e.g.
`vignettes/articles/client_tanner.json`) are render artifacts, like
`maria.json` — delete them, don't commit them.

Commit as "Rebuild documentation for X.Y.Z" (commit 3), separate from the
version/OpenAPI-sync commit.

## After this repo: jamesdocker

A `james` version bump on its own does nothing in production — `jamesdocker`
builds a Docker image from a specific `james` ref/version and that's what
actually gets deployed. See `jamesdocker`'s own `CLAUDE.md` for the sync +
build + deploy steps. Don't consider a `james` change "done" until you've
either done that too or explicitly flagged to the user that it's still
pending.
