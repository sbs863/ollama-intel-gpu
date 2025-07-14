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
 wget https://github.com/oneapi-src/level-zero/releases/download/v1.20.2/level-zero_1.20.2+u24.04_amd64.deb && \ 
 wget https://github.com/intel/intel-graphics-compiler/releases/download/v2.8.3/intel-igc-core-2_2.8.3+18762_amd64.deb && \
 wget https://github.com/intel/intel-graphics-compiler/releases/download/v2.8.3/intel-igc-opencl-2_2.8.3+18762_amd64.deb && \
 wget https://github.com/intel/compute-runtime/releases/download/25.09.32961.7/intel-level-zero-gpu_1.6.32961.7_amd64.deb && \
 wget https://github.com/intel/compute-runtime/releases/download/25.09.32961.7/intel-opencl-icd_25.09.32961.7_amd64.deb && \
 wget https://github.com/intel/compute-runtime/releases/download/25.09.32961.7/libigdgmm12_22.6.0_amd64.deb && \
 dpkg -i *.deb && \
 rm *.deb

# Install Ollama Portable Zip https://github.com/ipex-llm/ipex-llm/releases/download/v2.3.0-nightly/ollama-ipex-llm-2.3.0b20250710-ubuntu.tgz
ARG IPEXLLM_PORTABLE_ZIP_FILENAME=ollama-ipex-llm-2.3.0b20250415-ubuntu.tgz
RUN cd / && \
  wget https://github.com/intel/ipex-llm/releases/download/v2.3.0-nightly/${IPEXLLM_PORTABLE_ZIP_FILENAME} && \
  tar xvf ${IPEXLLM_PORTABLE_ZIP_FILENAME} --strip-components=1 -C /

ENV OLLAMA_HOST=0.0.0.0:11434

ENTRYPOINT ["/bin/bash", "/start-ollama.sh"]
