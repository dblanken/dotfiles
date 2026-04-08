#!/bin/bash

# Script to inject Lando scanner retry configuration into a Lando YAML file
# This reduces Lando's service readiness scanner retries (default is 25)
#
# Usage: lando-reduce-retries.sh <lando-file> <retry-count> [service-name|all]
#
# Examples:
#   lando-reduce-retries.sh .lando.local.yml 10                # Apply to appserver (default)
#   lando-reduce-retries.sh .lando.local.yml 10 appserver     # Apply to specific service
#   lando-reduce-retries.sh .lando.local.yml 10 all           # Apply to all URL services
#
# The script will:
# - Check if the specified Lando file exists
# - Create a backup of the original file
# - Inject or update scanner retry configuration
# - Preserve existing file formatting

set -e

# Parse arguments
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
  echo "Usage: $0 <lando-file> <retry-count> [service-name|all]"
  echo ""
  echo "Arguments:"
  echo "  lando-file    Path to Lando config file (.lando.yml, .lando.local.yml)"
  echo "  retry-count   Number of scanner retries (positive integer, default is 25)"
  echo "  service-name  Optional: Service to configure, or 'all' for all URL services (default: appserver)"
  echo ""
  echo "Examples:"
  echo "  $0 .lando.local.yml 10"
  echo "  $0 .lando.local.yml 10 appserver"
  echo "  $0 .lando.local.yml 10 all"
  exit 1
fi

LANDO_FILE="$1"
RETRY_COUNT="$2"
SERVICE_ARG="${3:-appserver}"
BACKUP_FILE="${LANDO_FILE}.bak"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Validate retry count is a positive integer
if ! [[ "$RETRY_COUNT" =~ ^[0-9]+$ ]] || [ "$RETRY_COUNT" -lt 1 ]; then
  echo -e "${RED}Error: Retry count must be a positive integer (got: '$RETRY_COUNT')${NC}"
  exit 1
fi

# Check if the specified Lando file exists
if [ ! -f "$LANDO_FILE" ]; then
  echo -e "${RED}Error: $LANDO_FILE not found${NC}"
  echo "Please provide a valid path to a Lando configuration file."
  exit 1
fi

# Check if we have the services section
if ! grep -q "^services:" "$LANDO_FILE"; then
  echo -e "${RED}Error: No 'services:' section found in $LANDO_FILE${NC}"
  echo "This script requires a services section to exist."
  exit 1
fi

# Determine which services to configure
if [ "$SERVICE_ARG" = "all" ]; then
  # Common Pantheon recipe services that have URLs
  SERVICES=("appserver" "appserver_nginx" "edge" "edge_ssl")
  echo -e "${GREEN}Applying scanner retry configuration to all URL services${NC}"
else
  SERVICES=("$SERVICE_ARG")
fi

# Create backup
echo -e "${GREEN}Creating backup: $BACKUP_FILE${NC}"
cp "$LANDO_FILE" "$BACKUP_FILE"

# Process each service
TEMP_FILE=$(mktemp)
cp "$LANDO_FILE" "$TEMP_FILE"

for SERVICE_NAME in "${SERVICES[@]}"; do
  echo -e "${YELLOW}Processing service: $SERVICE_NAME${NC}"

  # Check if service already exists in the file
  if grep -q "^  ${SERVICE_NAME}:" "$TEMP_FILE"; then
    # Service exists - check if it has scanner config
    if sed -n "/^  ${SERVICE_NAME}:/,/^  [a-z]/p" "$TEMP_FILE" | grep -q "scanner:"; then
      echo "  Service has scanner config, updating retry value..."
      # Update existing scanner retry
      TEMP_FILE2=$(mktemp)
      awk -v service="$SERVICE_NAME" -v retries="$RETRY_COUNT" '
      /^  [a-z]/ {
        line = $0
        gsub(/^  /, "", line)
        gsub(/:.*/, "", line)
        current_service = line
      }
      /^    scanner:/ && current_service == service { in_scanner = 1 }
      /^      retry:/ && in_scanner {
        print "      retry: " retries
        in_scanner = 0
        next
      }
      /^    [a-z_]+:/ && in_scanner && !/^    scanner:/ {
        print "      retry: " retries
        in_scanner = 0
      }
      { print }
      ' "$TEMP_FILE" > "$TEMP_FILE2"
      mv "$TEMP_FILE2" "$TEMP_FILE"
    else
      echo "  Service exists, adding scanner config..."
      # Add scanner config to existing service
      TEMP_FILE2=$(mktemp)
      awk -v service="$SERVICE_NAME" -v retries="$RETRY_COUNT" '
      /^services:/ { in_services = 1 }
      /^  [a-z_]+:/ && in_services {
        line = $0
        gsub(/^  /, "", line)
        gsub(/:.*/, "", line)
        current_service = line
        if (current_service == service) {
          in_target_service = 1
          service_found = 1
        } else {
          in_target_service = 0
        }
      }
      /^    [a-z_]+:/ && in_target_service && !injected {
        print "    scanner:"
        print "      retry: " retries
        injected = 1
      }
      /^  [a-z_]+:/ && in_target_service {
        line = $0
        gsub(/^  /, "", line)
        gsub(/:.*/, "", line)
        if (line != service && !injected) {
          print "    scanner:"
          print "      retry: " retries
          injected = 1
        }
      }
      /^[^ ]/ && !/^services:/ { in_services = 0; in_target_service = 0; injected = 0 }
      { print }
      END {
        if (in_target_service && !injected) {
          print "    scanner:"
          print "      retry: " retries
        }
      }
      ' "$TEMP_FILE" > "$TEMP_FILE2"
      mv "$TEMP_FILE2" "$TEMP_FILE"
    fi
  else
    echo "  Service not found, adding new service entry..."
    # Service doesn't exist - add it at the end of services section
    TEMP_FILE2=$(mktemp)
    awk -v service="$SERVICE_NAME" -v retries="$RETRY_COUNT" '
    /^services:/ { in_services = 1; services_line = NR }
    /^[^ ]/ && !/^services:/ && in_services {
      # Exiting services section, add our service before this line
      print "  " service ":"
      print "    scanner:"
      print "      retry: " retries
      in_services = 0
      added = 1
    }
    { print }
    END {
      # If we are still in services at EOF, add service at the end
      if (in_services && !added) {
        print "  " service ":"
        print "    scanner:"
        print "      retry: " retries
      }
    }
    ' "$TEMP_FILE" > "$TEMP_FILE2"
    mv "$TEMP_FILE2" "$TEMP_FILE"
  fi
done

# Replace original file with modified version
mv "$TEMP_FILE" "$LANDO_FILE"

echo ""
echo -e "${GREEN}✓ Successfully configured scanner retries in $LANDO_FILE${NC}"
echo ""
echo "Changes made:"
if [ "$SERVICE_ARG" = "all" ]; then
  echo "  - Set scanner.retry: $RETRY_COUNT for all URL services"
else
  echo "  - Set ${SERVICE_ARG}.scanner.retry: $RETRY_COUNT"
fi
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Review the changes: diff $BACKUP_FILE $LANDO_FILE"
echo "  2. Rebuild Lando to apply changes: lando rebuild -y"
echo ""
echo "To restore original file if needed: cp $BACKUP_FILE $LANDO_FILE"
