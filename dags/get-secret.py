"""Example Airflow DAG that gets variable value from Google Secret Manager
    and print it to STDOUT.

    JUST TO DEMO
"""
import datetime

from airflow import DAG
from airflow.models import Variable
from airflow.operators.python import PythonOperator

def display_variable():
    my_var = Variable.get("non_sensetive_value")
    print('variable' + my_var)
    return my_var

dag = DAG(dag_id="get-secret-value", start_date=datetime.datetime(2022, 8, 10),
    schedule_interval='@daily')

task = PythonOperator(task_id='display_variable', python_callable=display_variable, dag=dag)
