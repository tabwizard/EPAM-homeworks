FROM python:3
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /code
RUN pip install --upgrade pip
COPY requirements.txt /code/
RUN sed -i 's/lxml==4.5.1/lxml/g' /code/requirements.txt \
    && pip install -r requirements.txt
COPY . .
RUN sed -i 's/ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS = \["*"\]/g' /code/lib_catalog/settings.py \
    && echo "\nCORS_ORIGIN_ALLOW_ALL = True" >> /code/lib_catalog/settings.py
EXPOSE 8000 
ENTRYPOINT ["./docker-entrypoint.sh"]
