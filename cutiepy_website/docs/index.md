---
sidebar_position: 1
title: "Home"
---

# Documentation

**Welcome to the CutiePy documentation.**
This is a collection of resources to help you get started with CutiePy.

## Start Here

Here are some high-level resources to help you learn more about CutiePy.

<p>
    <a
        href="/docs/quickstart"
        style={{"font-size": "1.25rem", "font-weight": "bold"}}
        >
        Quickstart
    </a>
    <br/>
    <span style={{"font-style": "italic"}}>
        Install and run CutiePy in 5 minutes
    </span>
</p>
<p>
    <a
        href="/docs/tutorial"
        style={{"font-size": "1.25rem", "font-weight": "bold"}}
        >
        Tutorial
    </a>
    <br/>
    <span style={{"font-style": "italic"}}>
        Build an X with CutiePy
    </span>
</p>
<p>
    <a
        href="/docs/how-to"
        style={{"font-size": "1.25rem", "font-weight": "bold"}}
        >
        How-To Guides
    </a>
    <br/>
    <span style={{"font-style": "italic"}}>
        Learn how to use CutiePy for web apps, cron jobs, ML experiments, and more
    </span>
</p>
<p>
    <a
        href="/docs/explanations"
        style={{"font-size": "1.25rem", "font-weight": "bold"}}
        >
        Explanations
    </a>
    <br/>
    <span style={{"font-style": "italic"}}>
        Read about CutiePy's architecture
    </span>
</p>
<p>
    <a
        href="/docs/reference"
        style={{"font-size": "1.25rem", "font-weight": "bold"}}
        >
        API Reference
    </a>
    <br/>
    <span style={{"font-style": "italic"}}>
        User manual for the CutiePy library, <code style={{"font-style": "normal"}}>cutiepy</code> commands, and configuration options
    </span>
</p>
<p>
    <a
        href="#"
        style={{"font-size": "1.25rem", "font-weight": "bold"}}
        >
        Deployment Checklist
    </a>
    <br/>
    <span style={{"font-style": "italic"}}>
        Security and performance considerations for production environments
    </span>
</p>

## What is CutiePy?

CutiePy is a **batteries-included** [job queue](#TODO-write-blog-post) for Python.

You can use CutiePy define "jobs" (any Python function) and run jobs in the background.
You can also define:

* [scheduled jobs](#TODO-scheduled-jobs-docs) to run at a later time
* [periodic jobs](#TODO-periodic-jobs-docs) to run at regular intervals, like a [`cron`](https://en.wikipedia.org/wiki/Cron) job.

Here is a simple example of how CutiePy is used in practice:

```python title="cutie.py"
import cutiepy

registry = cutiepy.Registry(broker_url="http://localhost:9000")

@registry.job
def bake_a_pie(flavor, recipient):
    time.sleep(3)
    print(f"Your {flavor} pie for {recipient} is ready!")


# Enqueue your job to run in the background.
bake_a_pie.enqueue_job(args=["apple", "Alice"])
```

```python title="Output from CutiePy worker"
"Your apple pie for Alice is ready!"
```

Visit our [**Quickstart**](/docs/quickstart) guide to get up and running with CutiePy in less than 5 minutes.

You can also read our [**Tutorial**](/docs/tutorial) to learn about CutiePy features and build an X with CutiePy.

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
