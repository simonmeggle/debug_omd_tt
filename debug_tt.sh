
NOTIFY_SCRIPT=$OMD_ROOT/lib/nagios/plugins/notify-by-email.pl
CWD=$(dirname `readlink -f $0`)
ENVFILE=$CWD/debug_tt.rc

main() {
    while getopts "hdtme:f:s:" opt; do
      case $opt in
        h)
          usage
          ;;
        d)
          DEBUG="-d"   
          ;;
        e) 
          ENVFILE=$OPTARG
          ;;
        f)
          TEMPLATE=$OPTARG
          ;; 
        t)
          MODE=tpage
          VARSEP="--define"
          ;;
        m)
          MODE=mail
          VARSEP="-o"
          ;;
        s)
          NOTIFY_SCRIPT=$OPTARG
          ;;
        *) 
          echo "Unknown parameter."
          exit 1
          ;;
      esac
    done

    [ -z $TEMPLATE ] && usage
    [ -r $TEMPLATE ] || { echo "ERROR: $TEMPLATE not found."; exit 1; }
    [ -r $ENVFILE ] || { echo "ERROR: $ENVFILE not found."; exit 1; }
    [ -x $NOTIFY_SCRIPT ] || { echo "ERROR: $NOTIFY_SCRIPT not found/executable."; exit 1; }

    . $ENVFILE

    VARS=$(egrep -v '^(#|$)'  $ENVFILE | awk -F'[[:space:]=]' '{print $2}')

    OPTSTRING=""

    for v in $VARS; do 
        OPTSTRING="$OPTSTRING $VARSEP ${v}='"$(eval echo "${!v}")"'"
    done

    if [[ $MODE == "mail" ]]; then 
        CMD="perl $DEBUG $NOTIFY_SCRIPT --template=$TEMPLATE --mail=/usr/sbin/sendmail -o BASEURL='http://$(hostname -f)' $OPTSTRING"
        eval $CMD
    elif [[ $MODE == "tpage" ]]; then 
        CMD="tpage --eval_perl --define BASEURL='http://$(hostname -f)/$USER3/' $OPTSTRING $TEMPLATE"
        eval $CMD
    else
        echo "ERROR: mode parameter (-t/-m) is missing."
        exit 1
    fi

}


usage(){
    echo "$0 - script for testing template toolkit" 
    echo "Usage: $0 -t|-m -f TEMPLATE [-s SCRIPT] [-d]"
    cat <<"EOF"
-t|-m   process (t)emplate / send (m)ail
-f      template file 
-s      notify-by-email script
-d      start tpage/notification script in debug mode
EOF
    exit 1
}

main $@
