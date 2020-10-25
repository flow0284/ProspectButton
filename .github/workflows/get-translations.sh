#!/bin/bash
function get-translations(){
    curl -H "X-Api-Token: b2cfa2bf-64fd-4a56-976e-4895ddad3955" -X GET -H \
    "Content-type: application/json" \
    >temp.lua \
    "https://wow.curseforge.com/api/projects/82538/localization/export?lang=$1"

    sed -e '/--.*$/{r temp.lua' -e 'd}' ProspectButton/locales/$1.lua >temp2.lua
    awk '{gsub("\\\\\\\\n", "\\n", $0); print}' temp2.lua >temp.lua
    mv temp.lua ProspectButton/locales/$1.lua
    rm temp2.lua
}
get-translations $1
