FROM croscon/ubuntu:trusty

RUN apt-get -y update && apt-get -y upgrade

# start of ffmpeg block
RUN mkdir /build \
    && cd /build \
    && git clone git://source.ffmpeg.org/ffmpeg.git \
    && cd /build/ffmpeg \
    && git checkout release/3.0 \
    && apt-get install -y yasm libfaac-dev libfdk-aac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libvpx-dev libx264-dev libxvidcore-dev libfreetype6-dev libjpeg-dev gfortran build-essential \
    && ./configure --prefix=/opt/ffmpeg --enable-static --enable-pthreads --enable-gpl --enable-version3 --enable-nonfree --enable-hardcoded-tables --enable-libfreetype --enable-avresample --enable-vda --enable-libx264 --enable-libfaac --enable-libmp3lame --enable-libxvid --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libfdk-aac \
    && make -j `cat /proc/cpuinfo | grep processor | wc -l` \
    && make install \
    && cd / \
    && rm -rf /build \
    && apt-get remove -y --purge yasm libfaac-dev libfdk-aac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libvpx-dev libx264-dev libxvidcore-dev libfreetype6-dev libjpeg-dev libjpeg-turbo8-dev libjpeg8-dev libogg-dev libpng12-dev pkg-config build-essential zlib1g-dev g++ g++-4.8 libstdc++-4.8-dev \
    && apt-get install -y libfaac0 libfdk-aac0 libmp3lame0 libopencore-amrnb0 libopencore-amrwb0 libtheora0 libvorbis0a libvpx1 libx264-142 libxvidcore4 libfreetype6 libjpeg8
# end of ffmpeg block

# gpac
RUN apt-get install -y make pkg-config g++ zlib1g-dev libfreetype6-dev libjpeg62-dev libpng12-dev libopenjpeg-dev libmad0-dev libfaad-dev libogg-dev libvorbis-dev libtheora-dev liba52-0.7.4-dev libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libavresample-dev libxv-dev x11proto-video-dev libgl1-mesa-dev x11proto-gl-dev linux-sound-base libxvidcore-dev libssl-dev libjack-dev libasound2-dev libpulse-dev libsdl1.2-dev dvb-apps libavcodec-extra libavdevice-dev libmozjs185-dev
RUN cd /tmp && git clone https://github.com/gpac/gpac.git && cd gpac && git checkout v0.6.1 \
    && ./configure --prefix=/opt/gpac && make -j `cat /proc/cpuinfo | grep processor | wc -l` && make install \
    && echo "/opt/gpac/lib" > /etc/ld.so.conf.d/gpac.conf && ldconfig && cd / && rm -rf /tmp/gpac*

