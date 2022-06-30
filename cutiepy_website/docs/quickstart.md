---
sidebar_position: 2
title: "Quickstart"
---
import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Quickstart

Welcome to the Quickstart guide. This page will teach you how to:

1. [**Install CutiePy**](#1-install-cutiepy)
1. Register your Python function with CutiePy.
1. Start a broker server.
1. Enqueue your Python function as a job.
1. Run your job with a background worker.
1. View the output of your job with the CutiePy UI.

This Quickstart guide is beginner-friendly.
Before you start, you should at least be comfortable with writing Python code and using the your terminal to run shell commands.

Let's get started!

## 1. Install CutiePy

First, make sure that you have Python installed.
CutiePy works with Python 3.7+.

Next, install the `cutiepy` package from PyPI by using `pip`, `conda`, or your Python package manager of choice.

<Tabs>
  <TabItem value="pip" label="Use pip" default>

```sh title="Terminal"
pip install cutiepy
```

  </TabItem>
  <TabItem value="conda" label="Use conda">

```sh title="Terminal"
conda install cutiepy
```

  </TabItem>
</Tabs>

You are now ready to use CutiePy!

## 2. Register your Python function with CutiePy

After installing CutiePy, the next step is to write a Python function and register your function in a CutiePy [**Registry**](#TODO-registry-explanation).

A Registry stores information any Python function that you want to run as a CutiePy [**Job**](#TODO-job-explanation).
The Registry will pass this information along to a CutiePy [**Worker**](#TODO-worker-explanation) so that they can run your Job in the background.
You will learn more about Jobs and Workers in the later parts of this Quickstart guide.

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
    time.sleep(5)
    message = f"Your {flavor} pie for {recipient} is ready!"
    print(message)
    return message

```

The `@registry.job` is a [_function decorator_](https://www.geeksforgeeks.org/decorators-in-python/) that will register the function `bake_a_pie` in your Registry named `registry`.
After registering your function, you can still run it like any old Python function.

```python title="In a Python program"
>>> bake_a_pie("apple", "Alice")
# Sleeps 5 seconds...
"Your apple pie for Alice is ready!"
```

Our function `bake_a_pie` takes at least 5 seconds to run in the _foreground_.
In the next few steps, you will learn how to run your function in the _background_!

## 3. Start a broker server

After you define a function and register it in your Registry, the next step is to start a CutiePy [**Broker**](#TODO-broker-explanation).

A Broker is a server that accepts Jobs, stores your Jobs in a queue, and distributes your Jobs to Workers.
After a Worker runs your Job, the result of your Job will be returned to the Broker so you can access it later if you want to.

To start a Broker server, open a terminal and run the command `cutiepy broker`.

```shell title="In your terminal"
cutiepy broker
```

You should see the following output in your terminal:

```
[CutiePy Broker] Starting...
[CutiePy Broker] Listening on http://localhost:9000/
[CutiePy Broker] Open your web browser to http://localhost:9000/ to view the CutiePy UI.
```

You are now running a Broker server!

By default, the Broker server will run on `http://localhost:9000/`.
If you open your web browser to <a href="http://localhost:9000/" target="_blank">http://localhost:9000/</a>, you can view the [**CutiePy UI**](/docs/explanations/ui).
For example, with Google Chrome, you should see something like this:

![CutiePy UI](#TODO-cutiepy-ui-screenshot)

The CutiePy UI provides a graphical interface for you to monitor your Jobs and Workers.
You will not see any Jobs yet, but you will soon, after we enqueue a Job in the next step!

## 4. Enqueue your Python function as a job

After you define a function and register it in your Registry, the next step is to enqueue your function as a CutiePy [**Job**](#TODO-job-explanation).
A Job represents the function that you want to run and any arguments that you want to pass into the function.

A Job can also contain additional information for [timeouts](#TODO-timeout-explanation), [retries](#TODO-retry-explanation), and more.
We will not discuss timeouts and retries in this Quickstart guide, but you can learn more about them in the [**Tutorial**](/docs/tutorial) and [**Explanations**](/docs/explanations) section of our documentation.



## 2. Start a background worker

Before you run your task in the background, you need to start some **workers**. A worker is a process that waits in the background and runs your tasks for you. 

To start some workers, run this command in your terminal:

```sh title="Terminal"
cutiepy worker
```

This command will start two workers and wait for tasks to run for you. Learn more about [workers](#) in our documentation.

Now that you have some workers running, you are ready to run your task in the background.

## 3. Run your task in the background

To run your task in the background, you need to **enqueue** your task. Go back to your code editor and add some new code to your file `cutie.py`:

```python title="cutie.py"
import time
from cutiepy import CutiePy

cutie = CutiePy(mode="dev")

@cutie.task
def bake_a_pie(flavor, recipient):
    time.sleep(3)
    print(f"Your {flavor} pie for {recipient} is ready!")

# highlight-next-line-green
cutie.enqueue(bake_a_pie, args=["apple", "Alice"])

```

This new line of code will enqueue your task `bake_a_pie` to run in the background, with the arguments `"apple"` and `"Alice"`.

Your terminal might be busy with running your workers right now. Open a new terminal and run your file `cutie.py`.

```sh title="Terminal"
# In a different terminal than the one that is running your workers
python cutie.py
```

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
