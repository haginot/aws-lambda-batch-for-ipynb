import os
from google.oauth2 import service_account
from pydata_google_auth.cache import CredentialsCache
import logging
import json
import papermill as pm

logger = logging.getLogger()
logger.setLevel(logging.INFO)   

service_account_env = os.environ.get('SERVICE_ACCOUNT')

def handler(event, context):
    logger.info(json.dumps(event))
    service_account_path = None
    if service_account_env:
        if os.path.isfile(service_account_env):
            service_account_path = os.path.abspath(service_account_env)
        else:
            service_account_path = '/tmp/service_account.json'
            service_account_info = (
                {
                    "type": "service_account",
                    "project_id": os.environ.get('SERVICE_ACCOUNT_PROJECT_ID'),
                    "private_key_id": os.environ.get('SERVICE_ACCOUNT_PRIVATE_KEY_ID'),
                    "private_key": os.environ.get('SERVICE_ACCOUNT_PRIVATE_KEY'),
                    "client_email": os.environ.get('SERVICE_ACCOUNT_CLIENT_EMAIL'),
                    "client_id": os.environ.get('SERVICE_ACCOUNT_CLIENT_ID'),
                    "auth_uri": os.environ.get('SERVICE_ACCOUNT_AUTH_URI'),
                    "token_uri": os.environ.get('SERVICE_ACCOUNT_TOKEN_URI'),
                    "auth_provider_x509_cert_url": os.environ.get('SERVICE_ACCOUNT_AUTH_PROVIDER_X509_CERT_URI'),
                    "client_x509_cert_url": os.environ.get('SERVICE_ACCOUNT_CLIENT_X509_CERT_URI')
                }
            )
            with open(service_account_path, 'w') as file:
                json.dump(service_account_info, file)

    # notebook_params = pm.inspect_notebook('src/app/input.ipynb')
    # logger.info(notebook_params)

    pm.execute_notebook(
        'src/app/input.ipynb',
        '/tmp/output.ipynb',
        parameters=dict(service_account_path=service_account_path)
    )

    with open('/tmp/test', 'r') as f:
        result = f.read()

    return {'statusCode': 200, 'body': "{'handler': 'success'}", 'result': result}
