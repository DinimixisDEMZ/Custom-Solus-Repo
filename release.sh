#!/bin/bash

# Configuration of paths
mkdir -p "$(pwd)/Releases"
DEST="$(pwd)/Releases"

TAG_NAME="Dini-$(date +%s)"
RELEASE_NAME="$PACKAGE-$(date +%s)"

PACKAGE_PATH=$(find . -maxdepth 2 -name "*.eopkg" -print -quit)

if [ -n "$PACKAGE_PATH" ]; then
    PACKAGE_FILE=$(basename "$PACKAGE_PATH")
    echo "✅ Package detected: $PACKAGE_FILE in the path $PACKAGE_PATH"
    
    DEST="./Releases"
    mkdir -p "$DEST"
    
    if [ "$PACKAGE_PATH" != "$DEST/$PACKAGE_FILE" ]; then
        cp "$PACKAGE_PATH" "$DEST/"
        echo "File copied to $DEST"
    fi
else
    echo "❌ No .eopkg file found. Aborting release."
    exit 0
fi

SIZE=$(du -h "$DEST/$PACKAGE_FILE" | cut -f1)
MD5=$(md5sum "$DEST/$PACKAGE_FILE" | cut -d' ' -f1)

echo "SIZE=$SIZE" >> "$GITHUB_ENV"
echo "MD5=$MD5" >> "$GITHUB_ENV"

echo "Info: Size $SIZE, MD5 $MD5"
echo "File detected: $PACKAGE_FILE"
cd "$(pwd)/Releases/"