#!/bin/bash

# Suppression du dossier docs et du dossier subjects
if [ -d "docs" ]; then
  rm -r docs/*
else
  mkdir docs
fi

git clone https://github.com/Studio-17/Epitech-Subjects.git subjects

# Chemin du dossier subjects
src_path="./subjects"

# Chemin du dossier docs
dst_path="./docs"

# Parcours récursif des dossiers dans subjects
for dir in $(find $src_path -type d); do
    # Création du chemin relatif du dossier courant
    if [[ $dir == *".git"* || $dir == *".github"* ]]; then
      continue
    fi
    rel_path=${dir#$src_path/}
    # Création du chemin absolu du dossier courant dans docs
    abs_path="$dst_path/$rel_path"

    # Vérifie s'il existe un fichier pdf ou .md dans le dossier courant
    if [ -n "$(find $dir -maxdepth 1 -name '*.pdf')" ]; then
        # Création du fichier .mdx avec le nom du dossier courant
        IFS='/' read -ra ADDR <<< "$rel_path"
        echo -e "---\ntitle: Firtree\ntags:" >> "$abs_path.mdx"
        for i in "${ADDR[@]}"; do
          echo "  - $i" >> "$abs_path.mdx"
        done
        echo -e "---\n> Timeline: ?\n\n" >> "$abs_path.mdx"
        # Ajout de tous les fichiers dans le dossier courant dans le fichier .mdx
        echo -e "## Files 📂\n\n:::note 2020 Subject and Files" >> "$abs_path.mdx"
        find $dir -maxdepth 1 -type f -not -name '*.md' -not -name 'tests.txt' -exec bash -c 'string={}; filename=$(basename "$string"); echo "- [$filename]($string)"' \; >> "$abs_path.mdx"
        echo -e ":::\n" >> "$abs_path.mdx"
            echo -e "## Tests 🤖\n<details>\n  <summary>Toggle to see the tests</summary>\n  <div>" >> "$abs_path.mdx"
            echo "Yo" >> "$abs_path.mdx"
            echo -e "  </div>\n</details>\n" >> "$abs_path.mdx"
        if [ -f "$dir/tests.txt" ]; then
            # Ajout du contenu du fichier tests.txt dans le fichier .mdx
            echo -e "## Tests 🤖\n<details>\n  <summary>Toggle to see the tests</summary>\n  <div>" >> "$abs_path.mdx"
            cat "$dir/tests.txt" >> "$abs_path.mdx"
            echo -e "  </div>\n</details>\n" >> "$abs_path.mdx"
        fi
        sed -i '' -e 's|./subjects/|https://github.com/Studio-17/Epitech-Subjects/raw/main/|g' "$abs_path.mdx"
    else
        # Création du dossier courant dans docs
        mkdir -p $abs_path
        # Création du fichier category.json dans le dossier courant
        touch "$abs_path/_category_.json"
        # Ecrire le nom du dossier courant dans le fichier category.json
        echo "{\"label\": \"$rel_path\",\"link\": {\"type\": \"generated-index\", \"description\": \"To define\"}}" >> "$abs_path/_category_.json"
    fi
done

# Suppression du dossier subjects
rm -rf subjects