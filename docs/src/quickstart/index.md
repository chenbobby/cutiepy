```{toctree}
```

# Quickstart

**1. Install CutiePy.**

````{tab} pip
In your terminal, run the following command:

```console
$ pip install cutiepy
```
````

````{tab} conda
In your terminal, run the following command:

```console
$ conda install cutiepy
```
````

<br/>

**2. Start a Broker server.**

In your terminal, run the following command:

```console
$ cutiepy broker run
```

<br/>

**3. Create a job.**

Create a script called `cutie.py`.

```{code-block} python
:caption: "`cutie.py`"

import cutiepy

registry = cutiepy.Registry()

@registry.job
def bake_a_pie(flavor):
    return f"{flavor} pie"

if __name__ == "__main__":
    registry.enqueue_job(bake_a_pie, ["apple"])
```

Open a new terminal and run your script.

```console
$ python cutie.py
```

**4. Start a Worker process.**

In your terminal, run the following command:

```console
$ cutiepy worker run
```

**5. View the result in the Web UI.**

Open your browser to [http://localhost:9000](http://localhost:9000).
