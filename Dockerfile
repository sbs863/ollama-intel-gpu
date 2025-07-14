FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=america/los_angeles


# Base packages
RUN apt update && \
    apt install --no-install-recommends -q -y \
    software-properties-common \
    ca-certificates \
    wget \
    ocl-icd-libopencl1

# Intel GPU compute user-space drivers
RUN mkdir -p /tmp/gpu && \
 cd /tmp/gpu && \
 wget https://github.com/oneapi-src/level-zero/releases/download/v1.21.9/level-zero_1.21.9+u24.04_amd64.deb && \
 wget https://github.com/intel/intel-graphics-compiler/releases/download/v2.12.5/intel-igc-core-2_2.12.5+19302_amd64.deb && \
 wget https://github.com/intel/intel-graphics-compiler/releases/download/v2.12.5/intel-igc-opencl-2_2.12.5+19302_amd64.deb && \
 wget https://github.com/intel/compute-runtime/releases/download/25.22.33944.8/intel-ocloc_25.22.33944.8-0_amd64.deb && \
 wget https://github.com/intel/compute-runtime/releases/download/25.22.33944.8/intel-opencl-icd_25.22.33944.8-0_amd64.deb && \
 wget https://github.com/intel/compute-runtime/releases/download/25.22.33944.8/libigdgmm12_22.7.0_amd64.deb && \
 wget https://github.com/intel/compute-runtime/releases/download/25.22.33944.8/libze-intel-gpu1_25.22.33944.8-0_amd64.deb && \
 dpkg -i *.deb && \
 rm *.deb

# Install Ollama Portable Zip https://github.com/ipex-llm/ipex-llm/releases/download/v2.3.0-nightly/ollama-ipex-llm-2.3.0b20250710-ubuntu.tgz
ARG IPEXLLM_PORTABLE_ZIP_FILENAME=ollama-ipex-llm-2.3.0b20250710-ubuntu.tgz
RUN cd / && \
  wget https://github.com/ipex-llm/ipex-llm/releases/download/v2.3.0-nightly/${IPEXLLM_PORTABLE_ZIP_FILENAME} && \
  tar xvf ${IPEXLLM_PORTABLE_ZIP_FILENAME} --strip-components=1 -C /

ENV OLLAMA_HOST=0.0.0.0:11434

ENTRYPOINT ["/bin/bash", "/start-ollama.sh"]