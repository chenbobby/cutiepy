import importlib
import pathlib
import subprocess
import time
import uuid
from typing import NoReturn

import click
import requests

from cutiepy.__version__ import __version__
from cutiepy.serde import deserialize, serialize


@click.group(name="cutiepy")
@click.help_option("-h", "--help")
@click.version_option(__version__, "-v", "--version")
def cutiepy_cli_group() -> int:
    pass


@cutiepy_cli_group.group(name="broker")
def broker_cli_group() -> int:
    pass


@broker_cli_group.command(
    name="migrate", help="Applies database migrations for a broker."
)
def broker_migrate_command() -> int:
    path = pathlib.Path(__file__).parent.joinpath(
        "../../cutiepy_broker/_build/prod/rel/cutiepy_broker/bin/migrate"
    )
    return subprocess.call(path)


@broker_cli_group.command(name="run", help="Starts a broker.")
def broker_run_command() -> int:
    path = pathlib.Path(__file__).parent.joinpath(
        "../../cutiepy_broker/_build/prod/rel/cutiepy_broker/bin/server"
    )
    return subprocess.call(path)


@cutiepy_cli_group.command(name="worker", help="Starts worker(s) to run jobs.")
@click.option("-bu", "--broker-url", type=str, default="http://localhost:4000")
def worker_command(broker_url: str) -> NoReturn:
    worker_id = str(uuid.uuid4())
    module = importlib.import_module("cutie")
    registry = getattr(module, "registry")
    while True:
        response: requests.Response = requests.post(
            url=f"{broker_url}/api/assign_job_run",
            json={"worker_id": worker_id},
        )
        assert response.ok

        if response.status_code == requests.codes.NO_CONTENT:
            print("No jobs are ready. Sleeping...")
            time.sleep(0.5)
            continue

        print("Assigned a job!")

        response_body = response.json()
        job_run_id = response_body["job_run_id"]
        callable_key = response_body["job_callable_key"]
        callable_ = registry[callable_key]
        args = deserialize(response_body["job_args_serialized"])
        kwargs = deserialize(response_body["job_kwargs_serialized"])

        result = callable_(*args, **kwargs)
        print(f"Result: {result}")

        response = requests.post(
            url=f"{broker_url}/api/complete_job_run",
            json={
                "job_run_id": job_run_id,
                "job_run_result_serialized": serialize(result),
                "job_run_result_repr": repr(result),
                "worker_id": worker_id,
            },
        )

        if response.status_code == requests.codes.CONFLICT:
            response_body = response.json()
            error = response_body["error"]
            print(f"Failed to complete the job run: {error}")
            continue

        assert response.ok
