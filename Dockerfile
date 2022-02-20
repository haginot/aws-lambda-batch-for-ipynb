FROM public.ecr.aws/lambda/python:3.9

# Install the function's dependencies using file requirements.txt
# from your project folder.

COPY requirements.txt  .
RUN pip3 install --upgrade pip 
RUN pip3 install --upgrade -r requirements.txt --target "${LAMBDA_TASK_ROOT}"
RUN pip3 install --upgrade ipython ipykernel
RUN ipython kernel install --name "python3" --user
RUN pip3 install  awslambdaric

# Copy function code
COPY app.py ${LAMBDA_TASK_ROOT}
COPY credentials/ ${LAMBDA_TASK_ROOT}/credentials/
COPY input/ ${LAMBDA_TASK_ROOT}/input/
COPY artifacts/ ${LAMBDA_TASK_ROOT}/artifacts/
COPY src/ ${LAMBDA_TASK_ROOT}/src/

# Creating a Docker Image for Lambda with the Runtime Interface Client
COPY ./entry_script.sh /entry_script.sh
ADD aws-lambda-rie-x86_64 /usr/local/bin/aws-lambda-rie
ENTRYPOINT [ "/entry_script.sh" ]

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "app.handler" ]