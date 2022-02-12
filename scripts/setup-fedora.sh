#!/bin/sh

source /varsrc

# Issuing https://web.archive.org/web/20200209173743/http://www.se.rit.edu/~dkrutz/CCCD/index.html?page=install
echo " - New User"
# https://docs.fedoraproject.org/en-US/Fedora/15/html/Deployment_Guide/s1-users-tools.html
# thanks to opam, there is already 1000
usermod --uid 1001 opam
groupadd --gid 1000 --non-unique fedora-group && adduser fedora-user --home /home/fedora-user --uid 1000 --gid fedora-group

cd "$HOME_FOLDER"

echo " - Installing basic packages"

dnf upgrade -y --refresh
# note: i do not lock the version as at least at the moment, there should be no reason to lock it and deny afuture builds
# where these are no longe ravaialble see packages.version
dnf install -y tar wget unzip findutils ocaml ocaml-findlib ocaml-ocamlbuild ocaml-ocamldoc perl opam ocaml-num gmp gmp-devel gcc-c++

echo " - Setup opam & ocaml"

opam init
opam switch create "$OCAML_VERSION" # most up to date version on release of CREST|CIL

echo "Done."