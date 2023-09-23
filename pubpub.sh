#!/bin/bash
set -e && cd "${0%/*}"

# creates a copy of the project in temporary directory
# and prepares the copy to be published

temp_pub_dir=$(mktemp -d -t pub-XXXXXXX)

echo "$temp_pub_dir"

rsync -Rrv ./ "$temp_pub_dir" \
  --exclude=".git/" \
  --exclude="pubpub.sh" \
  --exclude="test/" \
  --exclude="todo.txt" \
  --exclude="example/build" \
  --exclude="example/android" \
  --exclude="example/ios" \
  --exclude="example/web" \
  --exclude="example/lib/generated_plugin_registrant.dart" \
  --exclude="example/example.iml" \
  --exclude="benchmark/" \
  --exclude="reference/" \
  --exclude="shell/" \
  --exclude="shell_nogit/" \
  --exclude="build/" \
  --exclude="README.md" \
  --exclude=".github" \
  --exclude="labuda/" \
  --exclude="draft/" \
  --exclude="experiments"

# removing everything before "\n# ", the first header
old_readme=$(cat README.md | tr '\n' '\r')
new_readme=$(echo "$old_readme" | perl -p0e 's|^.*?\r# |# \1|')
new_readme=$(echo "$new_readme" |  tr '\r' '\n')
#№new_readme=$(echo $old_readme | perl -p0e 's|^.*?\r# |# \1|' | tr '\r' '\n')
echo "$new_readme" > "$temp_pub_dir/README.md"

cd "$temp_pub_dir"
mkdir .git
dartfmt -w .
flutter analyze
#flutter pub publish --dry-run
flutter pub publish
#open "$temp_pub_dir"