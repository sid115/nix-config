#!/usr/bin/env bash

DMENU="bemenu"
OPTIONS="github"

CHOICE=$(echo -e "$OPTIONS" | "$DMENU" -p "OTP:")

get_pass() {
  pass otp -c "$1" 2>/dev/null
}

case "$CHOICE" in
  "github")
    get_pass "www/github.com"
    ;;
  *)
    echo "Error: Unknown option '$CHOICE'"
    exit 1
    ;;
esac

exit 0
