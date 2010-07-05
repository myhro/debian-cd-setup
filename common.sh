# Common handy shell script functions

now () {
    date -u +%F:%H:%M:%S
}

calc_time () {
    echo $1 $2 | awk '
    {
        split($1, start, ":")
        start_time = (3600*start[2]) + (60*start[3]) + start[4]
        split($2, end, ":")
        end_time = (3600*end[2]) + (60*end[3]) + end[4]
        # Cope with going to a new day; do not worry about more than 1 day!
        if (start[1] != end[1]) { end_time += 86400 }
        time_taken = end_time - start_time
        hours = int(time_taken / 3600)
        time_taken -= (hours * 3600)
        minutes = int(time_taken / 60)
        time_taken -= (minutes * 60)
        seconds = time_taken
        printf("%dh%2.2dm%2.2ds\n", hours, minutes, seconds)
    }'
}

build_finished () {
    ARCH="$1"
    BUILDNAME="$2"
    BUILDNAMESTART="${BUILDNAME}START"
    start=${!BUILDNAMESTART}

    . $PUBDIRJIG/$ARCH/$BUILDNAME-trace

    time_spent=`calc_time $start $end`
    echo "$ARCH $BUILDNAME build started at $start, ended at $end (took $time_spent), error $error"
    if [ $error -ne 0 ] ; then
        arch_error="$arch_error "$BUILDNAME"FAIL/$error/$end"
    fi    
}
