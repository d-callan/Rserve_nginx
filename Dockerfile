FROM r-base:4.0.2

## Set a default user. Available via runtime flag `--user rserve`
## User should also have & own a home directory (for rstudio or linked volumes to work properly).
RUN useradd rserve \
	&& mkdir /home/rserve \
	&& chown rserve:rserve /home/rserve \

## install libs
RUN R -e "install.packages('Rserve', version='1.8-7', repos='http://rforge.net')"
RUN R -e "install.packages('data.table', version='1.13.0')"
RUN R -e "install.packages('devtools', version='2.3.1')"
RUN R -e "library(devtools)"
RUN R -e "devtools::install_github('VEuPathDB/plot.data')"


## Rserve
RUN mkdir -p /opt/rserve
ENV RSERVE_HOME /opt/rserve

COPY etc ${RSERVE_HOME}/etc
COPY run_rserve.sh ${RSERVE_HOME}/bin/
RUN chmod 755 ${RSERVE_HOME}/bin/run_rserve.sh

RUN mkdir ${RSERVE_HOME}/work

EXPOSE 8080

CMD ["/opt/rserve/bin/run_rserve.sh"]
