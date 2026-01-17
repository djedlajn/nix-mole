{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchurl,
  makeWrapper,
  coreutils,
  gdu,
}:

let
  version = "1.21.0";

  binaries = {
    aarch64-darwin = fetchurl {
      url = "https://github.com/tw93/Mole/releases/download/V${version}/binaries-darwin-arm64.tar.gz";
      hash = "sha256-cIZslu8rxPpP516f/PAtytuR9lJIbB9jOrY2Bnl8ilY=";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/tw93/Mole/releases/download/V${version}/binaries-darwin-amd64.tar.gz";
      hash = "sha256-YVJJrU2rCw8L5cNT2agBXIY3KDDqHEZdMOWa0rG0vYA=";
    };
  };

in
stdenvNoCC.mkDerivation {
  pname = "mole-cleaner";
  inherit version;

  src = fetchFromGitHub {
    owner = "tw93";
    repo = "Mole";
    tag = "V${version}";
    hash = "sha256-HAKlivpOIpQ6vtEmyiFT33j4LzXahAqQGA3DwrU2bis=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec/mole

    # Install main script and lib together (script expects lib/ relative to itself)
    cp mole $out/libexec/mole/
    chmod +x $out/libexec/mole/mole
    cp -r lib $out/libexec/mole/

    # Install pre-built Go binaries
    tar -xzf ${binaries.${stdenvNoCC.hostPlatform.system}} -C $out/libexec/mole

    # Create wrapper in bin
    mkdir -p $out/bin
    makeWrapper $out/libexec/mole/mole $out/bin/mole \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          gdu
        ]
      }"

    runHook postInstall
  '';

  meta = {
    description = "CLI tool for cleaning and optimizing macOS";
    homepage = "https://github.com/tw93/Mole";
    changelog = "https://github.com/tw93/Mole/releases/tag/V${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.djedlajn ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "mole";
  };
}
