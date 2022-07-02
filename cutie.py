import time

import cutiepy

registry = cutiepy.Registry(broker_url="http://localhost:4000")


@registry.job
def succeed(x, y):
    return x + y


@registry.job
def fail(x, y):
    raise RuntimeError(f"Oppsie woopsies. x={x} y={y}")


@registry.job
def three_seconds(x, y):
    time.sleep(3)
    return x + y


if __name__ == "__main__":
    succeed.enqueue_job(args=[9, 10])
    fail.enqueue_job(args=[9, 10])
    three_seconds.enqueue_job(args=[9, 10])
    three_seconds.enqueue_job(args=[9, 10], job_timeout_ms=1000)
    three_seconds.enqueue_job(args=[9, 10], job_run_timeout_ms=1000)
    three_seconds.enqueue_job(args=[9, 10], job_timeout_ms=4000)
    three_seconds.enqueue_job(args=[9, 10], job_run_timeout_ms=4000)
