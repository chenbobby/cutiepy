# About CutiePy

Welcome to CutiePy! This page contains background information about the CutiePy project.

## What is CutiePy?

CutiePy is a **batteries-included** job queue for Python.

You can use CutiePy define "jobs" (any Python function) and run jobs in the background.
You can also define:

* [scheduled jobs](#TODO-scheduled-jobs-docs) to run at a later time
* [periodic jobs](#TODO-periodic-jobs-docs) to run at regular intervals, like a [`cron`](https://en.wikipedia.org/wiki/Cron) job.

CutiePy includes a [web browser UI](#TODO-ui-docs) to assist you in monitoring jobs and troubleshooting issues.

You can learn more about CutiePy in our [**documentation**](/docs).

## Who created CutiePy?

CutiePy was created by me, Bobby Chen!

<img
    src="/img/chenbobby.jpg"
    style={{height: "200px", marginLeft: "32px", borderRadius: "100%"}}
    />

I am a software developer who loves developer tools.
I first fell in love with programming in middle school, when I learned to customize gameplay for Minecraft and Garry's Mod.
I create tools that I want to use myself, and I'm excited for you to try CutiePy.

I created CutiePy for my colleagues, my friends, and the wider Python community.
CutiePy was originally designed to help manage background jobs in our Django and Flask applications, such as making asynchronous API requests to email providers, etc.
Beyond web applications, CutiePy is also used in research for running ML experiments and queueing long-running Python jobs.

## What is CutiePy Labs?

Development of CutiePy is suppported by CutiePy Labs, a limited liability company (LLC).
The mission of CutiePy Labs is to empower users of CutiePy to build delightful applications.
CutiePy Labs serves as a legal entity for matters regarding copyright and licensing agreements.

The official company name is "CutiePy Labs LLC".

## How is CutiePy licensed?

CutiePy consists of two components:

* the `cutiepy` Python library
* the `cutiepy-cli` application

The `cutiepy` Python library is distributed under the Apache License, Version 2.0 (Apache-2.0). [Learn more about Apache-2.0](https://opensource.org/licenses/Apache-2.0)

The `cutiepy-cli` application is distributed under the GNU Affero General Public License version 3 (AGPL-3.0). [Learn more about AGPL-3.0](https://opensource.org/licenses/AGPL-3.0)

