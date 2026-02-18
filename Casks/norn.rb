cask "norn" do
  version "0.0.1"
  sha256 "1798ddfd86cda7d2ba8759d24fb9ec897304f7141d7f3d56c658972027357553"

  url "https://releases.darioblanco.com/norn/v#{version}/norn-#{version}-darwin-arm64.dmg"
  name "Norn"
  desc "Agent session orchestrator — desktop app"
  homepage "https://github.com/darioblanco/norn"

  depends_on formula: "darioblanco/tap/norn"

  app "Norn.app"

  zap trash: [
    "~/.norn",
  ]
end
