# xplane-nix

Open-source Nix / NixOS package for the official X-Plane 12 Linux installer and runtime environment.

It provides two feature flags:
- `enableDemo`: Installs and launches the **Demo** environment (`xplane-demo`).
- `enableFull`: Installs and launches the **Full** version environment (`xplane-full`).

Files are stored in the standard XDG user data directory:
- Demo: `~/.local/share/xplane-12/demo`
- Full: `~/.local/share/xplane-12/full`

---

## Quick Install (User Profile)

Install directly into your user profile using Nix Flakes:

```bash
# Install the Demo version (default)
nix profile add github:devcdcc/xplane-nix#demo

# Install the Full version
nix profile add github:devcdcc/xplane-nix#full

# Install both Demo and Full versions
nix profile add github:devcdcc/xplane-nix#all
```

Or using `default.nix` with feature flags:

```bash
# Enable Demo
nix-env -if default.nix --arg enableDemo true --arg enableFull false

# Enable Full
nix-env -if default.nix --arg enableDemo false --arg enableFull true
```

---

## Declarative Configuration (NixOS / Home Manager)

Import the module from the flake (`nixosModules.default` or `homeManagerModules.default`) and enable either or both flags:

```nix
programs.xplane = {
  enableDemo = true;
  enableFull = false;
};
```

---

## Usage

Run the command corresponding to the flag you enabled. On first run, it automatically performs a silent headless installation into `~/.local/share/xplane-12/<edition>` without popping up an installer window, and then starts the simulator:

```bash
# Auto-install (silently) and launch Demo
xplane-demo

# Auto-install (silently) and launch Full
xplane-full
```

Additional flags:

```bash
# Run a silent headless update only
xplane-demo --update
xplane-full --update

# Open the interactive GUI installer (e.g. for Full license login or scenery map)
xplane-demo --installer-gui
xplane-full --installer-gui
```

## License

MIT
