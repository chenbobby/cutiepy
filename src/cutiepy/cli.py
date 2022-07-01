import importlib
import pathlib
import subprocess
import time
from typing import NoReturn, Optional

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
    response = requests.post(url=f"{broker_url}/api/register_worker")
    assert response.ok

    print(f"Connected to broker at {broker_url}")
    response_body = response.json()
    worker_id = response_body["worker_id"]
    print(f"Worker ID {worker_id}")

    module = importlib.import_module("cutie")
    registry = getattr(module, "registry")

    while True:
        response = requests.post(
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

        exception: Optional[Exception] = None
        job_run_id = response_body["job_run_id"]
        function_key = response_body["job_function_key"]
        if function_key not in registry:
            print(f"Error: Callable key {function_key} is not in registry.")
            exception = RuntimeError(
                f"Callable key {function_key} is not in the CutiePy registry."
            )
            response = requests.post(
                url=f"{broker_url}/api/fail_job_run",
                json={
                    "job_run_id": job_run_id,
                    "job_run_exception_serialized": serialize(exception),
                    "job_run_exception_repr": repr(exception),
                    "worker_id": worker_id,
                },
            )
            if response.status_code == requests.codes.CONFLICT:
                response_body = response.json()
                error = response_body["error"]
                print(f"Unable to fail the job run: {error}")
                continue

            assert response.ok
            continue

        function_ = registry[function_key]
        args = deserialize(response_body["job_args_serialized"])
        kwargs = deserialize(response_body["job_kwargs_serialized"])

        result = None
        try:
            result = function_(*args, **kwargs)
        except Exception as e:
            exception = e

        if exception is not None:
            print(f"Error: {exception}")
            response = requests.post(
                url=f"{broker_url}/api/fail_job_run",
                json={
                    "job_run_id": job_run_id,
                    "job_run_exception_serialized": serialize(exception),
                    "job_run_exception_repr": repr(exception),
                    "worker_id": worker_id,
                },
            )
            if response.status_code == requests.codes.CONFLICT:
                response_body = response.json()
                error = response_body["error"]
                print(f"Unable to fail the job run: {error}")
                continue

            assert response.ok
            continue

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
            print(f"Unable to complete the job run: {error}")
            continue

        assert response.ok
