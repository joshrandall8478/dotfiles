#!/bin/bash
username=$(whoami)
creator="joshr"

echo "dot_config: Replacing $creator with $username"
find dot_config -type f -exec sed -i "s/{$creator}/{$username}/g" {} +

echo "dot_local: Replacing $creator with $username"
find dot_local -type f -exec sed -i "s/{$creator}/{$username}/g" {} +

echo "dot_zshrc: Replacing $creator with $username"
find dot_zshrc -type f -exec sed -i "s/{$creator}/{$username}/g" {} +

echo "Done"