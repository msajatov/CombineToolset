CHANNEL=$1
ERA=$2
VAR=$3
ALGO=$4

shift
shift
shift
shift

SEEDS=("$@")

for SEED in "${SEEDS[@]}"; do
    sh run_with_seeds.sh $CHANNEL $ERA $VAR $ALGO $SEED
done