FROM python:3.10-slim

WORKDIR /app

COPY . .

RUN pip install --upgrade pip && \
    pip install -r requirements.txt

EXPOSE 8080

CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
