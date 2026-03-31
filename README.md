# cwp — Copilot With Profiles

Route the GitHub Copilot CLI to different configurations based on the directory you're working in.

## Why?

The Copilot CLI stores config in `~/.copilot`. If you use Copilot for different contexts — demos, daily work, engineering, exploration — they all share the same settings. `cwp` fixes this by automatically switching configs based on your project.

## Quick Start

```bash
# Install cwp
git clone https://github.com/devndive/copilot-with-profiles.git
cd copilot-with-profiles
make install

# Create a profile
cwp init demos

# Mark a project directory to use that profile
cd ~/projects/my-demo
echo 'profile = "demos"' > .copilot-profile

# Use copilot — cwp injects the right --config-dir automatically
cwp chat
```

## How It Works

1. You run `cwp` (with any copilot arguments)
2. `cwp` walks up from your current directory looking for a `.copilot-profile` file
3. It reads the profile name from the file
4. It resolves the profile directory under `~/.config/copilot-with-profiles/profiles/<name>/`
5. It execs `copilot --config-dir=<profile-dir> [your-args...]`

All arguments are transparently forwarded — `cwp chat` becomes `copilot --config-dir=... chat`.

## The `.copilot-profile` Marker File

Place a `.copilot-profile` file in any directory. `cwp` will find it when run from that directory or any subdirectory.

```toml
profile = "demos"
```

This means you can set a profile at the workspace root and it applies to all nested projects.

## Commands

| Command              | Description                                    |
|----------------------|------------------------------------------------|
| `cwp [args...]`      | Run copilot with the resolved profile          |
| `cwp init <profile>` | Create a new empty profile directory           |
| `cwp --help`         | Show help                                      |
| `cwp --version`      | Show version                                   |

## Configuration

### Global Config

Optionally create `~/.config/copilot-with-profiles/config.toml` to override defaults:

```toml
# Override where profile directories are stored
profiles_dir = "/custom/path/to/profiles"
```

### Directory Layout

```
~/.config/copilot-with-profiles/
├── config.toml              # Optional global config
└── profiles/
    ├── demos/               # Each profile is a directory
    │   ├── config.json      # Copilot generates these on first run
    │   └── ...
    └── engineering/
        └── ...
```

## Installation

### With make (recommended)

```bash
make install                     # Install to ~/.local/bin
make install PREFIX=/usr/local   # Install to /usr/local/bin (needs sudo)
make uninstall                   # Remove cwp
```

### Manual setup

```bash
# Option 1: Symlink
chmod +x cwp
ln -s "$(pwd)/cwp" ~/.local/bin/cwp

# Option 2: Alias (add to ~/.bashrc or ~/.zshrc)
alias cwp='/path/to/copilot-with-profiles/cwp'

# Create the profiles directory
mkdir -p ~/.config/copilot-with-profiles/profiles
```

Make sure `~/.local/bin` is in your `PATH`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Example Workflow

```bash
# Set up profiles for different contexts
cwp init demos
cwp init work
cwp init oss

# Configure your project trees
echo 'profile = "demos"' > ~/demos/.copilot-profile
echo 'profile = "work"'  > ~/work/.copilot-profile
echo 'profile = "oss"'   > ~/oss/.copilot-profile

# Now copilot uses the right config automatically
cd ~/demos/my-talk && cwp chat    # → uses "demos" profile
cd ~/work/api-service && cwp chat # → uses "work" profile
```

## License

MIT
