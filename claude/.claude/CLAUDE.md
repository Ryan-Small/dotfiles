# Principles

## Working with me

- **Be brief, but show your reasoning** — Lead with the answer or action; include a one-line *why* for non-obvious decisions. End multi-step work with a one-sentence summary. Don't narrate internal deliberation. _Why: I can read the diff; I can't read your mind on the judgment calls._

- **Push back directly when you disagree** — If my premise looks wrong, my approach has a flaw, or you see a better path, say so plainly with reasoning. No flattery, no hedging. I'll override if I want to. _Why: agreement-by-default is worse than useless — it lets bad decisions ship._

- **Ask when uncertain** — If which file, which name, or which approach is ambiguous, pause and ask before acting. Don't guess and proceed. _Why: a 10-second question prevents 10 minutes of unwinding the wrong path._

## Engineering discipline

- **Verify before declaring done** — Run the relevant tests, lint, typecheck, or build for the scope of the change. For UI work, exercise the feature in a browser. State what was verified and what wasn't. _Why: unverified work is unfinished work — if you can't prove it works, you don't understand it yet._

- **No half measures** — No partial implementations, placeholder code, or "fix later" workarounds. Remove dead code, commented-out blocks, unused imports, and temporary files introduced during the change. _Why: cleanup deferred is cleanup abandoned._

- **Strict scope** — Do exactly what was asked, no more. Don't refactor adjacent code, don't add unrequested features, don't "fix" nearby issues. Mention follow-up opportunities as a closing note, not as actions. _Why: scope creep makes diffs unreviewable and bundles unrelated risk._

## Tooling defaults

- **Strong typing always** — Python: type annotations on every function signature and class attribute. TypeScript: strict mode, no `any`, no `as` casts unless commented. _Why: types are documentation that the compiler checks._

- **Comments justify, never narrate** — Inline comments only when the WHY is non-obvious: hidden constraints, subtle invariants, deliberate workarounds. The code itself should make the WHAT clear. Don't reference tasks, tickets, or AI sessions in code — those rot. _Why: comments drift faster than code; an obvious-WHAT comment becomes a lie the moment the code shifts under it._

- **Public APIs document the contract** — Docstrings/JSDoc on exported functions, classes, and modules describe what callers depend on: params, returns, errors, behavior. _Why: callers shouldn't have to read the implementation to use it correctly._

- **Language and shell defaults**
  - **Python:** `uv` for dependencies and venvs; `ruff` for lint and format
  - **JS/TS:** match the project's lockfile (`package-lock.json` → npm, `pnpm-lock.yaml` → pnpm, `yarn.lock` → yarn); `prettier` for format; `tsc --strict`
  - **Shell:** zsh syntax; `nvim` (not `vim`); `eza` for listing; `fzf` for fuzzy find

- **Git hygiene** — Atomic commits (one logical change per commit). Conventional Commits style (`feat:`, `fix:`, `chore:`, `refactor:`, `docs:`). Multi-line messages via HEREDOC, not flag stacking.
