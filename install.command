PURPLE='\033[1;35m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

printf "Downloading Homebrew...\n"
HOMEBREW_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

if ! command -v brew &> /dev/null; then
    printf "Installing Homebrew...\n"
    /bin/bash -c "$(curl -fsSL $HOMEBREW_URL)" || exit 1
    printf "${PURPLE}==> ${GREEN}Homebrew installation completed${NC}\n"
else
    printf "${PURPLE}==> ${GREEN}Homebrew is already installed${NC}\n"
fi

printf "Installing packages from Brewfile...\n"
Brewfile_URL="https://raw.githubusercontent.com/keiiita/mac-setup/main/Brewfile"

if ! curl --output /dev/null --silent --head --fail "$Brewfile_URL"; then
    printf "${PURPLE}==> ${RED}Brewfile URL is invalid. Exiting.${NC}\n"
    exit 1
fi

TEMP_BREWFILE=$(mktemp)
if ! curl -s "$Brewfile_URL" -o "$TEMP_BREWFILE"; then
    printf "${PURPLE}==> ${RED}Failed to download Brewfile. Exiting.${NC}\n"
    exit 1
fi

if ! brew bundle --file="$TEMP_BREWFILE"; then
    printf "${PURPLE}==> ${RED}Failed to install packages from Brewfile.${NC}\n"
    rm -f "$TEMP_BREWFILE"
    exit 1
fi

rm -f "$TEMP_BREWFILE"

exit 0
