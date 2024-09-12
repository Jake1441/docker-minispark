# Use the Python image as the base
FROM python:3.9 AS python-base

# Environment variables and timezone setup
ENV TZ=Pacific/Auckland
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/


RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install necessary packages for both Python and Hadoop
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      net-tools \
      curl \
      netcat-openbsd \
      gnupg \
      libsnappy-dev \
    && rm -rf /var/lib/apt/lists/*

# Install JupyterLab and PySpark
RUN pip install jupyterlab pyspark==3.1.2 pandas findspark

# Create a Jupyter configuration directory and generate the config
RUN jupyter lab --generate-config
RUN echo "c.NotebookApp.password = 'argon2:\$argon2id\$v=19\$m=10240,t=10,p=8\$z9ag/EyXSqNnEMimrvQa9g\$KKZ0o7o/ky4/58CQNlrY51ZWVFjwhZqnMaREdvdHmKU'" >> ~/.jupyter/jupyter_lab_config.py
RUN echo "c.NotebookApp.iopub_data_rate_limit = 1.0e10" >> ~/.jupyter/jupyter_lab_config.py
RUN echo "c.NotebookApp.iopub_msg_rate_limit = 1.0e10" >> ~/.jupyter/jupyter_lab_config.py

# Build stage for Hadoop
FROM desertroam/hadoop-base:3.3.1-java8 AS hadoop-build

# Environment variables specific to Hadoop
ENV HADOOP_VERSION=3.3.1
ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1
ENV PATH $HADOOP_HOME/bin/:$PATH

# Create necessary directories for Hadoop
RUN mkdir -p /opt/hadoop-$HADOOP_VERSION/logs
RUN mkdir -p /hadoop-data

# Final stage: Combining Python and Hadoop setup
FROM python-base

# Environment variables specific to Hadoop
ENV HADOOP_VERSION=3.3.1
ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1
ENV PATH $HADOOP_HOME/bin/:$PATH

# Copy Hadoop from the hadoop-build stage
COPY --from=hadoop-build /opt/hadoop-${HADOOP_VERSION} /opt/hadoop-${HADOOP_VERSION}
COPY --from=hadoop-build ${JAVA_HOME} ${JAVA_HOME}

# Link Hadoop configuration and create necessary directories
RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop
RUN ln -s ${JAVA_HOME}/bin/java /usr/bin/java

RUN mkdir -p /opt/hadoop-$HADOOP_VERSION/logs
RUN mkdir /hadoop-data

# Copy entrypoint script and make it executable
COPY entrypoint.sh /
RUN chmod a+x /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
