#!/bin/bash

# Split iOS Suite Release Preparation Script
# Interactive script to prepare a release for the iOS Suite

# Branch name constants - update these if branch naming changes
MAIN_BRANCH="main"
DEV_TEST_BRANCH="dev_test"

set -e

# Ensure we're in the repo root directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR/.."

# Variables to track state
ORIGINAL_BRANCH=""
BRANCH_CREATED=false
SCRIPT_FAILED=false

# Function to clean up temporary files and restore state on failure
cleanup() {
  EXIT_CODE=$?
  
  # Clean up temporary files
  echo "💾 Cleaning up temporary files..."
  rm -f "${SCRIPT_DIR}/../iOSSplitSuite.xcodeproj/project.pbxproj.bak" 
  rm -f "${SCRIPT_DIR}/../iOSSplitSuite.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved.bak"
  
  # If the script failed and we created a branch, clean up the branch
  if [ $EXIT_CODE -ne 0 ] && [ "$BRANCH_CREATED" = true ]; then
    echo "🗑️ Script failed. Cleaning up release branch..."
    
    # Switch back to the original branch
    if [ ! -z "$ORIGINAL_BRANCH" ]; then
      echo "🔙 Switching back to $ORIGINAL_BRANCH branch..."
      git checkout "$ORIGINAL_BRANCH"
    fi
    
    # Delete the release branch if it was created
    if git show-ref --verify --quiet "refs/heads/$RELEASE_BRANCH"; then
      echo "🗑️ Removing $RELEASE_BRANCH branch..."
      git branch -D "$RELEASE_BRANCH"
    fi
    
    echo "❌ Release preparation failed. All changes have been reverted."
  fi
}

# Set up trap to clean up on exit (including failures)
trap cleanup EXIT

# Function to handle errors
handle_error() {
  SCRIPT_FAILED=true
  echo "❌ Error: $1"
  exit 1
}

# Function to log debug information
log_debug_info() {
  echo "🔍 DEBUG INFO: $1"
  echo "$2" | head -20
  if [ "$(echo "$2" | wc -l)" -gt 20 ]; then
    echo "... (truncated for brevity)"
  fi
}

# Function to update dependency version in project.pbxproj
update_project_dependency() {
  local DEPENDENCY_NAME=$1
  local VERSION=$2
  local REPO_URL=$3
  
  echo "📝 Updating $DEPENDENCY_NAME version constraint in project file to $VERSION..."
  
  # First, show what we're going to update
  echo "Current $DEPENDENCY_NAME version in project.pbxproj:"
  grep -A 10 "repositoryURL = \"$REPO_URL\"" "$PROJECT_PBXPROJ" | grep -A 2 "version ="
  
  # Use awk to find the section with the repository URL and update the version
  awk -v version="$VERSION" -v repo="$REPO_URL" '
    $0 ~ "repositoryURL = \"" repo "\"" { in_section = 1; }
    in_section && /version = / { sub(/version = [^;]*;/, "version = " version ";"); in_section = 0; }
    { print }
  ' "$PROJECT_PBXPROJ" > "${PROJECT_PBXPROJ}.tmp" && mv "${PROJECT_PBXPROJ}.tmp" "$PROJECT_PBXPROJ"
  
  # Verify the update was successful
  local PACKAGE_NAME=$(basename "$REPO_URL")
  if grep -A 10 "$REPO_URL" "$PROJECT_PBXPROJ" | grep -q "version = $VERSION"; then
    echo "✅ Successfully updated $DEPENDENCY_NAME version constraint in project.pbxproj"
    return 0
  else
    echo "❌ Failed to update $DEPENDENCY_NAME version constraint in project.pbxproj"
    echo "Expected to find: version = $VERSION for $PACKAGE_NAME"
    echo "Actual content:"
    grep -A 10 "$PACKAGE_NAME" "$PROJECT_PBXPROJ" | grep -A 5 "version"
    
    # Restore the backup
    mv "${PROJECT_PBXPROJ}.bak" "$PROJECT_PBXPROJ"
    handle_error "Failed to update $DEPENDENCY_NAME version in project.pbxproj. This is critical for the release process."
    return 1
  fi
}

# Function to get revision hash for a dependency
get_revision_hash() {
  local DEPENDENCY_NAME=$1
  local VERSION=$2
  local REPO_URL=$3
  local PACKAGE_NAME=$(basename "$REPO_URL")
  
  echo "🔍 Looking up revision hash for $DEPENDENCY_NAME version $VERSION..." >&2
  
  # Create a temporary package to resolve the revision
  local TEMP_DIR=$(mktemp -d)
  pushd "$TEMP_DIR" > /dev/null
  
  # Create a minimal Package.swift file
  cat > Package.swift << EOF
// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "TempPackage",
    dependencies: [
        .package(url: "$REPO_URL", .exact("$VERSION"))
    ]
)
EOF
  
  # Resolve the package to get the revision
  swift package resolve > /dev/null 2>&1
  
  # Extract the revision
  local REVISION=""
  if [ -f "Package.resolved" ]; then
    # Use a more reliable method to extract the revision
    REVISION=$(cat Package.resolved | grep -A 3 "$PACKAGE_NAME" | grep "revision" | awk -F": " '{print $2}' | sed 's/[,"]//g')
  fi
  
  popd > /dev/null
  rm -rf "$TEMP_DIR"
  
  # Print only the hash to stdout (for capture by command substitution)
  echo "$REVISION"
}

# Function to update dependency in Package.resolved
update_package_resolved() {
  local DEPENDENCY_NAME=$1
  local VERSION=$2
  local REVISION=$3
  local PACKAGE_NAME=$4
  
  echo "📝 Updating $DEPENDENCY_NAME version in Package.resolved to $VERSION..."
  
  if [ -z "$REVISION" ]; then
    echo "⚠️ Warning: Could not determine revision hash for $DEPENDENCY_NAME version $VERSION."
    echo "Will only update the version number, not the revision."
  fi
  
  # Use a simpler, more direct approach with jq if available
  if command -v jq &> /dev/null; then
    echo "Using jq to update Package.resolved..."
    
    # Log the current structure of Package.resolved
    echo "🔍 Current Package.resolved structure:"
    jq '.pins[] | select(.identity == "'$PACKAGE_NAME'")' "$PROJECT_RESOLVED"
    
    # Create the jq command
    JQ_COMMAND="jq --arg ver \"$VERSION\" --arg rev \"${REVISION:-}\" '
      .pins[] |= if .identity == \"$PACKAGE_NAME\" then 
        .state.version = \$ver | 
        if \$rev != \"\" then .state.revision = \$rev else . end 
      else . end
    ' \"$PROJECT_RESOLVED\" > \"${PROJECT_RESOLVED}.tmp\" && mv \"${PROJECT_RESOLVED}.tmp\" \"$PROJECT_RESOLVED\""
    
    # Log the command
    echo "📝 JQ command: $JQ_COMMAND"
    
    # Execute the command
    jq --arg ver "$VERSION" --arg rev "${REVISION:-}" '
      .pins[] |= if .identity == "'$PACKAGE_NAME'" then 
        .state.version = $ver | 
        if $rev != "" then .state.revision = $rev else . end 
      else . end
    ' "$PROJECT_RESOLVED" > "${PROJECT_RESOLVED}.tmp" && mv "${PROJECT_RESOLVED}.tmp" "$PROJECT_RESOLVED"
    
    # Log the updated structure
    echo "🔍 Updated Package.resolved structure:"
    jq '.pins[] | select(.identity == "'$PACKAGE_NAME'")' "$PROJECT_RESOLVED" || echo "🚨 Error: Could not parse updated Package.resolved"
  else
    # Fall back to a more reliable direct replacement with perl
    echo "Using perl to update Package.resolved..."
    # First update the version
    perl -i -pe "s/(\"identity\".*?\"$PACKAGE_NAME\".*?\"version\".*?\")[^\"]*(\")/$1$VERSION$2/s" "$PROJECT_RESOLVED"
    # Then update the revision if we have one
    if [ ! -z "$REVISION" ]; then
      perl -i -pe "s/(\"identity\".*?\"$PACKAGE_NAME\".*?\"revision\".*?\")[^\"]*(\")/$1$REVISION$2/s" "$PROJECT_RESOLVED"
    fi
  fi
  
  # Check if the update was successful using jq to verify
  if command -v jq &> /dev/null && jq -e --arg ver "$VERSION" '.pins[] | select(.identity == "'$PACKAGE_NAME'") | .state.version == $ver' "$PROJECT_RESOLVED" > /dev/null; then
    echo "✅ Successfully updated $DEPENDENCY_NAME version to $VERSION"
    return 0
  else
    # Try a more flexible grep approach as a backup check
    if grep -q "\"version\".*\"$VERSION\"" "$PROJECT_RESOLVED" && grep -q "$PACKAGE_NAME" "$PROJECT_RESOLVED"; then
      echo "✅ Successfully updated $DEPENDENCY_NAME version to $VERSION (verified with grep)"
      return 0
    else
      echo "❌ Failed to update $DEPENDENCY_NAME version in Package.resolved."
      echo "Expected to find version $VERSION for $PACKAGE_NAME" 
      echo "Actual $PACKAGE_NAME section:"
      grep -A 10 "$PACKAGE_NAME" "$PROJECT_RESOLVED"
      
      # Try a more direct approach as a fallback
      echo "🔧 Trying alternative update method..."
      perl -i -pe "s/(\"identity\".*?\"$PACKAGE_NAME\".*?\"version\".*?\")[^\"]*(\")/$1$VERSION$2/s" "$PROJECT_RESOLVED"
      
      # Check if the fallback worked
      if grep -q "\"version\".*\"$VERSION\"" "$PROJECT_RESOLVED" && grep -q "$PACKAGE_NAME" "$PROJECT_RESOLVED"; then
        echo "✅ Successfully updated $DEPENDENCY_NAME version to $VERSION using fallback method"
        return 0
      else
        # Log more detailed debug information
        log_debug_info "Full Package.resolved content:" "$(cat "$PROJECT_RESOLVED")"
        
        # Restore the backup
        mv "${PROJECT_RESOLVED}.bak" "$PROJECT_RESOLVED"
        handle_error "Failed to update $DEPENDENCY_NAME version in Package.resolved. This is critical for the release process."
        return 1
      fi
    fi
  fi
}

# Check if working directory is clean
if [ -n "$(git status --porcelain)" ]; then
  handle_error "Working directory is not clean. Please commit or stash your changes first."
fi

# Get current versions from files
CURRENT_SUITE_VERSION=$(grep -o 'private static let kVersion = "[^"]*"' iOSSplitSuite/SplitSuite/Common/Version.swift | cut -d'"' -f2)

# Use jq if available for more reliable JSON parsing
if command -v jq &> /dev/null; then
  CURRENT_SDK_VERSION=$(cat iOSSplitSuite.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved | jq -r '.pins[] | select(.identity == "ios-client") | .state.version')
  CURRENT_RUM_VERSION=$(cat iOSSplitSuite.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved | jq -r '.pins[] | select(.identity == "ios-rum") | .state.version')
else
  # Fallback to grep/sed if jq is not available
  CURRENT_SDK_VERSION=$(grep -A 10 '"identity": "ios-client"' iOSSplitSuite.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved | grep -o '"version": "[^"]*"' | head -1 | cut -d'"' -f4)
  CURRENT_RUM_VERSION=$(grep -A 10 '"identity": "ios-rum"' iOSSplitSuite.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved | grep -o '"version": "[^"]*"' | head -1 | cut -d'"' -f4)
fi

# Display current versions
echo "📋 Current versions:"
echo "   - Suite: $CURRENT_SUITE_VERSION"
echo "   - SDK: $CURRENT_SDK_VERSION"
echo "   - RUM: $CURRENT_RUM_VERSION"
echo ""

# Prompt for Suite version
read -p "Enter Split Suite version (current: $CURRENT_SUITE_VERSION): " SUITE_VERSION
if [ -z "$SUITE_VERSION" ]; then
  echo "❌ Error: Suite version is required"
  exit 1
fi

# Prompt for SDK version
read -p "Enter SDK version (current: $CURRENT_SDK_VERSION, press Enter to keep current): " SDK_VERSION
if [ -z "$SDK_VERSION" ]; then
  echo "ℹ️ Keeping current SDK version: $CURRENT_SDK_VERSION"
fi

# Prompt for RUM version
read -p "Enter RUM version (current: $CURRENT_RUM_VERSION, press Enter to keep current): " RUM_VERSION
if [ -z "$RUM_VERSION" ]; then
  echo "ℹ️ Keeping current RUM version: $CURRENT_RUM_VERSION"
fi

RELEASE_BRANCH="release/$SUITE_VERSION"

# Get current date in format: (Jun 5, 2025)
CURRENT_DATE=$(date "+%b %-d, %Y")

# Fetch latest changes from remote
echo "📥 Fetching latest changes from remote..."
git fetch origin

# Get current branch
ORIGINAL_BRANCH=$(git symbolic-ref --short HEAD)
echo "📋 Current branch: $ORIGINAL_BRANCH"

# Create release branch from current branch
echo "🌿 Creating branch $RELEASE_BRANCH from $ORIGINAL_BRANCH..."
git checkout -b $RELEASE_BRANCH
BRANCH_CREATED=true

# Check if this is an RC version
IS_RC=false
if [[ "$SUITE_VERSION" == *"-rc"* ]]; then
  IS_RC=true
fi

# Update Version.swift
echo "📝 Updating Version.swift to $SUITE_VERSION..."
sed -i '' "s/private static let kVersion = \".*\"/private static let kVersion = \"$SUITE_VERSION\"/" iOSSplitSuite/SplitSuite/Common/Version.swift

# Update dependencies if needed
if [ ! -z "$SDK_VERSION" ] || [ ! -z "$RUM_VERSION" ]; then
  # Use the entered versions or fall back to current versions if empty
  SDK_VERSION=${SDK_VERSION:-$CURRENT_SDK_VERSION}
  RUM_VERSION=${RUM_VERSION:-$CURRENT_RUM_VERSION}
  
  # Update the project.pbxproj file to change the version constraints
  PROJECT_PBXPROJ="$SCRIPT_DIR/../iOSSplitSuite.xcodeproj/project.pbxproj"
  
  # Make a backup of the project file
  cp "$PROJECT_PBXPROJ" "${PROJECT_PBXPROJ}.bak"
  
  # Update SDK version in project.pbxproj if provided
  if [ ! -z "$SDK_VERSION" ]; then
    update_project_dependency "iOS SDK" "$SDK_VERSION" "https://github.com/splitio/ios-client"
  fi
  
  # Update RUM version in project.pbxproj if provided
  if [ ! -z "$RUM_VERSION" ]; then
    update_project_dependency "RUM" "$RUM_VERSION" "https://github.com/splitio/ios-rum"
  fi
  
  # Update the dependencies directly in the Package.resolved file
  echo "📦 Updating dependencies in Package.resolved..."
  
  # Path to the project's Package.resolved file
  PROJECT_RESOLVED="$SCRIPT_DIR/../iOSSplitSuite.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved"
  
  # Make a backup of the Package.resolved file
  cp "$PROJECT_RESOLVED" "${PROJECT_RESOLVED}.bak"
  
  # Update SDK version in Package.resolved if provided
  if [ ! -z "$SDK_VERSION" ]; then
    # Capture only the revision hash, not the log message
    SDK_REVISION=$(get_revision_hash "iOS SDK" "$SDK_VERSION" "https://github.com/splitio/ios-client")
    echo "📝 Found revision hash for iOS SDK version $SDK_VERSION: $SDK_REVISION"
    update_package_resolved "iOS SDK" "$SDK_VERSION" "$SDK_REVISION" "ios-client"
  fi
  
  # Update RUM version in Package.resolved if provided
  if [ ! -z "$RUM_VERSION" ]; then
    # Capture only the revision hash, not the log message
    RUM_REVISION=$(get_revision_hash "RUM" "$RUM_VERSION" "https://github.com/splitio/ios-rum")
    echo "📝 Found revision hash for RUM version $RUM_VERSION: $RUM_REVISION"
    update_package_resolved "RUM" "$RUM_VERSION" "$RUM_REVISION" "ios-rum"
  fi
  
  echo "✅ Dependencies updated successfully in both project.pbxproj and Package.resolved!"
fi

# Commit changes
echo "💾 Committing changes..."
# Add all modified files
git add iOSSplitSuite/SplitSuite/Common/Version.swift \
     iOSSplitSuite.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved \
     iOSSplitSuite.xcodeproj/project.pbxproj
git commit -m "chore: Update Suite version to $SUITE_VERSION"
if [ ! -z "$SDK_VERSION" ]; then
  git commit --amend -m "chore: Update Suite version to $SUITE_VERSION and SDK version to $SDK_VERSION"
fi
if [ ! -z "$RUM_VERSION" ]; then
  git commit --amend -m "chore: Update Suite version to $SUITE_VERSION, SDK version to $SDK_VERSION and RUM version to $RUM_VERSION"
fi

# Push changes
echo "📤 Pushing branch to remote..."
git push origin $RELEASE_BRANCH

# Get the remote URL and extract the GitHub repo path
REMOTE_URL=$(git config --get remote.origin.url)
echo "🔍 Remote URL: $REMOTE_URL"

# Handle different URL formats (SSH, HTTPS, etc)
if [[ $REMOTE_URL == *"@github.com:"* ]]; then
  # SSH format: git@github.com:org/repo.git
  GITHUB_REPO=$(echo $REMOTE_URL | sed -E 's/.*github.com:([^\.]+)(\.git)?/\1/')
elif [[ $REMOTE_URL == *"github.com/"* ]]; then
  # HTTPS format: https://github.com/org/repo.git
  GITHUB_REPO=$(echo $REMOTE_URL | sed -E 's/.*github.com\/([^\.]+)(\.git)?/\1/')
else
  # Fallback
  GITHUB_REPO="splitio/ios-suite-dev"
fi

echo "🔍 Extracted GitHub repo: $GITHUB_REPO"

# Fallback if extraction failed
if [ -z "$GITHUB_REPO" ] || [ "$GITHUB_REPO" == "$REMOTE_URL" ]; then
  echo "⚠️ Could not extract GitHub repo from URL. Using default."
  GITHUB_REPO="splitio/ios-suite-dev"
fi

# Determine target branch based on RC status
if [ "$IS_RC" = true ]; then
  TARGET_BRANCH="$DEV_TEST_BRANCH"
  echo "📊 RC version detected, PR will target the $DEV_TEST_BRANCH branch"
else
  TARGET_BRANCH="$MAIN_BRANCH"
  echo "📊 Regular version detected, PR will target the $MAIN_BRANCH branch"
fi

# Create PR URL
PR_URL="https://github.com/$GITHUB_REPO/compare/$TARGET_BRANCH...$RELEASE_BRANCH?expand=1"
echo ""
echo "🎉 Release preparation completed successfully!"
echo ""
echo "📝 Pull request URL: $PR_URL"
echo "Opening browser to create pull request..."
open "$PR_URL"
echo ""
if [ ! -z "$SDK_VERSION" ] || [ ! -z "$RUM_VERSION" ]; then
  echo "✅ Dependencies updated in both Package.resolved and project.pbxproj:"
  if [ ! -z "$SDK_VERSION" ]; then
    echo "   - iOS SDK: $SDK_VERSION"
  fi
  if [ ! -z "$RUM_VERSION" ]; then
    echo "   - RUM Agent: $RUM_VERSION"
  fi
  echo ""
  echo "⚠️ Note: When opening in Xcode, if prompted to update packages:"
  echo "   - Choose 'Keep Package Versions' to maintain your specified versions"
fi
echo ""
echo "Next steps:"
echo "1. Complete the pull request to merge $RELEASE_BRANCH into $TARGET_BRANCH"
echo "2. After merging, the GitHub workflow will create and push the tag"
echo ""
