import logging
import json
import papermill as pm

logger = logging.getLogger()
logger.setLevel(logging.INFO)   

def handler(event, context):
    logger.info(json.dumps(event))
    pm.execute_notebook(
        'src/app/input.ipynb',
        '/tmp/output.ipynb',
        parameters=dict()
    )
    return {'statusCode': 200, 'body': "{'handler': 'success'}"}
