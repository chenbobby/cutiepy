---
sidebar_position: 8
title: Quickstart2
---

import Link from '@docusaurus/Link';
import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Quickstart

Welcome to the CutiePy Quickstart guide. This page will teach you how to:

1. [**Install CutiePy**](#1-install-cutiepy)
1. [**Register your Python function with CutiePy**](#2-register-your-python-function-with-cutiepy)
1. [**Start a broker server**](#3-start-a-broker-server)
1. [**Enqueue your Python function as a job**](#4-enqueue-your-python-function-as-a-job)
1. [**Run your job with a background worker**](#5-start-a-background-worker)

This Quickstart guide is beginner-friendly.
Before you begin, you should at least be comfortable with writing Python code and using the your terminal to run shell commands.

Let's get started!

## 1. Install CutiePy

First, make sure that you have Python installed.
CutiePy works with Python 3.7+.

Next, install the `cutiepy` package from PyPI by using `pip`, `conda`, or your Python package manager of choice.

<Tabs>
  <TabItem value="pip" label="Use pip" default>

``` console title="In your terminal"
pip install cutiepy
```

  </TabItem>
  <TabItem value="conda" label="Use conda">

``` console title="In your terminal"
conda install cutiepy
```

  </TabItem>
</Tabs>

Once you have `cutiepy` installed, you are now ready to use CutiePy!

## 2. Register your Python function with CutiePy

After installing CutiePy, the next step is to write a Python function and register your function in a CutiePy **Registry**.

1. Create a file named `cutie.py`.
1. Create a registry with `cutiepy.Registry()`.
1. Define a function and add the decorator `@registry.job` on your function.

Here is an example:

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

```

## 3. Start a broker server

After you register your function in your Registry, the next step is to start a CutiePy **Broker**.

Open a new terminal and run the following command:

``` console title="In your terminal"
cutiepy broker
```

After you run the command above, you should see the following output in your terminal:

``` console
[CutiePy Broker] Starting...
[CutiePy Broker] Listening on http://localhost:9000
[CutiePy Broker] Open your web browser to http://localhost:9000 to view the CutiePy UI.
```

You are now running a Broker!

## 4. Enqueue your Python function as a job

After you start the Broker, the next step is to enqueue your function as a CutiePy **Job**.

To enqueue your function as a Job, use the `.enqueue_job(...)` method. This method was added to your function when you registered your function in your Registry with the `@registry.job` decorator.

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

# highlight-next-line-green
bake_a_pie.enqueue_job(args=["apple", "Alice"])

```

Next, open a new terminal (a different terminal than the one that is running your Broker) and run your Python file.

``` console title="In your terminal"
python cutie.py
```

If you get no errors, then you have successfully enqueued a new Job!

You can also check that your Job has been enqueued by looking at the CutiePy UI.
Open your web browser to <Link to="http://localhost:9000/">http://localhost:9000</Link>.
You should see that your Job has a name of `cutie.bake_a_pie` and a status of `Ready`.

![Ready to bake a pie](#TODO-ui-screenshot)

We are almost done! The last step is to start a Worker so it can run your Job.

## 5. Start a background worker

After you enqueue your Job, the next step is to start a CutiePy **Worker**.

To start a Worker, open a new terminal (a different terminal than the one that is running your Broker) to run the following command:


``` console title="In your terminal"
cutiepy worker
```

After you run the command above, you should see the following output in your terminal:

``` console
[CutiePy Worker] Starting...
[CutiePy Worker] Worker has connected to the Broker at http://localhost:9000.
[CutiePy Worker] My Worker ID is 12341234-1234-1234-1234-123412341234
[CutiePy Worker] Requesting for a new job to run...
[CutiePy Worker] Received a job "cutie.bake_a_pie"
[CutiePy Worker] Your apple pie for Alice is ready!
[CutiePy Worker] Completed job "cutie.bake_a_pie"
[CutiePy Worker] Requesting for a new job to run...
```

You just ran your first Job with a Worker!

You can also check that your Job has been completed by looking at the CutiePy UI.
Open your web browser to <Link to="http://localhost:9000/">http://localhost:9000</Link>.
You should see that your Job now has a status of  `Success`.

![CutiePy UI](#TODO-cutiepy-ui-screenshot)

If you click the row with your Job, you can view more details about the Job and its results.

![CutiePy UI](#TODO-cutiepy-ui-screenshot)

Congratulations! You have completed the CutiePy quickstart guide.
