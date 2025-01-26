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

Get WIFI interface:

```bash
ip l
```

> for example: wlo1

Add eduroam connection:

```bash
nmcli connection add type wifi ifname wlo1 con-name eduroam ssid eduroam
```

Configuration:

```bash
nmcli connection modify eduroam \
  802-11-wireless-security.key-mgmt wpa-eap \
  802-1x.eap ttls \
  802-1x.phase2-auth pap \
  802-1x.identity CAMPUS_ID \
  802-1x.anonymous-identity anonymous@th-koeln.de \
  802-1x.password PASSWORD \
  802-1x.ca-cert /PATH/TO/ca.pem \
  802-1x.altsubject-matches DNS:radius-eduroam.campus-it.fh-koeln.de
```

> replace `CAMPUS_ID`, `PASSWORD`, and `/PATH/TO/ca.pem`

This is the CA:

```plaintext
-----BEGIN CERTIFICATE-----
MIIDwzCCAqugAwIBAgIBATANBgkqhkiG9w0BAQsFADCBgjELMAkGA1UEBhMCREUx
KzApBgNVBAoMIlQtU3lzdGVtcyBFbnRlcnByaXNlIFNlcnZpY2VzIEdtYkgxHzAd
BgNVBAsMFlQtU3lzdGVtcyBUcnVzdCBDZW50ZXIxJTAjBgNVBAMMHFQtVGVsZVNl
YyBHbG9iYWxSb290IENsYXNzIDIwHhcNMDgxMDAxMTA0MDE0WhcNMzMxMDAxMjM1
OTU5WjCBgjELMAkGA1UEBhMCREUxKzApBgNVBAoMIlQtU3lzdGVtcyBFbnRlcnBy
aXNlIFNlcnZpY2VzIEdtYkgxHzAdBgNVBAsMFlQtU3lzdGVtcyBUcnVzdCBDZW50
ZXIxJTAjBgNVBAMMHFQtVGVsZVNlYyBHbG9iYWxSb290IENsYXNzIDIwggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCqX9obX+hzkeXaXPSi5kfl82hVYAUd
AqSzm1nzHoqvNK38DcLZSBnuaY/JIPwhqgcZ7bBcrGXHX+0CfHt8LRvWurmAwhiC
FoT6ZrAIxlQjgeTNuUk/9k9uN0goOA/FvudocP05l03Sx5iRUKrERLMjfTlH6VJi
1hKTXrcxlkIF+3anHqP1wvzpesVsqXFP6st4vGCvx9702cu+fjOlbpSD8DT6Iavq
jnKgP6TeMFvvhk1qlVtDRKgQFRzlAVfFmPHmBiiRqiDFt1MmUUOyCxGVWOHAD3bZ
wI18gfNycJ5v/hqO2V81xrJvNHy+SE/iWjnX2J14np+GPgNeGYtEotXHAgMBAAGj
QjBAMA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBS/
WSA2AHmgoCJrjNXyYdK4LMuCSjANBgkqhkiG9w0BAQsFAAOCAQEAMQOiYQsfdOhy
NsZt+U2e+iKo4YFWz827n+qrkRk4r6p8FU3ztqONpfSO9kSpp+ghla0+AGIWiPAC
uvxhI+YzmzB6azZie60EI4RYZeLbK4rnJVM3YlNfvNoBYimipidx5joifsFvHZVw
IEoHNN/q/xWA5brXethbdXwFeilHfkCoMRN3zUA7tFFHei4R40cR3p1m0IvVVGb6
g1XqfMIpiRvpb7PO4gWEyS8+eIVibslfwXhjdFjASBgMmTnrpMwatXlajRWc2BQN
9noHV8cigwUtPJslJj0Ys6lDfMjIq2SPDqO/nBudMNva0Bkuqjzx+zOAduTNrRlP
BSeOE6Fuwg==
-----END CERTIFICATE-----
```

## Zoom

- Authentication via username and password
- Check "Keep me signed in"
