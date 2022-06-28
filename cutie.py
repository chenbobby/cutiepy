import cutiepy

registry = cutiepy.Registry(broker_url="http://localhost:4000")


@registry.job
def add(x, y):
    return x + y


if __name__ == "__main__":
    job_id = add.enqueue(args=[1, 2])
    print(f"Enqueued a job with ID {job_id}")
