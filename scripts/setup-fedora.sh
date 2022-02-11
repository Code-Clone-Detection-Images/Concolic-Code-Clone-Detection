#!/bin/sh

source /varsrc

# Issuing https://web.archive.org/web/20200209173743/http://www.se.rit.edu/~dkrutz/CCCD/index.html?page=install
echo " - New User"
groupadd fedora-group && adduser fedora-user -m -g fedora-group

cd "$HOME_FOLDER"

echo " - Installing basic packages"

dnf upgrade -y --refresh
dnf install -y tar wget unzip findutils ocaml ocaml-findlib ocaml-ocamlbuild ocaml-ocamldoc perl opam ocaml-num gmp gmp-devel

echo " - Setup opam & ocaml"

opam init
opam switch create "$OCAML_VERSION" # most up to date version on release of CREST|CIL

echo "Done."