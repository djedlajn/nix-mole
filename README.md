# nix-mole

Nix flake for [Mole](https://github.com/tw93/Mole) by [@tw93](https://github.com/tw93).

Mole is a CLI tool for cleaning and optimizing macOS - removing caches, logs, and unused files to free up disk space.

[![CI](https://github.com/djedlajn/nix-mole/actions/workflows/ci.yml/badge.svg)](https://github.com/djedlajn/nix-mole/actions/workflows/ci.yml)

## Installation

```bash
# Run directly
nix run github:djedlajn/nix-mole

# Install to profile
nix profile install github:djedlajn/nix-mole
```

### With Flakes

```nix
{
  inputs.nix-mole.url = "github:djedlajn/nix-mole";

  # Add to packages
  home.packages = [ nix-mole.packages.${system}.mole ];
}
```

## Usage

```bash
mole           # Interactive menu
mole clean     # Deep clean system
mole uninstall # Uninstall apps completely
mole optimize  # Optimize system
mole manage    # Manage startup items
```

## Platforms

- aarch64-darwin (Apple Silicon)
- x86_64-darwin (Intel Mac)

## Credits

All credit for Mole goes to [@tw93](https://github.com/tw93) and contributors.
This repository only provides the Nix packaging.

## License

MIT - Same as [Mole](https://github.com/tw93/Mole/blob/main/LICENSE)
