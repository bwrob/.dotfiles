#!/bin/bash

# czytamy ścieżkę wejściową
dir_path="$1"

# sprawdzamy czy istnieje
if [ ! -d "$dir_path" ]; then
  echo "Scieżka '$dir_path' nie istnieje."
  exit
fi
# wchodzimy do środka żeby było prościej
cd $dir_path

# nazwa logu
logfile="auto-git-pull.log"

# jeżeli nie istnieje to go tworzymy
if [ ! -e $logfile ]; then
  touch logfile
fi

# pętla po folderach w dir_path
for subdir in $(ls); do
  if [ -d $subdir ] && [ -d "$subdir/.git" ]; then
    echo "Pullujemy z repozytorium $subdir."
    # wywołujemy cd i git pull
    # stremujemy wyjście do logu, przekazujemy strumien błędu do zwykłego
    cd "$subdir"
    git pull >>"../$logfile" 2>&1
    # wracamy do folderu wejściowego
    cd ..
  fi
done

echo "Wszystkie repo bieżące, patrz $dir_path/$logfile."
