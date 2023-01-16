#!/bin/bash

# Verify if the 'docs' folder exists
if [ -d "docs" ]; then
  rm -r docs/*
else
  mkdir docs
fi

# Clone the 'Epitech-Subjects' repository to get all the directories
git clone https://github.com/Studio-17/Epitech-Subjects.git subjects

# Path of the subjects folder
src_path="./subjects"

# Path of the docs folder
dst_path="./docs"

touch "docs/intro.md"
# Copy the intro.md file into the docs folder
cp ".github/intro.md" "docs/intro.md"

# Recursively browse the 'subjects' folder
for dir in $(find $src_path -type d); do
    # Vérifie de ne pas copier le dossier .git et .github
    if [[ $dir == *".git"* || $dir == *".github"* ]]; then
      continue
    fi
    # Create the relative path of the current folder in 'subjects'
    rel_path=${dir#$src_path/}
    # Create the absolute path of the current folder in 'docs'
    abs_path="$dst_path/$rel_path"

    # Verify if the current folder contains a pdf file
    if [ -n "$(find $dir -maxdepth 1 -name '*.pdf')" ]; then
        # Create the .mdx file in the docs folder
        IFS='/' read -ra ADDR <<< "$rel_path"
        echo -e "---\ntitle: ${abs_path##*/}\ntags:" >> "$abs_path.mdx"
        for i in "${ADDR[@]}"; do
          echo "  - $i" >> "$abs_path.mdx"
        done
        echo -e "---\n> Timeline: ?\n\n" >> "$abs_path.mdx"
        # Complete the .mdx file with the content of the directory
        echo -e "## Files 📂\n\n:::note 2020 Subject and Files" >> "$abs_path.mdx"
        find $dir -maxdepth 1 -type f -not -name '*.md' -not -name 'tests.txt' -exec bash -c 'string={}; filename=$(basename "$string"); echo "- [$filename]($string)"' \; >> "$abs_path.mdx"
        echo -e ":::\n" >> "$abs_path.mdx"
            echo -e "## Tests 🤖\n<details>\n  <summary>Toggle to see the tests</summary>\n  <div>" >> "$abs_path.mdx"
            echo "Yo" >> "$abs_path.mdx"
            echo -e "  </div>\n</details>\n" >> "$abs_path.mdx"
        if [ -f "$dir/tests.txt" ]; then
            # Add the tests in the .mdx file
            echo -e "## Tests 🤖\n<details>\n  <summary>Toggle to see the tests</summary>\n  <div>" >> "$abs_path.mdx"
            cat "$dir/tests.txt" >> "$abs_path.mdx"
            echo -e "  </div>\n</details>\n" >> "$abs_path.mdx"
        fi
        sed -i '' -e 's|./subjects/|https://github.com/Studio-17/Epitech-Subjects/raw/main/|g' "$abs_path.mdx"
    else
        # Create the folder in the 'docs' folder
        mkdir -p $abs_path
        # Create the category.json file in the current folder
        touch "$abs_path/_category_.json"
        # Add the content of the '_category_.json' file
        echo "{\"label\": \"${rel_path##*/}\",\"link\": {\"type\": \"generated-index\", \"description\": \"To define\"}}" >> "$abs_path/_category_.json"
    fi
done

# Delete the folders that we don't need anymoregit status
rm -rf ./subjects
rm -rf ./docs/subjects
