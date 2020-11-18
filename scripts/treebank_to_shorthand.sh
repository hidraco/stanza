#!/bin/bash
#
# Convert a UD Treebank full name to its short code (e.g. UD_English-EWT to en_ewt). Run as:
#   ./treebank_to_shorthand.sh FORMAT TREEBANK
# where FORMAT is either ud or udpipe, and TREEBANK is the full name.

# Please keep synced with
#   stanza/models/common/constant.py

declare -A lang2lcode=( ["Afrikaans"]="af" ["Armenian"]="hy" ["Arabic"]="ar" ["Breton"]="br" ["Bulgarian"]="bg" ["Buryat"]="bxr" ["Catalan"]="ca" ["Czech"]="cs" ["Old_Church_Slavonic"]="cu" ["Danish"]="da" ["German"]="de" ["Greek"]="el" ["English"]="en" ["Spanish"]="es" ["Estonian"]="et" ["Basque"]="eu" ["Persian"]="fa" ["Faroese"]="fo" ["Finnish"]="fi" ["French"]="fr" ["Irish"]="ga" ["Galician"]="gl" ["Gothic"]="got" ["Ancient_Greek"]="grc" ["Hebrew"]="he" ["Hindi"]="hi" ["Hindi_English"]="qhe" ["Croatian"]="hr"
["Hungarian"]="hu" ["Icelandic"]="is" ["Indonesian"]="id" ["Italian"]="it" ["Japanese"]="ja" ["Kazakh"]="kk" ["Korean"]="ko" ["Kurmanji"]="kmr" ["Latin"]="la" ["Latvian"]="lv" ["Dutch"]="nl" ["Norwegian_Bokmaal"]="nb" ["Norwegian_Nynorsk"]="nn" ["Polish"]="pl" ["Portuguese"]="pt" ["Romanian"]="ro" ["Russian"]="ru" ["Sanskrit"]="sa" ["Slovak"]="sk" ["Slovenian"]="sl" ["Swedish"]="sv" ["Turkish"]="tr" ["Turkish_German"]="qtd" ["Uyghur"]="ug" ["Ukrainian"]="uk" ["Urdu"]="ur" ["Vietnamese"]="vi" ["Traditional_Chinese"]="zh-hant" ["Welsh"]="cy" ["Altaic"]="bxr" ["Indo_Iranian"]="kmr" ["Uralic"]="sme" ["Slavic"]="hsb"
["Naija"]="pcm" ["North_Sami"]="sme" ["Old_French"]="fro" ["Serbian"]="sr" ["Thai"]="th" ["Upper_Sorbian"]="hsb" ["Belarusian"]="be" ["Classical_Chinese"]="lzh" ["Coptic"]="cop" ["Lithuanian"]="lt" ["Livvi"]="olo" ["Maltese"]="mt" ["Marathi"]="mr" ["Old_Russian"]="orv" ["Scottish_Gaelic"]="gd" ["Simplified_Chinese"]="zh-hans" ["Swedish_Sign_Language"]="swl" ["Tamil"]="ta" ["Telugu"]="te" ["Wolof"]="wo")

format=$1
shift
treebank=$1
tbname=`echo $treebank | sed -e 's#^.*-##g' | tr [:upper:] [:lower:]`
lang=`echo $treebank | sed -e 's#-.*$##g' -e 's#^[^_]*_##g'`
lcode=${lang2lcode[$lang]}
if [ -z "$lcode" ]; then
    if [ $lang == "Chinese" ]; then
        if [ $tbname == "gsdsimp" ]; then
            # TODO why not zh-hans?
            lcode=zh
        elif [ $tbname == "gsd" -o $tbname == "hk" -o $tbname == "cfl" -o $tbname == "pud" ]; then
            lcode=zh-hant
        fi
    elif [ $lang == "Norwegian" ]; then
        if [ $tbname == "bokmaal" ]; then
            lcode=nb
        elif [ $tbname == "nynorsk" -o $tbname == "nynorsklia" ]; then
            lcode=nn
        fi
    fi
fi
if [ $format == 'udpipe' ]; then
    echo `echo $lang | tr [:upper:] [:lower:]`-${tbname}
else
    echo ${lcode}_${tbname}
fi
