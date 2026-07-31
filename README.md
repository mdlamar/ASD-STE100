# ASD-STE100 anti-slop kit for opencode

The distilled ASD-STE100 (Simplified Technical English) writing skill from the
[woosal1337 blog episode "The cure for AI slop"](https://github.com/woosal1337/blog/tree/main/videos/ep01-the-cure-for-ai-slop),
packaged as an [opencode](https://opencode.ai) skill with an integrated
machine-checkable linter. Works with any opencode model, including Big Pickle
(`opencode/big-pickle`).

Give the model a writing system and slop drops by half or more. From the
episode's cross-model test:

| Condition | Claude sonnet | gpt-5.5 |
|---|---|---|
| baseline | 4.36 | 3.54 |
| banned-words list | 4.21 (-3%) | 2.14 (-40%) |
| Orwell's 6 rules | 2.48 (-43%) | 1.69 (-52%) |
| STE skill | 1.12 (-74%) | 1.76 (-50%) |

STE was best or tied-best on every model tested. Scores are linter violations
per 100 words — lower is cleaner.

## What is in the repo

| Path | What it is |
|---|---|
| `skill/ste-writing/SKILL.md` | The opencode skill: two modes (strict for procedures/errors, STE-flavored for prose), with a mandatory `ste-lint` verification step before returning text |
| `scripts/ste-lint.py` | The heuristic anti-slop linter — the machine-checkable subset of STE. Deterministic; the score delta between two texts is the signal |
| `install.sh` | Installs the skill + linter globally for all opencode sessions |
| `tests/` | Sloppy vs. clean sample texts used to verify the linter |

Not a certified STE checker. The judgment rules of ASD-STE100 need a human;
this covers the mechanical subset — which is where the slop lives. Spec:
ASD-STE100 Issue 9, free at asd-ste100.org.

## Install

```bash
./install.sh
```

This links (or with `--copy`, copies):

- `~/.config/opencode/skill/ste-writing/SKILL.md` — global opencode skill
- `~/.local/bin/ste-lint` — the linter, on PATH

Quit and restart opencode so the skill loads. Symlinked installs stay fresh
when you `git pull` this repo.

### Install from GitHub

On any machine:

```bash
curl -fsSL https://github.com/mdlamar/ASD-STE100/raw/refs/heads/main/install.sh | bash
```

### Uninstall

```bash
./install.sh --uninstall
```

## Usage

The skill is on-demand. In any opencode session (Big Pickle included), ask for
one of the trigger phrases, for example:

- "Rewrite this README so it does not sound like AI"
- "Make this error message plain and unambiguous"
- "Write this doc in STE"
- "This PR description reads like slop — clean it up"

The skill applies the STE rules and then **runs `ste-lint` on its own output**
before returning the text, fixing flagged violations until the score is clean.
It reports the before/after score when useful — the delta is the signal.

## Run the linter standalone

```bash
ste-lint your-draft.md
# or, from the repo:
python3 scripts/ste-lint.py your-draft.md
```

Score is violations per 100 words — lower is cleaner. Lint a draft, apply the
skill, then lint it again; the delta between the two scores is the signal.

## Verify the kit

```bash
python3 scripts/ste-lint.py tests/sloppy.md   # high per100w
python3 scripts/ste-lint.py tests/clean.md    # ~0 per100w
```

## License

This work is dedicated to the public domain under
[CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/) —
see [LICENSE](LICENSE). No rights reserved. Take it, use it, sell it, remix
it. If it was ever "found money", consider it a penny on the sidewalk:
yours now.

## Credits

- Original kit: [woosal1337/blog — ep01-the-cure-for-ai-slop](https://github.com/woosal1337/blog/tree/main/videos/ep01-the-cure-for-ai-slop)
- Standard: ASD-STE100 Issue 9, https://asd-ste100.org (copyrighted; not reproduced here)
