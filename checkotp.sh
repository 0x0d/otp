#!/bin/bash

PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

# ensure aliases are expanded by bash
shopt -s expand_aliases

if [ -e "`which md5 2>/dev/null`" ]
then
	alias checksum=md5
	have_md5="true"
fi
if [ -e "`which md5sum 2>/dev/null`" ]
then
	alias checksum=md5sum
	have_md5="true"
fi

if [ $have_md5 != "true" ]
then
	echo "No md5 or md5sum available on server!"
	exit 6
fi

function chop
{
	num=`echo -n "$1" | wc -c | sed 's/ //g' `
	nummin1=`expr $num "-" 1`
	echo -n "$1" | cut -b 1-$nummin1 
}

function checkotp
{
    OTP=`echo -n "$1" | sed 's/[^0-9a-f]/0/g' `
    SECRET=`echo -n "$2" | sed 's/[^0-9a-f]/0/g' `
    PIN=`echo -n "$3" | sed 's/[^0-9]/0/g' `

    EPOCHTIME=`date +%s` ; EPOCHTIME=`chop $EPOCHTIME`

    I=0
    EPOCHTIME=`expr $EPOCHTIME - 18`
    EPOCHTIME=`expr $EPOCHTIME`
    while [ $I -lt 36 ] ; do # 3 minutes before and after
        OTP=`printf $EPOCHTIME$SECRET$PIN|checksum|cut -b 1-6`
        if [ "$OTP" = "$PASSWD" ] ; then
            echo "ACCEPT"
            exit 0
        fi
        I=`expr $I + 1`
        EPOCHTIME=`expr $EPOCHTIME + 1`
    done

    echo "FAIL"
}
