FROM apache/airflow:2.10.5-python3.8

# I did that to remove the Web App authentication 😅
# ref: https://stackoverflow.com/a/70161587/13039203
RUN echo -e "\nAUTH_ROLE_PUBLIC = 'Admin'" >> "$AIRFLOW_HOME/webserver_config.py"

CMD ["standalone"]
