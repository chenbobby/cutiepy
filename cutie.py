import cutiepy

app = cutiepy.CutiePy("http://localhost:4000")


def add(x, y):
    return x + y


job_id = app.enqueue(add, [1, 2])
print(job_id)
