from os import environ
from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.bash import BashOperator

SCRIPTS_PATH  = f"{environ.get('AIRFLOW_HOME')}/scripts/quotes-app"
LAKE_PATH = environ.get("LAKE_PATH")
LOGS_PATH = f"{LAKE_PATH}/logs"
ARGS = {
    "owner"            : "avcaliani",
    "depend_on_past"   : False,
    "start_date"       : datetime(2024, 4, 10),
    "email_on_failure" : False,
    "email_on_retry"   : False,
    "retries"          : 1,
    "retry_delay"      : timedelta(minutes=1)
}

with DAG(
    dag_id="simpsons-quotes-pipeline", 
    description="A pipeline that retrieve some quotes from The Simpsons API.",
    schedule="*/15 * * * *", 
    default_args=ARGS, 
    tags=["the-simpsons"],
    catchup=False) as dag:

    lake_init = BashOperator(
        task_id="lake-init",
        # The space after the .sh space is a workaround, if you don't add it, 
        # it won't work.
        # I don't know why this happens ¯\_(ツ)_/¯
        bash_command=f"{SCRIPTS_PATH}/init.sh ", 
        env={"LAKE_PATH": LAKE_PATH}
    )

    quotes_extractor = BashOperator(
        task_id="quotes-extractor",
        bash_command=f"{SCRIPTS_PATH}/quotes-extractor.sh --quotes 10 --sleep 1",
        env={
            "LAKE_PATH": LAKE_PATH,
            "LOGS_PATH": LOGS_PATH,
        }
    )

    is_homer_awake = BashOperator(
        task_id="is-homer-awake",
        bash_command=f"{SCRIPTS_PATH}/is-homer-awake.sh ",
        env={
            "LAKE_PATH": LAKE_PATH,
            "LOGS_PATH": LOGS_PATH,
        }
    )
    
    teardown = BashOperator(
        task_id="app-teardown",
        bash_command=f"{SCRIPTS_PATH}/teardown.sh ",
        trigger_rule="none_skipped"
    )

    lake_init >> quotes_extractor >> teardown
    lake_init >> is_homer_awake >> teardown
