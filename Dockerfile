FROM ubuntu:16.04

ENV FLASK_APP text-detect.py
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV TESSDATA_PREFIX /usr/local/share/tessdata
ENV LD_LIBRARY_PATH /usr/local/lib:/usr/lib:/lib:/lib64

ADD pkg/*.deb /pkg/

RUN apt-get update && \
    apt-get install -y wget \
                       python3 \
                       python3-pip \
                       libglib3.0 \
                       libpng12-dev \
                       libjpeg8-dev \
                       libtiff5-dev \
                       zlib1g-dev \
                       gdebi-core && \
    gdebi -n /pkg/libjpeg62-turbo_*.deb && \
    gdebi -n /pkg/libwebp6_*.deb && \
    gdebi -n /pkg/libgif7_*.deb && \
    gdebi -n /pkg/liblept5_*.deb && \
    gdebi -n /pkg/libleptonica-dev_*.deb && \
    gdebi -n /pkg/leptonica-latest_*.deb && \
    gdebi -n /pkg/tesseract-latest_*.deb && \
    pip3 install opencv-python opencv-contrib-python flask && \
    # osd: Orientation and script detection
    # equ: Math / Equation detection
    # eng: English
    # other languages: https://github.com/tesseract-ocr/tesseract/wiki/Data-Files
    wget -O ${TESSDATA_PREFIX}/osd.traineddata https://github.com/tesseract-ocr/tessdata/raw/master/osd.traineddata && \
    wget -O ${TESSDATA_PREFIX}/equ.traineddata https://github.com/tesseract-ocr/tessdata/raw/master/equ.traineddata && \
    wget -O ${TESSDATA_PREFIX}/eng.traineddata https://github.com/tesseract-ocr/tessdata/raw/master/eng.traineddata

ADD *.py /src/
ADD text_detect /src/text_detect/
ADD static /src/static/

WORKDIR /src
CMD flask run --host=0.0.0.0
