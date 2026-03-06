# homebrew-codelocatorpro

Homebrew tap repository for installing `grab` (CodeLocatorPRO CLI).

## Usage

```bash
brew tap git54496/codelocatorpro
brew install grab
```

Upgrade after the formula is versioned:

```bash
brew update
brew upgrade grab
```

## Release Flow

1. Push `codelocatorpro` and create a source tag such as `v0.2.0`.
2. In this tap repo, run `./scripts/update_grab_formula.sh 0.2.0`.
3. Commit and push the updated `Formula/grab.rb`.
4. Users run `brew update && brew upgrade grab`.

For users who installed the old `version "main"` formula, the first transition to a versioned formula may require a one-time `brew reinstall grab`.

## Notes

- Formula file: `Formula/grab.rb`
- Formula update helper: `scripts/update_grab_formula.sh`
- Source code repository: `https://github.com/git54496/codelocatorpro`
- Runtime dependency for live grabbing:

```bash
brew install --cask android-platform-tools
```
