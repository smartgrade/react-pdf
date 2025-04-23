#!/bin/bash

# Array of package directories to publish
packages=(
  "fns"
  "font"
  "image"
  "layout"
  "pdfkit"
  "png-js"
  "primitives"
  "reconciler"
  "render"
  "renderer"
  "stylesheet"
  "textkit"
  "types"
)

# Function to update version in package.json
update_version() {
  local package=$1
  local package_json="packages/$package/package.json"
  
  if [ ! -f "$package_json" ]; then
    echo "❌ Error: package.json not found in $package"
    return 1
  fi
  
  # Read current version
  current_version=$(jq -r '.version' "$package_json")
  
  # Split version into parts
  IFS='.' read -r major minor patch <<< "$current_version"
  
  # Increment patch version
  new_patch=$((patch + 1))
  new_version="$major.$minor.$new_patch"
  
  # Update version in package.json
  jq --arg new_version "$new_version" '.version = $new_version' "$package_json" > "${package_json}.tmp"
  mv "${package_json}.tmp" "$package_json"
  
  echo "📝 Updated $package version from $current_version to $new_version"
}

# Function to publish a package
publish_package() {
  local package=$1
  echo "📦 Publishing package: $package"
  cd "packages/$package" || exit 1
  
  # Check if package.json exists
  if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found in $package"
    return 1
  fi
  
  # Run npm publish
  npm publish
  
  # Check if publish was successful
  if [ $? -eq 0 ]; then
    echo "✅ Successfully published $package"
  else
    echo "❌ Failed to publish $package"
  fi
  
  cd ../..
}

# Main execution
echo "🚀 Starting package publishing process..."

# First update versions for all packages
echo "📝 Updating package versions..."
for package in "${packages[@]}"; do
  update_version "$package"
done

# Then publish each package
echo "📦 Publishing packages..."
for package in "${packages[@]}"; do
  publish_package "$package"
done

echo "✨ Publishing process completed!" 