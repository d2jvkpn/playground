#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

function download_efilm() {
    sid=$1
    sdir=$(printf "data/efilm-%02d" $sid)
    prefix=http://www.childrenfun.com.cn/download/disney/english/efilm/src/$sid
    
    mkdir -p $sdir

    [ -s $sdir/00_banner.jpg ] || wget -O $sdir/00_banner.jpg $prefix/images/banner.jpg
    [ -s $sdir/01_story.jpg ] || wget -O $sdir/01_story.jpg $prefix/images/01.jpg
    [ -s $sdir/02_storyslow.jpg ] || wget -O $sdir/02_storyslow.jpg $prefix/images/02.jpg
    [ -s $sdir/03_words.jpg ] || wget -O $sdir/03_words.jpg $prefix/images/03.jpg
    [ -s $sdir/04_wordslow.jpg ] || wget -O $sdir/04_wordslow.jpg $prefix/images/04.jpg

    [ -s $sdir/01_story.mp3 ] || wget -O $sdir/01_story.mp3 $prefix/mp3/story.mp3
    [ -s $sdir/02_storyslow.mp3 ] || wget -O $sdir/02_storyslow.mp3 $prefix/mp3/storyslow.mp3
    [ -s $sdir/03_words.mp3 ] || wget -O $sdir/03_words.mp3 $prefix/mp3/words.mp3
    [ -s $sdir/04_wordslow.mp3 ] || wget -O $sdir/04_wordslow.mp3 $prefix/mp3/wordslow.mp3
}

for i in {1..24}; do
    download_efilm $i
done

exit
#### html
http://www.childrenfun.com.cn/download/disney/english/efilm/?lid=6

<img id="album-icon" class="album-icon" src="src/6/images/banner.jpg">
<img class="story-icon lazy-load" data-img-size-type="2" src="src/6/images/01.jpg">
<img class="story-icon lazy-load" data-img-size-type="2" src="src/6/images/02.jpg">
<img class="story-icon lazy-load" data-img-size-type="2" src="src/6/images/03.jpg">
<img class="story-icon lazy-load" data-img-size-type="2" src="src/6/images/04.jpg">


<audio id="audio_player" type="audio/mpeg" src="http://cdndigital.childrenfun.com.cn/download/disney/english/efilm/src/6/mp3/story.mp3"></audio>

<audio id="audio_player" type="audio/mpeg" src="http://cdndigital.childrenfun.com.cn/download/disney/english/efilm/src/6/mp3/storyslow.mp3"></audio>

<audio id="audio_player" type="audio/mpeg" src="http://cdndigital.childrenfun.com.cn/download/disney/english/efilm/src/6/mp3/words.mp3"></audio>

<audio id="audio_player" type="audio/mpeg" src="http://cdndigital.childrenfun.com.cn/download/disney/english/efilm/src/6/mp3/wordslow.mp3"></audio>

#### can't get title
wget --quiet -O - "http://www.childrenfun.com.cn/download/disney/english/efilm/?lid=6" \
  | paste -s -d " " \
  | sed -e 's!.*<head>\(.*\)</head>.*!\1!' -e 's!.*<title>\(.*\)</title>.*!\1!'
