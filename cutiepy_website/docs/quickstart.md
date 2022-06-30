---
sidebar_position: 2
title: "Quickstart"
---
import Link from '@docusaurus/Link';
import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Quickstart

Welcome to the Quickstart guide. This page will teach you how to:

1. [**Install CutiePy**](#1-install-cutiepy)
1. Register your Python function with CutiePy.
1. Start a broker server.
1. Enqueue your Python function as a job.
1. Run your job with a background worker.

This Quickstart guide is beginner-friendly.
Before you start, you should at least be comfortable with writing Python code and using the your terminal to run shell commands.

Let's get started!

## 1. Install CutiePy

First, make sure that you have Python installed.
CutiePy works with Python 3.7+.

Next, install the `cutiepy` and `cutiepy-cli` package from PyPI by using `pip`, `conda`, or your Python package manager of choice.

<Tabs>
  <TabItem value="pip" label="Use pip" default>

```sh title="Terminal"
pip install cutiepy cutiepy-cli
```

  </TabItem>
  <TabItem value="conda" label="Use conda">

```sh title="Terminal"
conda install cutiepy cutiepy-cli
```

  </TabItem>
</Tabs>

Here is a brief description of `cutiepy` and `cutiepy-cli`:

* `cutiepy` is a Python library for creating and enqueuing Jobs
* `cutiepy-cli` is a command line interface for running Brokers and Workers

:::info New Concepts

Do not worry if you are confused about the meaning of "Job", "Broker", and "Worker".
These are CutiePy concepts that you will learn about in the later parts of this Quickstart guide.

:::

Once you have `cutiepy` and `cutiepy-cli` installed, you are now ready to use CutiePy!

## 2. Register your Python function with CutiePy

After installing CutiePy, the next step is to write a Python function and register your function in a CutiePy [**Registry**](#TODO-registry-explanation).

:::info Explanation

A [**Registry**](#TODO-registry-explanation) is a Python object that stores information about any Python function that you want to run as a [**Job**](#TODO-job-explanation).
The Registry will pass this information along to a [**Worker**](#TODO-worker-explanation) so that they can run your Job in the background.
You will learn more about Jobs and Workers in the later parts of this Quickstart guide.

:::

First, open your code editor and create a new Python file called `cutie.py`.

Second, in your Python file, create a Registry object by calling `cutiepy.Registry()`.
In the example below, our Registry object is named `registry`.

Third, define a function that you want to run in the background, and use the `@registry.job` decorator to register your function in the Registry.
In the example below, our function is named `bake_a_pie`.

```python title="cutie.py"
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

The `@registry.job` is a [_function decorator_](https://www.geeksforgeeks.org/decorators-in-python/) that will register the function `bake_a_pie` in your Registry named `registry`.
After registering your function, you can still run it like any old Python function.

```python title="In a Python program"
>>> bake_a_pie("apple", "Alice")
# Sleeps 3 seconds...
"Your apple pie for Alice is ready!"
```

Our function `bake_a_pie` takes at least 3 seconds to run in the _foreground_.
In the next few steps, you will learn how to run your function in the _background_!

## 3. Start a broker server

After you define a function and register it in your Registry, the next step is to start a CutiePy [**Broker**](#TODO-broker-explanation).

:::info Explanation

A CutiePy [**Broker**](#TODO-broker-explanation) is a server that accepts [**Jobs**](#TODO-job-explanation), stores your Jobs in a queue, and distributes your Jobs to [**Workers**](#TODO-worker-explanation).
After a Worker runs your Job, the result of your Job will be returned to the Broker so you can access it later if you want to.
You will learn more about Jobs and Workers in the later parts of this Quickstart guide.

:::

To start a Broker server, open a new terminal and run the command `cutiepy-cli broker`.

```shell title="In your terminal"
cutiepy-cli broker
```

After you run the command above, you should see the following output in your terminal:

```
[CutiePy Broker] Starting...
[CutiePy Broker] Listening on http://localhost:9000
[CutiePy Broker] Open your web browser to http://localhost:9000 to view the CutiePy UI.
```

You are now running a Broker server!

By default, the Broker server will run on `http://localhost:9000`.
If you open your web browser to <Link to="http://localhost:9000">http://localhost:9000</Link>, you can view the [**CutiePy UI**](/docs/explanations/ui).
For example, you should see something like this:

![CutiePy UI](#TODO-cutiepy-ui-screenshot)

The CutiePy UI provides a graphical interface for you to monitor your Jobs and Workers.
You will not see any Jobs yet, but you will soon, after we enqueue a Job in the next step!

## 4. Enqueue your Python function as a job

After you start the Broker, the next step is to enqueue your function as a CutiePy [**Job**](#TODO-job-explanation).

:::info Explanation

A [**Job**](#TODO-job-explanation) is a JSON object that represents the function that you want to run and any arguments that you want to pass into the function.
A Job can also contain additional information for [timeouts](#TODO-timeout-explanation), [retries](#TODO-retry-explanation), and more.
We will not discuss timeouts and retries in this Quickstart guide, but you can learn more about them in the [**Tutorial**](/docs/tutorial) and [**Explanations**](/docs/explanations) section of our documentation.

:::

To enqueue your function as a Job, use the `.enqueue_job(...)` method. This method was added to your function when you registered it in your Registry with the `@registry.job` decorator. In the example below, we enqueue a job to run the function `bake_a_cake` with the arguments `"apple"` and `"Alice"`.

```python title="cutie.py"
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

Next, open a new terminal (a different terminal than the one that is running your Broker) and run this Python file. If you get no errors, then you have successfully enqueued a new Job!

To check that your Job has been enqueued, open the CutiePy UI that should be running on <Link to="http://localhost:9000/">http://localhost:9000</Link>. You should see that your Job has a name of `cutie.bake_a_cake` and status of `Ready`.

![Ready to bake a cake](#TODO-ui-screenshot)

We are almost done! The last step is to start a Worker so it can run your Job.

## 5. Start a background worker

After you enqueue your Job, the next step is to start a CutiePy [**Worker**](#TODO-worker-explanation).

:::info Explanation

A [**Worker**](#TODO-worker-explanation) is background process that asks the Broker for any Jobs that are ready to be run. If the Broker provides the Worker with a Job, then the Worker will run the Job and return the result to the Broker. If the Job has no return value, then the Worker will run the Job and simply notify the Broker that it has completed.

:::

To start a Worker, use a new terminal (a different terminal than the one that is running your Broker) to run the command `cutiepy-cli worker`.


```shell title="In your terminal"
cutiepy-cli worker
```

After you run the command above, you should see the following output in your terminal:

```
[CutiePy Worker] Starting...
[CutiePy Worker] Worker has connected to the Broker at http://localhost:9000.
[CutiePy Worker] My Worker ID is 12341234-1234-1234-1234-123412341234
[CutiePy Worker] Requesting for a new job to run...
[CutiePy Worker] Received a job "cutie.bake_a_cake"
[CutiePy Worker] Your apple pie for Alice is ready!
[CutiePy Worker] Completed job "cutie.bake_a_cake"
[CutiePy Worker] Requesting for a new job to run...
```

Congratulations! You just ran your first Job with a Worker!

You can check the result of your Job in the CutiePy UI. 

---

Your program should finish instantly, because your task is now running in the background. After 3 seconds, check the terminal that is running your workers and you should see this message:

```text title="Terminal"
[CutiePy::Worker[0] Output] Your apple pie for Alice is ready!
```

Congratulations! You just ran your first CutiePy task in the background!

## Next Steps

This quickstart guide only scratches the surface of CutiePy's features. Learn more about CutiePy's features in the [tutorial](#). In the tutorial, you will learn:

* How to build an X with CutiePy
* How to use the CutiePy [dashboard](#) to monitor your workers and tasks

CutiePy is flexible for a wide range of use cases. Learn how to build and deploy applications in our [how-to guides](#).

CutiePy is a distributed task queue that can scale up to 1000s of workers. Learn more about CutiePy's [architecture](#) in our documentation.

## Community and Support

CutiePy is open sourced on [GitHub](https://github.com/cutiepy/cutiepy) and supported by a community of developers. If you have any questions, please [start a discussion](#) or [open an issue](#).

You can also join our [Slack community](#) for faster conversations.
