import time

import cutiepy

registry = cutiepy.Registry(broker_url="http://localhost:4000")


@registry.job
def wait():
    time.sleep(0.1)


if __name__ == "__main__":
    job_id = wait.enqueue()
    print(f"Enqueued a job with ID {job_id}")
