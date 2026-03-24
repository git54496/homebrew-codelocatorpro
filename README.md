# homebrew-android-ui-grab

Homebrew tap repository for installing the `android-ui-grab` package. The installed CLI command remains `grab`.

## Usage

```bash
brew tap git54496/android-ui-grab
brew install android-ui-grab
```

Upgrade after the formula is versioned:

```bash
brew update
brew upgrade android-ui-grab
```

## Release Flow

1. Push `android-ui-grab` and create a source tag such as `v0.2.5`.
2. In this tap repo, run `./scripts/update_grab_formula.sh 0.2.5`.
3. Commit and push the updated `Formula/android-ui-grab.rb`.
4. Users run `brew update && brew upgrade android-ui-grab`.

For users who installed the old `grab` formula, migrate once with `brew uninstall grab && brew install android-ui-grab`.

## Notes

- Formula file: `Formula/android-ui-grab.rb`
- Formula update helper: `scripts/update_grab_formula.sh`
- Source code repository: `https://github.com/git54496/android-ui-grab`
- Runtime dependency for live grabbing:

```bash
brew install --cask android-platform-tools
```
