# About CutiePy

Welcome to CutiePy! This page contains background information about the CutiePy project.

## What is CutiePy?

CutiePy is an **open source, fully-featured job queue for Python workloads**.

CutiePy ships with a **real-time monitoring dashboard** to help you track your jobs and workers.

![CutiePy UI Screenshot](#TODO)

You can use CutiePy to define "jobs" (any Python function) and run these jobs on background workers.

You can also define:

* [**deferred jobs**](#TODO-deferred-jobs-docs) that run at a later time
* [**periodic jobs**](#TODO-periodic-jobs-docs) that run at regular intervals, like a [`cron`](https://en.wikipedia.org/wiki/Cron) job.

You can learn more about CutiePy in our [**documentation**](/docs).

## Who created CutiePy?

CutiePy was created by me, **Bobby Chen**!

<img
    src="/img/chenbobby.jpg"
    style={{height: "200px", marginLeft: "32px", borderRadius: "100%"}}
    />

**I am a software developer who loves building developer tools.**

I first fell in love with programming in middle school, when I learned to customize gameplay for Minecraft and Garry's Mod.
Over the years, I have worked as a software engineer at [**Airbnb**](https://airbnb.com/), [**Intel**](https://www.intel.com/), [**DataCamp**](https://www.datacamp.com/), and [**Dagster**](https://dagster.io/).
My work has involved building internal tools for managing web infrastructure, Kubernetes, and data pipelines.

**I make tools that I want to use myself, and I'm excited for you to try CutiePy!**

I created CutiePy for my colleagues, my friends, and the wider Python community.
CutiePy was originally designed to help manage background jobs in our Django and Flask applications, such as making asynchronous API requests to email providers, connecting to Slack/Discord endpoints, and sending webhooks.
Beyond web applications, CutiePy is also used in research for parallelizing data pipelines, ML experiments, and other long-running Python workloads.

## How is CutiePy licensed?

CutiePy is open source, released under the **Apache License 2.0**.

The source code of CutiePy is available in the official GitHub repository [**chenbobby/cutiepy**](https://github.com/chenbobby/cutiepy).
