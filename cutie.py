import time

import cutiepy

registry = cutiepy.Registry(broker_url="http://localhost:4000")


@registry.job
def add_with_a_super_long_name_999999999999999999999(x, y):
    return x + y


@registry.job
def slow_add(x, y):
    time.sleep(2)
    return x + y


@registry.job
def fail(x, y):
    raise RuntimeError(f"Oppsie woopsies. x={x} y={y}")


if __name__ == "__main__":
    for _ in range(100):
        add_with_a_super_long_name_999999999999999999999.enqueue_job(args=[1, 2])
