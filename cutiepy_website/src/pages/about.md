# About CutiePy

Welcome to CutiePy! This page contains background information about the CutiePy project.

## What is CutiePy?

CutiePy is a **batteries-included** job queue for Python workloads.

You can use CutiePy define "jobs" (any Python function) and run these jobs with background workers.

You can also define:

* [scheduled jobs](#TODO-scheduled-jobs-docs) to run at a later time
* [periodic jobs](#TODO-periodic-jobs-docs) to run at regular intervals, like a [`cron`](https://en.wikipedia.org/wiki/Cron) job.

CutiePy includes a [web browser UI](#TODO-ui-docs) to assist you in monitoring jobs and troubleshooting issues.

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
Beyond web applications, CutiePy is also used in research for running ML experiments and queueing long-running Python jobs.

## How is CutiePy licensed?

CutiePy is pubicly available in the GitHub repository [`chenbobby/cutiepy`](https://github.com/chenbobby/cutiepy). CutiePy is released under OSI-approved licenses.

CutiePy consists of two components:

* the CutiePy Python library
* the CutiePy CLI application

The **CutiePy Python library** is released under the **Apache License 2.0** (Apache-2.0). [Read more about Apache-2.0](https://opensource.org/licenses/Apache-2.0)

The **CutiePy CLI application** is released under the **GNU Affero General Public License v3.0** (AGPL-3.0). [Read more about AGPL-3.0](https://opensource.org/licenses/AGPL-3.0)

Also, the source code for this website, [cutiepy.org](https://cutiepy.org), is released under the Apache License 2.0 (Apache-2.0). [Read more about Apache-2.0](https://opensource.org/licenses/Apache-2.0)
