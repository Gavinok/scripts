#!/bin/bash


while [ true ]; do
    rhs=$(statwe -l -x)
    lhs=$(herbstclient tag_status)
    final="$lhs$rhs"
    echo $final
    sleep 1
done

