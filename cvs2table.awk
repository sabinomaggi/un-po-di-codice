#!/usr/bin/awk -f

function print_multiple_items(item_name, next_item) {
    line = ""
    EXIT = 0

    printf "    \\item[" item_name "] "
    while ( EXIT == 0 ) {
        getline
        if ($0 !~ next_item) {
            # build line to be printed
            line = line $0 ", "
        } else {
            # remove extra characters
            gsub(/-[ ]?/, "", line)
            # remove consecutive or trailing commas
            gsub(/(,[ ]+){2,}/, ", ", line)
            gsub(/,[ ]+$/, "", line)
            # print full line
            printf line
            EXIT = 1
        }
    }
    printf "\n"
}


BEGIN {
    FS = " "
    OFS = " "
    IGNORECASE = 0

    target = "layout: post"
    
    # print table header
    print "\\documentclass[11pt,oneside,a4paper]{report}"
    print "\\usepackage{framed}"
    print
    print "\\begin{document}"
    print
    print "\\section*{Ultimi post su Melabit}"
    print
}


# locate posts and extract relevant data
$0 ~ target {
    TEXT = "FALSE"

    print "\\begin{framed}"
    print "\\begin{description}"

    print "    \\item[Tipo:] " substr($0, index($0, $2))
    do {
        getline

        if ( $0 ~ /^title:/ )   { print "    \\item[Titolo:] "    substr($0, index($0, $2)) }
        if ( $0 ~ /^author:/ )  { print "    \\item[Autore:] "    substr($0, index($0, $2)) }
        if ( $0 ~ /^date:/ )    { print "    \\item[Data:] "      substr($0, index($0, $2)) }

        if ( $0 ~ /^categories:/ )  { print_multiple_items("Categorie:", "tags:") }
        if ( $0 ~ /^tags:/ )        { print_multiple_items("Tag:", "comments:") }

        if ( $0 ~ /^comments:/ ){ print "    \\item[Commenti:] "   substr($0, index($0, $2)) }

        if ( $0 ~ /^published:/ ) { 
            print "    \\item[Pubblicato:] " substr($0, index($0, $2))
            print "    \\item[Testo iniziale del post:] " 
            TEXT = "TRUE"
        } else if (TEXT == "TRUE" && $0 != "") { 
            gsub("[_^$]", "", $0)     # strip away all characters that trouble LaTeX
            print "    " $0
        }
    } while ($0 != "")

    print "\\end{description}"
    print "\\end{framed}"
    print
}


END {
    print "\\end{document}"
}
