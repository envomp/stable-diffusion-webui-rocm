FROM ubuntu:jammy
SHELL ["/bin/bash", "-c"]  
ENV PORT=7820 \
    EXTRA_ARGS='' \
    DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    REQS_FILE='requirements.txt' 

WORKDIR /opt
RUN apt-get -y update && \
	apt-get install -y --no-install-recommends libstdc++-12-dev ca-certificates wget git libglib2.0-0 apt-utils python3.10-venv python3-pip && \
	wget https://repo.radeon.com/amdgpu-install/5.4.2/ubuntu/jammy/amdgpu-install_5.4.50402-1_all.deb && \
	apt-get install -y ./amdgpu-install_5.4.50402-1_all.deb && \
	amdgpu-install -y --usecase=rocm --no-dkms && \
	git clone https://github.com/hydrian/stable-diffusion-webui /sd

WORKDIR /sd
RUN 	apt-get autoremove -y && \
	apt-get clean -y && \
	rm -rf /var/lib/apt/lists/* && \
	python3 -m venv venv && \
	source venv/bin/activate && \
	ln -s /usr/bin/python3 /usr/bin/python && \
	python3 -m pip install --upgrade pip wheel
	#echo "Downloading SDv1.4 Model File.." && \
  #wget --progress=bar -O /sd/models/Stable-diffusion/sd-v1.4.ckpt https://huggingface.co/CompVis/stable-diffusion-v-1-4-original/resolve/main/sd-v1-4.ckpt 
  


 
EXPOSE ${PORT}

VOLUME [ "/sd/models", "/sd/outputs","/sd/extensions", "/sd/plugins"]
ENTRYPOINT python -d launch.py --precision full --no-half

	
	
	
	
	
	


