FROM python:alpine@sha256:dd4d2bd5b53d9b25a51da13addf2be586beebd5387e289e798e4083d94ca837a

WORKDIR /app

COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install --no-cache-dir --root-user-action=ignore -r requirements.txt && \
    adduser -D appuser && \
    chown -R appuser:appuser /app

COPY --chown=appuser:appuser . .

USER appuser

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
