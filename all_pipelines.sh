dataset=$1
subject=$2
root=$3

python init_connectome_tract.py $dataset $subject $root &
python init_preprocessing.py $dataset $subject $root &
python init_recon_models.py $dataset $subject $root &
python init_tracking_csddet_trk.py $dataset $subject $root &
python init_tracking_csdprob_trk.py $dataset $subject $root &
python init_tracking_dtidet_trk.py $dataset $subject $root &
wait
python init_tracking_csddet_tck.py $dataset $subject $root &
python init_tracking_csdprob_tck.py $dataset $subject $root &
python init_tracking_dtidet_tck.py $dataset $subject $root &

wait
