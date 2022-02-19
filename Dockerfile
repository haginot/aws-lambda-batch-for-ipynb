FROM public.ecr.aws/lambda/python:3.8

# Copy function code
COPY app.py ${LAMBDA_TASK_ROOT}
COPY credentials/ ${LAMBDA_TASK_ROOT}/credentials/
COPY input/ ${LAMBDA_TASK_ROOT}/input/
COPY artifacts/ ${LAMBDA_TASK_ROOT}/artifacts/
COPY src/ ${LAMBDA_TASK_ROOT}/src/

# Install the function's dependencies using file requirements.txt
# from your project folder.

COPY requirements.txt  .
RUN pip3 install --upgrade pip 
RUN pip3 install --upgrade -r requirements.txt --target "${LAMBDA_TASK_ROOT}"
RUN pip3 install --upgrade ipython ipykernel
RUN ipython kernel install --name "python3" --user

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "app.handler" ]
