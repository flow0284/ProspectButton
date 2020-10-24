#!/bin/bash
function get-translations(){
    curl -H "X-Api-Token: bd16e94f-a16e-4446-a8ee-88ce6a862a4f" -X GET -H \
    "Content-type: application/json" \
    >temp.lua \
    "https://wow.curseforge.com/api/projects/82538/localization/export?lang=$1"

    sed -e '/--.*$/{r temp.lua' -e 'd}' ProspectButton/locales/$1.lua >temp2.lua
    awk '{gsub("\\\\\\\\n", "\\n", $0); print}' temp2.lua >temp.lua
    mv temp.lua ProspectButton/locales/$1.lua
    rm temp2.lua
}
get-translations $1
