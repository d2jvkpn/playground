FROM python:3.12-slim-trixie

ARG http_proxy
ARG https_proxy
ARG no_proxy

ENV http_proxy="${http_proxy}" https_proxy="${https_proxy}" no_proxy="${no_proxy}"

WORKDIR /app

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PYTHONPATH="" \
    MEM0_TELEMETRY=false

COPY data/mem0ai--mem0.git/server/requirements.txt .

COPY data/mem0ai--mem0.git/server/ ./
COPY entrypoint.sh /opt/entrypoint.sh

RUN chmod +x /opt/entrypoint.sh && \
    adduser --disabled-password --gecos "" appuser && \
    chown -R appuser:appuser /app

USER appuser

RUN pip install --upgrade pip setuptools wheel && \
    pip install -r requirements.txt && \
    pip install -q --force-reinstall --no-deps mem0ai && \
    pip install "psycopg[binary]" && \
    rm -rf /home/appuser/.cache

COPY entrypoint.sh /opt/entrypoint.sh

ENV PATH=/home/appuser/.local/bin:$PATH

ENV http_proxy="" https_proxy="" no_proxy=""
EXPOSE 8000

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
