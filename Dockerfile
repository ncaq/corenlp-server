FROM openjdk:8
# UTF-8を有効化, apt-getの対話プロンプトを無効化
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y ant && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN wget https://github.com/stanfordnlp/CoreNLP/archive/v4.0.0.tar.gz && tar -xf v4.0.0.tar.gz && rm v4.0.0.tar.gz
WORKDIR CoreNLP-4.0.0
RUN wget http://nlp.stanford.edu/software/stanford-corenlp-models-current.jar \
  && mv stanford-corenlp-models-current.jar lib
RUN wget http://nlp.stanford.edu/software/stanford-english-corenlp-models-current.jar \
  && mv stanford-english-corenlp-models-current.jar lib
RUN wget http://nlp.stanford.edu/software/stanford-english-kbp-corenlp-models-current.jar \
  && mv stanford-english-kbp-corenlp-models-current.jar lib
# メモリ指定を削除
RUN sed -i /-Xmx/d build.xml
RUN ant
EXPOSE 9000
ENTRYPOINT ant run -Drun.class=edu.stanford.nlp.pipeline.StanfordCoreNLPServer
