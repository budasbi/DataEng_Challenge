FROM public.ecr.aws/docker/library/python:3.10.13-alpine3.18

COPY . /usr/local/bin/
WORKDIR /usr/local/bin

RUN pip3 install pip --upgrade
RUN pip3 install --upgrade setuptools
RUN pip install --upgrade pipenv
RUN pip3 install -r requirements.txt


ENTRYPOINT ["python","./lambda_data_challenge.py"]