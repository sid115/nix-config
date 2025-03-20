help() {
  echo "Usage: otp OPTION"
  echo
  echo "Retrieve one-time password for various services"
  echo
  echo "Options:"
  echo "  github  Retrieve GitHub OTP code"
  echo "  help    Display this help message"
}

if [ $# -ne 1 ]; then
  echo "Wrong number of arguments."
  exit 1
fi

case "$1" in
  "gh"|"github")
    pass otp -c www/github.com
    ;;
  "help")
    help
    ;;
  *)
    echo "Error: Unknown option '$1'"
    exit 1
    ;;
esac

exit 0
