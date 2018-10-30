source scripts/config.sh

# process args
outputprefix=$1

if [[ "$outputprefix" == "UD_"* ]]; then
    outputprefix=""
else
    shift
fi

treebank=$1
shift
task=$1
shift
dataset=$1
shift
gpu=$1
shift 

# set up data
short=`bash scripts/treebank_to_shorthand.sh ud $treebank`
lang=`echo $short | sed -e 's#_.*##g'`
args=$@

DATADIR=data/${task}

eval_file=${DATADIR}/${short}.${dataset}.in.conllu
output_file=${DATADIR}/${short}.${dataset}.${outputprefix}pred.conllu
gold_file=${DATADIR}/${short}.${dataset}.gold.conllu

# ensure input and gold data are present
if [ ! -e $eval_file ]; then
    cp $UDBASE/$treebank/${short}-ud-${dataset}.conllu $eval_file
fi

if [ ! -e $gold_file ]; then
    cp $UDBASE/$treebank/${short}-ud-${dataset}.conllu $gold_file
fi

# run model
if [ $task == depparse ]; then
    module="parser"
fi

declare -A task2module=( ["depparse"]="parser" ["pos"]="tagger" ["tokenize"]="tokenizer")
module=${task2module[$task]}

CUDA_VISIBLE_DEVICES=$gpu python -m models.${module} --eval_file $eval_file \
    --output_file $output_file --gold_file $gold_file --lang $lang --shorthand $short --mode predict --save_dir ${outputprefix}saved_models/${task} $args

results=`python utils/conll18_ud_eval.py -v $gold_file $output_file | head -12 | tail -n+12 | awk '{print $7}'`

# display results
echo $short $results $args
