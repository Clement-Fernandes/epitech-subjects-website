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

touch "docs/intro.md"

echo "---
sidebar_position: 1
---

# Intro

![Studio 17](https://img.shields.io/badge/Github-Studio--17-06DFF9)
![Version](https://img.shields.io/badge/Release-v0.5beta-ff0000)
![visitor badge](https://visitor-badge.glitch.me/badge?page_id=Studio-17.Epitech-Subjects)

Welcome to the **Epitech Subjects** website ! This directory contains all topics and files related to Epitech PGE program.

:::important Note
**This website is not official and is not related to Epitech in any way.**

All the files are not yet up to date (they will be gradually)
:::

:::tip Featuring
The valid credits, the timeline, the tests (details of the Marvin tests, TAM, DEFENSE) for these projects are also indicated by clicking on the links.

If you want to **contribute** or you have found a problem, you can do it by creating a issue [Here](https://github.com/Studio-17/Epitech-Subjects/issues).
:::

## All these semesters are available

- [Semester 0](/docs/category/semester-0)
- [Semester 1](/docs/category/semester-1)
- [Semester 2](/docs/category/semester-2)
- [Semester 3](/docs/category/semester-3)
- [Semester 4](/docs/category/semester-4)" >> "docs/intro.md"

# Parcours récursif des dossiers dans subjects
for dir in "$(find "$src_path" -type d)"; do
    # Création du chemin relatif du dossier courant
    if [[ $dir == *".git"* || $dir == *".github"* ]]; then
      continue
    fi
    rel_path=${dir#$src_path/}
    # Création du chemin absolu du dossier courant dans docs
    abs_path="$dst_path/$rel_path"

    # Vérifie s'il existe un fichier pdf ou .md dans le dossier courant
    if [ -n "$(find "$dir" -maxdepth 1 -name '*.pdf')" ]; then
        # Création du fichier .mdx avec le nom du dossier courant
        IFS='/' read -ra ADDR <<< "$rel_path"
        echo -e "---\ntitle: ${abs_path##*/}\ntags:" >> "$abs_path.mdx"
        for i in "${ADDR[@]}"; do
          echo "  - $i" >> "$abs_path.mdx"
        done
        echo -e "---\n> Timeline: ?\n\n" >> "$abs_path.mdx"
        # Ajout de tous les fichiers dans le dossier courant dans le fichier .mdx
        echo -e "## Files 📂\n\n:::note 2020 Subject and Files" >> "$abs_path.mdx"
        find "$dir" -maxdepth 1 -type f -not -name '*.md' -not -name 'tests.txt' -exec bash -c 'string={}; filename=$(basename "$string"); echo "- [$filename]($string)"' \; >> "$abs_path.mdx"
        echo -e ":::\n" >> "$abs_path.mdx"
        if [ -f "$dir/tests.txt" ]; then
            # Ajout du contenu du fichier tests.txt dans le fichier .mdx
            echo -e "## Tests 🤖\n<details>\n  <summary>Toggle to see the tests</summary>\n  <div>" >> "$abs_path.mdx"
            cat "$dir/tests.txt" >> "$abs_path.mdx"
            echo -e "  </div>\n</details>\n" >> "$abs_path.mdx"
        fi
        sed -i '' -e 's|./subjects/|https://github.com/Studio-17/Epitech-Subjects/raw/main/|g' "$abs_path.mdx"
    else
        # Création du dossier courant dans docs
        mkdir -p "$abs_path"
        # Création du fichier category.json dans le dossier courant
        touch "$abs_path/_category_.json"
        # Ecrire le nom du dossier courant dans le fichier category.json
        echo "{\"label\": \"${rel_path##*/}\",\"link\": {\"type\": \"generated-index\", \"description\": \"To define\"}}" >> "$abs_path/_category_.json"
    fi
done

# Suppression du dossier subjects
rm -rf subjects
rm -rf docs/subjects