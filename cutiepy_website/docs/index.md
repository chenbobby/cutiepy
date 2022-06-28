---
sidebar_position: 1
title: "Home - Documentation"
---

# Documentation

**Welcome to the CutiePy documentation.** It has a collection of resources to help you get started with CutiePy.

## Start Here

Here are some high-level resources to help you learn more about CutiePy.

<p>
    <a href="/docs/quickstart" style={{"font-size": "1.25rem", "font-weight": "bold"}}>Quickstart</a>
    <br/>
    <span style={{"font-style": "italic"}}>Install and run CutiePy in 5 minutes</span>
</p>
<p>
    <a href="/docs/quickstart" style={{"font-size": "1.25rem", "font-weight": "bold"}}>Tutorial</a>
    <br/>
    <span style={{"font-style": "italic"}}>Build an X with CutiePy</span>
</p>
<p>
    <a href="/docs/quickstart" style={{"font-size": "1.25rem", "font-weight": "bold"}}>Explanations</a>
    <br/>
    <span style={{"font-style": "italic"}}>Read about CutiePy's architecture</span>
</p>
<p>
    <a href="/docs/quickstart" style={{"font-size": "1.25rem", "font-weight": "bold"}}>How-To Guides</a>
    <br/>
    <span style={{"font-style": "italic"}}>Learn how to use CutiePy for web apps, cron jobs, ML experiments, and more</span>
</p>
<p>
    <a href="/docs/quickstart" style={{"font-size": "1.25rem", "font-weight": "bold"}}>API Reference</a>
    <br/>
    <span style={{"font-style": "italic"}}>User manual for the CutiePy library, <code style={{"font-style": "normal"}}>cutiepy</code> commands, and configuration options</span>
</p>
<p>
    <a href="/docs/quickstart" style={{"font-size": "1.25rem", "font-weight": "bold"}}>Performance Guide</a>
    <br/>
    <span style={{"font-style": "italic"}}>Design patterns and performance considerations for production environments</span>
</p>

## What is CutiePy?

CutiePy is a [distributed task queue](#TODO-write-blog-post) for Python. You can define "tasks" (any Python function) and run them in the background.

Here is a simple example of how CutiePy is used in practice:

```python title="cutie.py"
from cutiepy import CutiePy

cutie = CutiePy(mode="dev")

@cutie.task
def bake_a_pie(flavor, recipient):
    time.sleep(3)
    print(f"Your {flavor} pie for {recipient} is ready!")


# Enqueue your task to run in the background.
app.enqueue(bake_a_pie, args=["apple", "Alice"])
```

```python title="Output from background worker"
"Your apple pie for Alice is ready!"
```

### Use Cases
CutiePy is flexible and scalable for many use cases:

* running background jobs in [Django](https://www.djangoproject.com/), [Flask](https://flask.palletsprojects.com/), or [FastAPI](https://fastapi.tiangolo.com/) web apps
* scheduling cron jobs
* parallelizing ML training and validation workloads

### Scalability

CutiePy is horizontally scalable and can run with thousands of background workers. CutiePy has supported clusters of up to 100 workers, processing 100k jobs / second, on 3 Linode boxes.

Use the command `cutiepy worker` to run your CutiePy workers.

[TODO] Visualization of CutiePy throughput

### Monitoring

CutiePy includes a dashboard for monitoring tasks and workers. The dashboard runs as an HTTP server and can be viewed in the web browser.

Use the command `cutiepy dashboard` to run the CutiePy dashboard server.

[TODO] Screenshot of dashboard
