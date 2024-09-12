FROM apache/spark-py:v3.1.3

USER root

COPY master.sh /

ENV SPARK_MASTER_PORT 7077
ENV SPARK_MASTER_WEBUI_PORT 8080
ENV SPARK_MASTER_LOG /opt/spark/logs

EXPOSE 8080 7077 6066

CMD ["/bin/bash", "/master.sh"]
