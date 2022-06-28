---
sidebar_position: 2
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Quickstart

This page will teach you how to install CutiePy, define a task, and run it with a background worker.

## Installation

First, make sure that you have Python installed. CutiePy works with Python 3.5+

Next, install `cutiepy` using `pip`, `conda`, or your Python package manager of choice.

<Tabs>
  <TabItem value="pip" label="pip" default>

```sh title="Terminal"
pip install cutiepy
```

  </TabItem>
  <TabItem value="conda" label="conda">

```sh title="Terminal"
conda install cutiepy
```

  </TabItem>
</Tabs>

You are now ready to use CutiePy!

## 1. Create a task

The first step is to write a function and turn it into a **task**. Tasks are functions that CutiePy can run in the background.

Open your code editor and create a new file called `cutie.py`. In your file, define a task that you want to run in the background. Copy the this code into your file:

```python title="cutie.py"
import time
from cutiepy import CutiePy

cutie = CutiePy(mode="dev")

@cutie.task
def bake_a_pie(flavor, recipient):
    time.sleep(3)
    print(f"Your {flavor} pie for {recipient} is ready!")

```

This file contains an instance of CutiePy called `cutie` that is optimized for local development.

The `@cutie.task` is a _function decorator_ that turns the function into a CutiePy task. Now, `bake_a_pie` is both a function _and_ a CutiePy task. You can run it just like any old function, but it will take 3 seconds to run because it runs in the _foreground_.

```python title="In a Python program"
>>> bake_a_pie("apple", "Alice")
# Waits for 3 seconds...
"Your apple pie for Alice is ready!"
```

In the next steps, you will learn to run the task `bake_a_pie` in the background. Learn more about [tasks](#) in our documentation.

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
