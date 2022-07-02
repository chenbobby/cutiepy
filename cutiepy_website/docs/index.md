---
sidebar_position: 1
title: "Home"
---
import Link from '@docusaurus/Link';

# Documentation

**Welcome to the CutiePy documentation.**
This is a collection of resources to help you get started with CutiePy.

## Start Here

Here are some high-level resources to help you learn more about CutiePy.

<p>
    <Link
        to="/docs/quickstart"
        style={{"font-size": "1.25rem", "font-weight": "bold"}}
        >
        Quickstart
    </Link>
    <br/>
    <span style={{"font-style": "italic"}}>
        Install and run CutiePy in 5 minutes
    </span>
</p>
<p>
    <Link
        to="/docs/tutorial"
        style={{"font-size": "1.25rem", "font-weight": "bold"}}
        >
        Tutorial
    </Link>
    <br/>
    <span style={{"font-style": "italic"}}>
        Build an X with CutiePy
    </span>
</p>
<p>
    <Link
        to="/docs/how-to"
        style={{"font-size": "1.25rem", "font-weight": "bold"}}
        >
        How-To Guides
    </Link>
    <br/>
    <span style={{"font-style": "italic"}}>
        Learn how to use CutiePy for web apps, cron jobs, ML experiments, and more
    </span>
</p>
<p>
    <Link
        to="/docs/explanations"
        style={{"font-size": "1.25rem", "font-weight": "bold"}}
        >
        Explanations
    </Link>
    <br/>
    <span style={{"font-style": "italic"}}>
        Read about how CutiePy works under the hood
    </span>
</p>
<p>
    <Link
        to="/docs/reference"
        style={{"font-size": "1.25rem", "font-weight": "bold"}}
        >
        API Reference
    </Link>
    <br/>
    <span style={{"font-style": "italic"}}>
        User manual for the CutiePy library, <code style={{"font-style": "normal"}}>cutiepy</code> commands, and configuration options
    </span>
</p>
<p>
    <Link
        to="#"
        style={{"font-size": "1.25rem", "font-weight": "bold"}}
        >
        Deployment Checklist
    </Link>
    <br/>
    <span style={{"font-style": "italic"}}>
        Security and performance considerations for production environments
    </span>
</p>

## What is CutiePy?

CutiePy is an **open source, fully-featured job queue for Python workloads**.

CutiePy ships with a **real-time monitoring dashboard** to help you track your jobs and workers.

![CutiePy UI Screenshot](#TODO)

You can use CutiePy to define "jobs" (any Python function) and run these jobs on background workers.

You can also define:

* [**deferred jobs**](#TODO-deferred-jobs-docs) that run at a later time
* [**periodic jobs**](#TODO-periodic-jobs-docs) that run at regular intervals, like a [`cron`](https://en.wikipedia.org/wiki/Cron) job.

Here is a simple example of how CutiePy is used in practice:

``` python title="cutie.py"
import cutiepy
import time

registry = cutiepy.Registry()

@registry.job
def bake_a_pie(flavor, recipient):
    time.sleep(3)
    pie = f"{flavor} pie for {recipient}"
    print(f"Your {pie} is ready!")
    return pie


# Enqueue your job to run on a background worker.
bake_a_pie.enqueue_job(args=["apple", "Alice"])

```

``` console title="Output"
Printed to stdout: "Your apple pie for Alice is ready!"
Return value:      "apple pie for Alice"
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
