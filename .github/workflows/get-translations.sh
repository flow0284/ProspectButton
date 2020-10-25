#!/bin/bash
function get-translations(){
    curl -H "X-Api-Token: 7a82fbfa-af55-4ec0-ba66-7d9a772fa51b" -X GET -H \
    "Content-type: application/json" \
    >temp.lua \
    "https://wow.curseforge.com/api/projects/82538/localization/export?lang=$1"

    sed -e '/--.*$/{r temp.lua' -e 'd}' ProspectButton/locales/$1.lua >temp2.lua
    awk '{gsub("\\\\\\\\n", "\\n", $0); print}' temp2.lua >temp.lua
    mv temp.lua ProspectButton/locales/$1.lua
    rm temp2.lua
}
get-translations $1
