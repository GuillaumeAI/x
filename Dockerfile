FROM docker.io/guillaumeai/server:ast-210420
#FROM guillaumeai/server:ast-2103220014
ARG MODEL_TO_COPY
#ast-210420
#FROM guillaumeai/ast:gpu-cpu-limitation-210421
#@STCGoal An API server container on dockerhub that you pull and can start with a model included in it.

WORKDIR /data/styleCheckpoint/$MODEL_TO_COPY
COPY build/models/$MODEL_TO_COPY .



WORKDIR /a/bin
COPY build/bin .
COPY _env.sh .
COPY decrypt-model.sh .
RUN chmod +x *sh

WORKDIR /root
COPY bashrc /root/.bashrc

WORKDIR /gia
#COPY build-docker.sh .
#COPY run-docker-test.sh .
COPY _env.sh .
#COPY Dockerfile .
#COPY list_to_dockerize.txt .
#COPY batch-build-to-dockerize.sh .
#COPY all_dockerized_model_list.txt .
#COPY build-crypted-docker.sh .
RUN chmod +x *sh


#ENTRYPOINT []

WORKDIR /model
COPY run-decrypted-server.sh .
#RUN dos2unix *sh
RUN chmod +x *sh

ENTRYPOINT []
# CMD python server.py 
CMD bash /model/run-decrypted-server.sh server.py 