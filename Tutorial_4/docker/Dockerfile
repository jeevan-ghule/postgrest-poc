FROM postgres:13.2

RUN apt-get update && apt-get -y install git build-essential postgresql-server-dev-13

RUN git clone https://github.com/citusdata/pg_cron.git
RUN cd pg_cron && make && make install

RUN cd ..

RUN git clone https://github.com/michelp/pgjwt.git
RUN cd pgjwt && make && make install


RUN cd / && \
    rm -rf /pg_cron && \
    apt-get remove -y git build-essential postgresql-server-dev-13 && \
    apt-get autoremove --purge -y && \
    apt-get clean && \
    apt-get purge

# COPY ./init-db /docker-entrypoint-initdb.d