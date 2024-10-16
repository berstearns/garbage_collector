# ffmpeg -i ./samples/peter-attia-daily-habits-to-reduce-stress-anxiety-depression-for-longevity/Peter\ Attia\'s\ DAILY\ HABITS\ To\ Reduce\ Stress,\ Anxiety\ \&\ Depression\ For\ LONGEVITY.mp3 -ar 16000 -ac 1 -c:a pcm_s16le ./samples/peter-attia-daily-habits-to-reduce-stress-anxiety-depression-for-longevity/Peter\ Attia\'s\ DAILY\ HABITS\ To\ Reduce\ Stress,\ Anxiety\ \&\ Depression\ For\ LONGEVITY.mp3.wav
# for filename in ./samples/onepiece/*.wav; $ ffmpeg -i somefile.mp3 -f segment -segment_time 3 -c copy out%03d.mp3 
lang=en
for filename in ./samples/peter-attia-daily-habits-to-reduce-stress-anxiety-depression-for-longevity/*.wav;
do
    echo $filename
    ./main -oj -l $lang -m /home/berstearns/projects/sketchs/garbage_collector/whisper-playground/whisper.cpp/models/ggml-tiny.bin -f $filename
done
