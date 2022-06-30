import time

import cutiepy

registry = cutiepy.Registry(broker_url="http://localhost:4000")


@registry.job
def add(x, y):
    return x + y


@registry.job
def slow_add(x, y):
    time.sleep(2)
    return x + y


@registry.job
def fail(x, y):
    raise RuntimeError(f"Oppsie woopsies. x={x} y={y}")


if __name__ == "__main__":
    add.enqueue_job(args=[1, 2])
    fail.enqueue_job(args=[1, 2])
    slow_add.enqueue_job(args=[1, 2])
    slow_add.enqueue_job(args=[1, 2], job_timeout_ms=1500)
    slow_add.enqueue_job(args=[1, 2], job_run_timeout_ms=1500)
    slow_add.enqueue_job(args=[1, 2], job_timeout_ms=6000, job_run_timeout_ms=1500)
    slow_add.enqueue_job(args=[1, 2], job_timeout_ms=2000, job_run_timeout_ms=2500)
