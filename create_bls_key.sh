#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -c count -s shard"
   echo -e "\t-c The number of BLS to be generated"
   echo -e "\t-b The Shard number of the keys that will be generated"
   exit 1 # Exit script after printing help
}

# Count, Shard

while getopts "c:s:" opt
do
   case "$opt" in
      c ) count="$OPTARG" ;;
      s ) shard="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [[ -z "$count" ]] || [[ -z "$shard" ]]
then
   echo "Missing required parameters";
   helpFunction
fi

# Validate Shard Param
shardRE='^[0-3]$'
if ! [[ $shard =~ $shardRE ]] ; then
   echo "error: Shard Parameter must be a number between 0 and 3" >&2
   exit 1
fi

# Validate Count Param
countRE='^[0-9]+$'
if ! [[ $count =~ $countRE ]] ; then
   echo "error: Count Parameter must be a number greater than 0" >&2
   exit 1
fi

./hmy keys generate-bls-keys --count $count --shard $shard --passphrase
generatedkeys=`ls *.key`
for keyfile in $generatedkeys
do
    createPasswordFile()
    {
        keyfile="$1"
        read -s -p "Enter the password for $keyfile: " x
        echo ""
        read -s -p "Confirm password for $keyfile: " y

        if [ "$x" = "$y" ]
        then
            echo ""
            echo "passwords match"
            pubkey=`basename "$keyfile" .key`
            echo ""
            echo "$x" > "$pubkey".pass
        else
            echo ""
            echo "Passwords do not match. Please try again."
            createPasswordFile keyfile
        fi
    }
    
    createPasswordFile $keyfile
done

echo "BLS Keys Created:"
for keyfile in $generatedkeys
do
    echo "$keyfile"
done

echo ""
echo "Moving .key and .pass files to ./hmy/blskeys"
mv *.key .hmy/blskeys
mv *.pass .hmy/blskeys

echo ""
echo "Done!"

exit 0