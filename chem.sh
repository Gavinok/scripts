#!/usr/bin/env sh

######################################################################
# @author      : Gavin Jaeger-Freeborn (gavinfreeborn@gmail.com)
# @file        : chem.sh
# @created     : Thu 01 Oct 2020 07:09:09 PM
#
# @description : A script that utilizes fzf, groff, and recutils
#                To get information on a element in the periodic table.
######################################################################

fmt="A:box \"\fB{{Symbol}}\fP\" \"{{Name}}\" \"{{AtomicMass}}\" \"{{ElectronConfiguration}}\" wid 3 ht 4
B:box invis  \"{{AtomicNumber}}\" at (A.w.x + 0.5, A.e.y)
C:box \"{{OxidationStates}}\" invis at ((A.e.x - 0.5), (A.n.y - 0.3))"

# Replace with where ever you placed the included chem.rec file
CHEMREC=$HOME/chem.rec

SYMBOL=$(recsel -C "$CHEMREC"  -P "Symbol,Name" | fzf --preview \
  "recsel -e ' ( Symbol = \"{}\" ) || ( Name = \"{}\" ) ' $CHEMREC")

format(){
echo .PS
recsel -e " ( Symbol = '$SYMBOL' ) || ( Name = '$SYMBOL' ) " "$CHEMREC" | recfmt "$fmt"
printf '\n.PE'
}


format | pic -Tascii | nroff | sed -e '/^$/d'
# vim: set tw=78 ts=2 et sw=2 sr:
