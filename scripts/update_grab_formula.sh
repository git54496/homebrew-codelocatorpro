#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <version>" >&2
  echo "example: $0 0.2.5" >&2
  exit 1
fi

VERSION="${1#v}"
TAG="v${VERSION}"
REPO="git54496/android-ui-grab"
URL="https://github.com/${REPO}/archive/refs/tags/${TAG}.tar.gz"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
FORMULA_PATH="${ROOT_DIR}/Formula/android-ui-grab.rb"
TMP_ARCHIVE="$(mktemp "${TMPDIR:-/tmp}/android-ui-grab-${VERSION}.XXXXXX.tar.gz")"
trap 'rm -f "${TMP_ARCHIVE}"' EXIT

curl -fL "${URL}" -o "${TMP_ARCHIVE}"
SHA256="$(shasum -a 256 "${TMP_ARCHIVE}" | awk '{print $1}')"

cat > "${FORMULA_PATH}" <<EOF
class AndroidUiGrab < Formula
  desc "Android UI Grab CLI"
  homepage "https://github.com/${REPO}"
  url "${URL}"
  version "${VERSION}"
  sha256 "${SHA256}"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/${REPO}.git", branch: "main"

  depends_on "openjdk@17"

  def install
    cd "adapter" do
      system "./gradlew", "installDist", "--no-daemon"
      install_root = if (Pathname("build/install/grab")).exist?
        "build/install/grab"
      else
        Dir["build/install/*"].first
      end
      odie "installDist output not found under adapter/build/install" if install_root.nil?
      libexec.install Dir["#{install_root}/*"]
    end

    env = Language::Java.overridable_java_home_env("17")
    target = if (libexec/"bin/grab").exist?
      libexec/"bin/grab"
    else
      libexec/"bin/codelocator-adapter"
    end
    odie "CLI entry not found under #{libexec}/bin" unless target.exist?
    (bin/"grab").write_env_script target, env
  end

  test do
    version_output = shell_output("#{bin}/grab --version").strip
    assert_equal "${VERSION}", version_output
    output = shell_output("#{bin}/grab list")
    assert_match "\"success\": true", output
  end

  def caveats
    <<~EOS
      \`grab live\` requires \`adb\` in PATH.
      Install it with:
        brew install --cask android-platform-tools
    EOS
  end
end
EOF

echo "Updated ${FORMULA_PATH}"
echo "version=${VERSION}"
echo "sha256=${SHA256}"
