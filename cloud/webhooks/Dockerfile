FROM python:3.8

RUN mkdir /app
WORKDIR /app

RUN pip install pipenv
COPY ./Pipfile .
COPY ./Pipfile.lock .
RUN pipenv install

COPY webhooks.py .
COPY config.json .

CMD ["pipenv", "run", "flask", "run", "--host=0.0.0.0"]