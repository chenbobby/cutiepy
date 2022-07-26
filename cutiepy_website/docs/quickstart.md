---
sidebar_position: 2
title: Quickstart
---

import Link from '@docusaurus/Link';
import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Quickstart

Welcome to the CutiePy Quickstart guide.

### 1. Install CutiePy.

<Tabs>
  <TabItem value="pip" label="pip" default>

Run the following command in your terminal:

``` console
$ pip install cutiepy
```

  </TabItem>
  <TabItem value="conda" label="conda">

Run the following command in your terminal:

``` console
$ conda install cutiepy
```

  </TabItem>
</Tabs>

### 2. Start a Broker server.

Run the following command in your terminal:

``` console
$ cutiepy broker start
```

### 3. Create a job.

Create a new Python script called `cutie.py`.

``` python title="cutie.py"
import cutiepy

registry = cutiepy.Registry()

@registry.job
def bake_a_pie(flavor):
    return f"{flavor} pie"

if __name__ == "__main__":
    registry.enqueue_job(bake_a_pie, ["apple"])

```

Then, open a new terminal and run your Python script.

``` console
$ python cutie.py
```

### 4. Start a Worker process.

Run the following command in your terminal:

``` console
$ cutiepy worker start
```

### 5. View your results in the Web UI.

Open your browser to [http://localhost:9000](http://localhost:9000).

![Web UI Screenshot](#TODO)

## Next Steps
