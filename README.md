# xplane-nix

Open-source Nix / NixOS package for the official X-Plane 12 Linux installer and runtime environment.

It provides two feature flags:
- `enableDemo`: Installs and launches the **Demo** environment (`xplane-demo`).
- `enableFull`: Installs and launches the **Full** version environment (`xplane-full`).

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

## Enable via NixOS or Home Manager Module

Import the module from the flake (`nixosModules.default` or `homeManagerModules.default`) and enable either or both flags:

```nix
programs.xplane = {
  enableDemo = true;
  enableFull = true;
};
```

---

## Usage

Run the command corresponding to the flag you enabled:

```bash
# Launch Demo installer (or start the simulator if already installed in ~/X-Plane-12-demo)
xplane-demo

# Launch Full installer (or start the simulator if already installed in ~/X-Plane-12-full)
xplane-full
```

To force opening the installer again after installation (for updates or scenery):

```bash
xplane-demo --installer
xplane-full --installer
```

## License

MIT
