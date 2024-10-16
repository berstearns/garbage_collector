#!/bin/bash
git clone https://github.com/ggerganov/whisper.cpp.git
cd whisper.cpp
sh ./models/download-ggml-model.sh base.en
make
./main -m /home/berstearns/projects/sketchs/garbage_collector/whisper.cpp/models/ggml-base.en.bin -f samples/jfk.wav
ffmpeg -i input.mp3 -ar 16000 -ac 1 -c:a pcm_s16le output.wav

for filename in samples/*.m4a; ./main -oj -l pt -m /home/berstearns/projects/sketchs/garbage_collector/whisper-playground/whisper.cpp/models/ggml-tiny.bin -f ./$filename
