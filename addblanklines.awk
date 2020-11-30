#!/usr/bin/awk -f

BEGIN {
    type = "^layout: post"
    junk = "^[0-9]+|---|^x"
}

# insert a blank line before each record
$0 ~  type { print "\n" $0 }

# throw away page numbers and unnecessary strings
$0 !~ type && $0 !~ junk { print $0 }

# be sure to end the file with a blank line
END { print "\n" }
