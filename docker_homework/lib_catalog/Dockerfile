FROM python:3.9-buster
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /code
RUN pip install --upgrade pip
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN sed -i 's/ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS = \["*"\]/g' /code/lib_catalog/settings.py \
    && sed -i 's/DEBUG = True/DEBUG = False/g' /code/lib_catalog/settings.py \
    && echo "\nCORS_ORIGIN_ALLOW_ALL = True" >> /code/lib_catalog/settings.py
EXPOSE 8000 
ENTRYPOINT ["./docker-entrypoint.sh"]
