FROM fedora:25

# Install dependencies
RUN dnf update -y && \
    dnf groupinstall -y "Development Tools" && \
    dnf install -y \
    java-1.8.0-openjdk-devel alsa-lib-devel cups-devel \
    freetype-devel libXtst-devel libXt-devel libXrender-devel \
    libXi-devel ccache mercurial \
    file

RUN hg clone http://hg.openjdk.java.net/jdk9/jdk9 jdk9
RUN dnf install -y \
    gcc-c++
WORKDIR jdk9

# Split to cache
RUN hg clone http://hg.openjdk.java.net/jdk9/jdk9/corba corba
RUN hg clone http://hg.openjdk.java.net/jdk9/jdk9/jaxp jaxp
RUN hg clone http://hg.openjdk.java.net/jdk9/jdk9/jaxws jaxws
RUN hg clone http://hg.openjdk.java.net/jdk9/jdk9/langtools langtools
RUN hg clone http://hg.openjdk.java.net/jdk9/jdk9/hotspot hotspot
RUN hg clone http://hg.openjdk.java.net/jdk9/jdk9/nashorn nashorn
RUN hg clone http://hg.openjdk.java.net/jdk9/jdk9/jdk jdk
RUN bash get_source.sh
RUN bash configure CC=/usr/bin/gcc CXX=/usr/bin/g++ \
    --disable-warnings-as-errors
RUN make
