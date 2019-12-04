#!/usr/bin/env bash

##### emoji section #####
checkmark=$'\xE2\x9C\x85'
rocket=$'\xF0\x9F\x9A\x80'
weary_cat_face=$'\xF0\x9F\x99\x80'
police_red_light=$'\xF0\x9F\x9A\xA8'
############


base_folder='env'
files='prod.env staging.env'

check_if_file_exists () {
    [[ -f $1 ]] || ( print_error "File missing. Please add file $1!" && return 1)
}

check_if_file_is_empty () {
    [[ -s $1 ]] || ( print_error "File $1 is empty!" && return 1)
}

check_if_folder_exists () {
   [[ -d $1 ]] || ( print_error "Folder $1 does not exist!" && return 1)
}

print_error() {
    error_msg_prefix="$weary_cat_face ERROR:"
    printf $police_red_light'%.0s' {1..3}
    echo "$error_msg_prefix $1"
}


check_if_folder_exists $base_folder || exit 1

for file in $files; do
    check_if_file_exists $base_folder/$file || exit 1
    check_if_file_is_empty $base_folder/$file || exit 1
done

echo " $checkmark ... Environment for local walter-platform is perfectly fine. Happy testing...$rocket"

