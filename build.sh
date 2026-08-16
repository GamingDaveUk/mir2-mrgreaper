#!/usr/bin/env bash
set -euo pipefail

CONFIGURATION="${1:-Release}"

publish_and_deploy() {
    local project="$1"
    local build_dir="$2"
    local dest_dir="$3"

    echo "Publishing $project ($CONFIGURATION)..."
    dotnet publish "$project" -c "$CONFIGURATION" -r win-x64 --self-contained true -p:EnableWindowsTargeting=true

    echo "Deploying $project -> live/$dest_dir"
    mkdir -p "live/$dest_dir"
    cp -rf "${build_dir}/Release/win-x64/publish/." "live/$dest_dir/"
    rm -rf "${build_dir}/Release/win-x64"
}

publish_and_deploy "Server.MirForms/Server.csproj" "Build/Server" "Server"
publish_and_deploy "Client/Client.csproj" "Build/Client" "Client"
publish_and_deploy "LibraryEditor/LibraryEditor.csproj" "Build/Server Tools/LibraryEditor" "Tools/LibraryEditor"
publish_and_deploy "LibraryViewer/LibraryViewer.csproj" "Build/Server Tools/LibraryViewer" "Tools/LibraryViewer"

echo "Build complete."
