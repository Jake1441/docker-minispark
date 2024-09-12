FROM apache/spark-py:v3.1.3

USER root

COPY worker.sh /

RUN ln -s /usr/bin/python3 /usr/local/bin/python
RUN ln -s /usr/bin/python3 /usr/bin/python

ENV SPARK_WORKER_WEBUI_PORT 8081
ENV SPARK_WORKER_LOG /opt/spark/logs
ENV SPARK_MASTER "spark://masternode2:7077"

EXPOSE 8081

CMD ["/bin/bash", "/worker.sh"]
