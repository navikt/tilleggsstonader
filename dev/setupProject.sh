#!/bin/bash

# Lager symlinks til pre-push script for backends(kotlin) som kjører lint og feiler vid feil
# -n: If the target file already exists, do not overwrite it.
#   This prevents accidentally overwriting an existing pre-commit hook with a new one.
# -i: interative, spør om sletting av eksisterende
# -s: symbolic link
ln -nsi "../../../dev/git-hooks-backend/pre-push" "tilleggsstonader-arena/.git/hooks/pre-push"
ln -nsi "../../../dev/git-hooks-backend/pre-push" "tilleggsstonader-integrasjoner/.git/hooks/pre-push"
ln -nsi "../../../dev/git-hooks-backend/pre-push" "tilleggsstonader-kontrakter/.git/hooks/pre-push"
ln -nsi "../../../dev/git-hooks-backend/pre-push" "tilleggsstonader-libs/.git/hooks/pre-push"
ln -nsi "../../../dev/git-hooks-backend/pre-push" "tilleggsstonader-sak/.git/hooks/pre-push"
ln -nsi "../../../dev/git-hooks-backend/pre-push" "tilleggsstonader-soknad-api/.git/hooks/pre-push"
echo "Opprettet symlinks"