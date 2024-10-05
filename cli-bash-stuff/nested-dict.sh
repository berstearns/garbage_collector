declare -A infra=( ["LOCAL_DATASET"]=true ["LOCAL_MODEL"]=true ["BATCH"]="FULL" )
declare -A data=( ["age"]="21" ["weight"]="140" )
declare -A code=( ["age"]="21" ["weight"]="140" )
declare -a dict=("infra" "data" "code")

for member in "${dict[@]}"; do
    echo "$member :"
    declare -n p="$member"  # now p is a reference to a variable "$member"
    for attr in "${!p[@]}"; do
        echo "    $attr : ${p[$attr]}"
    done
done
