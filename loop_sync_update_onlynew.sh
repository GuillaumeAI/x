declare -r BUTSROOT=$(cd "$(dirname "$0"  &> /dev/null)" && pwd) &> /dev/null

for i in {1...3333}; do  
	$BUTSROOT/sync.sh --onlynew
	sleep 1000
done

