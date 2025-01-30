# Manual configuration

The following things are not (yet) automated by Nix. Follow these steps after finishing the installation (including Home Manager).

## Import secrets

It is assumed that your secrets are stored on a LUKS encrypted USB drive partition (sda3 in this case).

```bash
USB=/dev/sda
USER=$(whoami)
HOST=$(cat /etc/hostname)

# Open crypt
sudo mkdir -p /mnt/crypt
sudo cryptsetup open "$USB"3 crypt
sudo mount /dev/mapper/crypt /mnt/crypt

# Copy secrets
sudo rsync -vP /mnt/crypt/gpg-backup.sec.asc /tmp
sudo rsync -vP /mnt/crypt/$HOST/keys.txt /tmp
sudo chown $USER:$USER /tmp/gpg-backup.sec.asc
sudo chown $USER:$USER /tmp/keys.txt

# Import secrets
mkdir -p ~/.config/sops/age && mv /tmp/keys.txt ~/.config/sops/age
gpg --decrypt /tmp/gpg-backup.sec.asc | gpg --import
gpg --edit-key D371C8E7D58F9D1E # replace with your key ID
gpg> trust
Your decision? 5
Do you really want to set this key to ultimate trust? (y/N) y
gpg> q

# Close crypt
sudo umount -lf /mnt/crypt
sudo cryptsetup close crypt
```

## Clone password store repository

```bash
git clone ssh://git.portuus.de:2299/home/sid/git/password-store $PASSWORD_STORE_DIR
```

## Librewolf

Librewolf is handled through its Home Manager module. Extensions do not need to be installed, just activated.

- Extensions (allow every extension to run in private windows)
  - PassFF
    - Preferences
      - Behavior of Enter key: Fill and submit
      - Behavior of Shift-Enter key: Goto, fill and submit
  - floccus
    - Add profile
      - Nextcloud Bookmarks
        - Bookmarks folder: Bookmarks Toolbar

TODO
- all custom search bookmarks lost their keywords
- set Searx as the default search engine

## Element Desktop

- Authentication via username, password and security key
- Settings
  - Appearance
    - Theme: Dark
  - Preferences
    - Allow spell check
      - Add: German (Germany)
    - Keyboard shortcuts
      - Use Ctrl + F to search timeline: true

## Thunderbird

The account setup must be done manually, as the `accounts.email` HM module requires setting personal information that would end up being public on the Git web frontend.

- Spelling
  - Add Dictionaries...
    - German: Download Dictionary

## Spotify

- Authentication via username and password

## Jellyfin Media Player

- Add server
- Authentication via username and password

## OBS-Studio

- Scenes
  - Scene
    - Sources
      - Add: Screen Capture (PipeWire) > OK > Screen 0 (or a window or a region) > OK
- Audio Mixer
  - Mic/Aux: Mute
- File
  - Settings
    - Output
      - Recording
        - Recording Path: /home/sid/vid/recordings
        - Generate File Name without Space
    - Video
      - Base Resolution: 2560x1600
      - Output Resolution: 2560x1600
      - Common FPS Values: 60

> TODO: adjust video and audio codecs/quality

> TODO: keyboard shortcuts (currently using waybar tray icon)

## Eduroam

Download the eduroam configuration script [here](https://cat.eduroam.org/?idp=5134&profile=8268).

Execute it:

```bash
nix-shell -p python3 python3Packages.dbus-python --run 'python eduroam-linux-THK-members_of_TH_Koln.py'
```

## Zoom

- Authentication via username and password
- Check "Keep me signed in"
