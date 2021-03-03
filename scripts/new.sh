slugify () {
    echo "$1" | iconv -t ascii//TRANSLIT | sed -r "s/[^a-zA-Z0-9]+/-/g" | sed -r "s/^-+\|-+$//g" | tr A-Z a-z
}

hugo new $1/$(date +%Y-%m-%d)-$(slugify $2).md
