# Python 3.10 w/ Nvidia Cuda
FROM nvidia/cuda:11.8.0-devel-ubuntu22.04 AS env_base

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
# Install Pre-reqs
RUN apt-get update && apt-get install --no-install-recommends -y \
    git curl unzip vim nano build-essential python3-dev python3-venv python3-pip gcc g++ ffmpeg aria2 software-properties-common python3-tk
RUN add-apt-repository ppa:deadsnakes/ppa
# Setup venv
RUN pip3 install virtualenv
RUN virtualenv /venv
ENV VIRTUAL_ENV=/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip3 install --upgrade pip setuptools

RUN mkdir -p /workspace/ComfyUI
COPY . /workspace/ComfyUI/

# Set working directory to the cloned repo
WORKDIR /workspace/ComfyUI

# Install all requirements
RUN pip3 install -r requirements.txt
RUN pip3 install -r custom_nodes/ComfyUI-Inspire-Pack/requirements.txt
RUN python3 custom_nodes/ComfyUI-Impact-Pack/install.py

CMD ["python", "main.py", "--listen", "--highvram", "--port", "3000"]
