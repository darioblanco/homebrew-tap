cask "norn" do
  version "0.0.1"
  sha256 "2aced5182aeffc18690fbcd10718635082ebf1bc974637cda88ecdaf2d0949a6"

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
