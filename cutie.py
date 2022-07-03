import time
from datetime import datetime, timedelta, timezone

import cutiepy

registry = cutiepy.Registry(broker_url="http://localhost:4000")


@registry.job
def succeed(x, y):
    return x + y


@registry.job
def fail(x, y):
    raise RuntimeError(f"Oppsie woopsies. x={x} y={y}")


@registry.job
def half_second(x, y):
    time.sleep(0.5)
    return x + y


if __name__ == "__main__":
    # succeed.enqueue_job(args=[9, 10])
    # fail.enqueue_job(args=[9, 10])
    # half_second.enqueue_job(args=[9, 10])
    # half_second.enqueue_job(args=[9, 10], job_timeout_ms=400)
    # half_second.enqueue_job(args=[9, 10], job_run_timeout_ms=400)
    # half_second.enqueue_job(args=[9, 10], job_timeout_ms=1000)
    # half_second.enqueue_job(args=[9, 10], job_run_timeout_ms=1000)

    two_seconds_later = datetime.now(timezone.utc) + timedelta(seconds=2)
    succeed.create_scheduled_job(args=[9, 10], enqueue_after=two_seconds_later)

    # succeed.repeat_job(
    #     args=[9, 10],
    #     start_after=two_seconds_later,
    #     interval_ms=5000,
    # )
