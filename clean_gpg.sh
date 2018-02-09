#!/bin/bash
echo -n "Expired Keys: "
for expiredKey in $(gpg --list-keys | awk '/^pub.* \[expired\: / {id=$2; sub(/^.*\//, "", id); print id}' | fmt -w 999 ); do
    echo -n "$expiredKey"
    fingerprint=gpg --fingerprint $expiredkey |grep fingerprint |awk -F= '{print $2}'|sed 's/ //g'
    gpg --batch --delete-secret-and-public-key $fingerprint >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -n "(OK), "
    else
        echo -n "(FAIL), "
    fi
done
echo done.

echo -n "Update Keys: "
for keyid in $(gpg -k | grep ^pub | grep -v expired: | grep -v revoked: | cut -d/ -f2 | cut -d' ' -f1); do
    echo -n "$keyid"
    gpg2 --batch --quiet --edit-key $keyid check clean cross-certify save quit 
    if [ $? -eq 0 ]; then
        echo -n "(OK), "
    else
        echo -n "(FAIL), "
    fi
done
echo done.
