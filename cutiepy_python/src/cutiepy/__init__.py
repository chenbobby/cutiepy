import base64
import importlib
import pathlib
import subprocess
import sys
import time
from datetime import datetime
from typing import Any, Callable, Dict, List, NoReturn, Optional

import click
import pickle5 as pickle
import requests

from cutiepy.__version__ import __version__


def main() -> None:
    cutiepy_cli_group()


class Registry:
    _broker_url: str
    _function_key_to_function: Dict[str, Callable]

    def __init__(self, broker_url: str = "http://localhost:9000") -> None:
        self._broker_url = broker_url
        self._function_key_to_function = {}

    def __getitem__(self, function_key: str) -> Callable:
        return self._function_key_to_function[function_key]

    def __setitem__(self, function_key: str, function: Callable) -> None:
        self._function_key_to_function[function_key] = function

    def __delitem__(self, function_key: str) -> None:
        del self._function_key_to_function[function_key]

    def __contains__(self, function_key: str) -> bool:
        return function_key in self._function_key_to_function

    def enqueue_job(
        self,
        registered_function: "RegisteredFunction",
        *,
        args: List = [],
        kwargs: Dict = {},
        job_timeout_ms: Optional[int] = None,
        job_run_timeout_ms: Optional[int] = None,
    ) -> None:
        """
        `enqueue_job` enqueues a job to execute `registered_function` with
        positional arguments `args` and keyword arguments `kwargs`.
        """
        function_key = registered_function.function_key
        if function_key not in self:
            raise RuntimeError(
                f"function with key {function_key} is not registered!",
            )

        if job_timeout_ms is not None:
            assert job_timeout_ms >= 0

        if job_run_timeout_ms is not None:
            assert job_run_timeout_ms >= 0

        response = requests.post(
            url=f"{self._broker_url}/api/enqueue_job",
            json={
                "job_function_key": function_key,
                "job_args_serialized": _serialize(args),
                "job_kwargs_serialized": _serialize(kwargs),
                "job_args_repr": [repr(arg) for arg in args],
                "job_kwargs_repr": {repr(k): repr(v) for k, v in kwargs.items()},
                "job_timeout_ms": job_timeout_ms,
                "job_run_timeout_ms": job_run_timeout_ms,
            },
        )
        assert response.ok

    def create_scheduled_job(
        self,
        registered_function: "RegisteredFunction",
        *,
        enqueue_after: datetime,
        args: List = [],
        kwargs: Dict = {},
        job_timeout_ms: Optional[int] = None,
        job_run_timeout_ms: Optional[int] = None,
    ) -> None:
        """
        `create_scheduled_job` will schedule a job to be enqueued after
        `enqueue_after`.
        """
        function_key = registered_function.function_key
        if function_key not in self:
            raise RuntimeError(
                f"function with key {function_key} is not registered!",
            )

        if job_timeout_ms is not None:
            assert job_timeout_ms >= 0

        if job_run_timeout_ms is not None:
            assert job_run_timeout_ms >= 0

        response = requests.post(
            url=f"{self._broker_url}/api/create_scheduled_job",
            json={
                "enqueue_after": enqueue_after.isoformat(),
                "function_key": function_key,
                "args_serialized": _serialize(args),
                "kwargs_serialized": _serialize(kwargs),
                "args_repr": [repr(arg) for arg in args],
                "kwargs_repr": {repr(k): repr(v) for k, v in kwargs.items()},
                "job_timeout_ms": job_timeout_ms,
                "job_run_timeout_ms": job_run_timeout_ms,
            },
        )
        assert response.ok

    def create_recurring_job(
        self,
        registered_function: "RegisteredFunction",
        *,
        start_after: datetime,
        interval_ms: int,
        args: List = [],
        kwargs: Dict = {},
        job_timeout_ms: Optional[int] = None,
        job_run_timeout_ms: Optional[int] = None,
    ) -> None:
        """
        `create_recurring_job` creates a recurring job. The job will be first
        started after `start_after` and then create_recurrings every
        `interval_ms`.
        """
        function_key = registered_function.function_key
        if function_key not in self:
            raise RuntimeError(
                f"function with key {function_key} is not registered!",
            )

        assert interval_ms >= 0

        if job_timeout_ms is not None:
            assert job_timeout_ms >= 0

        if job_run_timeout_ms is not None:
            assert job_run_timeout_ms >= 0

        response = requests.post(
            url=f"{self._broker_url}/api/create_recurring_job",
            json={
                "start_after": start_after.isoformat(),
                "interval_ms": interval_ms,
                "function_key": function_key,
                "args_serialized": _serialize(args),
                "kwargs_serialized": _serialize(kwargs),
                "args_repr": [repr(arg) for arg in args],
                "kwargs_repr": {repr(k): repr(v) for k, v in kwargs.items()},
                "job_timeout_ms": job_timeout_ms,
                "job_run_timeout_ms": job_run_timeout_ms,
            },
        )
        assert response.ok

    def job(
        self,
        function: Callable,
    ) -> "RegisteredFunction":
        """
        `job` registers `function` in the Registry.
        """
        function_key = _function_key(function)
        self[function_key] = function
        return RegisteredFunction(registry=self, function=function)


class RegisteredFunction:
    _registry: Registry
    _function: Callable

    def __init__(self, registry: Registry, function: Callable) -> None:
        self._registry = registry
        self._function = function  # type: ignore

    def __call__(self, *args: Any, **kwargs: Any) -> Any:
        return self._function(*args, **kwargs)

    @property
    def function_key(self) -> str:
        return _function_key(self._function)

    def enqueue_job(
        self,
        *,
        args: List = [],
        kwargs: Dict = {},
        job_timeout_ms: Optional[int] = None,
        job_run_timeout_ms: Optional[int] = None,
    ) -> None:
        """
        `enqueue_job` enqueues a job to execute `registered_function` with
        positional arguments `args` and keyword arguments `kwargs`.
        """
        if job_timeout_ms is not None:
            assert job_timeout_ms >= 0

        if job_run_timeout_ms is not None:
            assert job_run_timeout_ms >= 0

        return self._registry.enqueue_job(
            registered_function=self,
            args=args,
            kwargs=kwargs,
            job_timeout_ms=job_timeout_ms,
            job_run_timeout_ms=job_run_timeout_ms,
        )

    def create_scheduled_job(
        self,
        *,
        enqueue_after: datetime,
        args: List = [],
        kwargs: Dict = {},
        job_timeout_ms: Optional[int] = None,
        job_run_timeout_ms: Optional[int] = None,
    ) -> None:
        """
        `create_scheduled_job` will schedule a job to be enqueued after
        `enqueue_after`.
        """
        if job_timeout_ms is not None:
            assert job_timeout_ms >= 0

        if job_run_timeout_ms is not None:
            assert job_run_timeout_ms >= 0

        return self._registry.create_scheduled_job(
            registered_function=self,
            enqueue_after=enqueue_after,
            args=args,
            kwargs=kwargs,
            job_timeout_ms=job_timeout_ms,
            job_run_timeout_ms=job_run_timeout_ms,
        )

    def create_recurring_job(
        self,
        *,
        start_after: datetime,
        interval_ms: int,
        args: List = [],
        kwargs: Dict = {},
        job_timeout_ms: Optional[int] = None,
        job_run_timeout_ms: Optional[int] = None,
    ) -> None:
        """
        `create_recurring_job` creates a recurring job. The job will be first
        started after `start_after` and then create_recurrings every
        `interval_ms`.
        """
        assert interval_ms >= 0

        if job_timeout_ms is not None:
            assert job_timeout_ms >= 0

        if job_run_timeout_ms is not None:
            assert job_run_timeout_ms >= 0

        return self._registry.create_recurring_job(
            registered_function=self,
            start_after=start_after,
            interval_ms=interval_ms,
            args=args,
            kwargs=kwargs,
            job_timeout_ms=job_timeout_ms,
            job_run_timeout_ms=job_run_timeout_ms,
        )


def _function_key(function: Callable) -> str:
    module_name = function.__module__
    if module_name == "__main__":
        # The module name of `function` is "__main__", which indicates
        # that the module is a Python file. In order for CutiePy workers
        # to find the `function`, "__main__" must be replaced with the
        # Python file's name.
        import __main__

        file_name = pathlib.Path(__main__.__file__).stem
        module_name = module_name.replace("__main__", file_name)

    return f"{module_name}.{function.__name__}"


def _import_registry_from_string(import_str: str) -> "Registry":
    module_str, _, attrs_str = import_str.partition(":")
    if not module_str or not attrs_str:
        raise RuntimeError(
            f"""
            Your Registry's Import string {import_str} must be in the format
            '<module>:<attribute>'
            """
        )

    try:
        module = importlib.import_module(module_str)
    except ImportError as exc:
        if exc.name != module_str:
            raise exc from None
        raise RuntimeError(f"Could not import module '{module_str}'")

    instance: Any = module
    try:
        for attr_str in attrs_str.split("."):
            instance = getattr(instance, attr_str)
    except AttributeError:
        raise RuntimeError(
            f"""
            Attribute '{attrs_str} not found in module '{module_str}'
            """
        )

    return instance


def _serialize(x: Any) -> str:
    x_pickled: bytes = pickle.dumps(x, protocol=pickle.HIGHEST_PROTOCOL)
    x_encoded: bytes = base64.b64encode(x_pickled)
    return x_encoded.decode()


def _deserialize(x_encoded: str) -> Any:
    x_pickled: bytes = base64.b64decode(x_encoded, validate=True)
    return pickle.loads(x_pickled)


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
    return _broker_migrate()


def _broker_migrate():
    migrate_bin_path = pathlib.Path(__file__).parent.joinpath(
        "../../cutiepy_broker/_build/prod/rel/cutiepy_broker/bin/migrate"
    )
    database_path = f"{str(pathlib.Path.cwd())}/cutiepy.db"
    return subprocess.call(
        [migrate_bin_path],
        env={
            "DATABASE_PATH": database_path,
        },
    )


@broker_cli_group.command(name="run", help="Starts a broker.")
def broker_run_command() -> int:
    server_bin_path = pathlib.Path(__file__).parent.joinpath(
        "../../cutiepy_broker/_build/prod/rel/cutiepy_broker/bin/server"
    )

    database_path = f"{str(pathlib.Path.cwd())}/cutiepy.db"
    if not pathlib.Path(database_path).is_file():
        _broker_migrate()

    return subprocess.call(
        [server_bin_path],
        env={
            "DATABASE_PATH": database_path,
        },
    )


@cutiepy_cli_group.command(name="worker", help="Starts worker(s) to run jobs.")
@click.option("-bu", "--broker-url", type=str, default="http://localhost:9000")
def worker_command(broker_url: str) -> NoReturn:
    response = requests.post(url=f"{broker_url}/api/register_worker")
    assert response.ok

    print(f"Connected to broker at {broker_url}")
    response_body = response.json()
    worker_id = response_body["worker_id"]
    print(f"Worker ID {worker_id}")

    sys.path.insert(0, str(pathlib.Path.cwd()))
    import_str = "cutie:registry"
    registry = _import_registry_from_string(import_str)

    while True:
        response = requests.post(
            url=f"{broker_url}/api/assign_job_run",
            json={"worker_id": worker_id},
        )
        assert response.ok

        if response.status_code == requests.codes.NO_CONTENT:
            time.sleep(0.1)
            continue

        print("Assigned a job!")

        response_body = response.json()

        exception: Optional[Exception] = None
        job_run_id = response_body["job_run_id"]
        job_function_key = response_body["job_function_key"]

        try:
            function = registry[job_function_key]
        except KeyError:
            print(f"Error: Function key {job_function_key} is not in registry.")
            exception = RuntimeError(
                f"Function key {job_function_key} is not in the CutiePy registry."
            )
            response = requests.post(
                url=f"{broker_url}/api/fail_job_run",
                json={
                    "job_run_id": job_run_id,
                    "job_run_exception_serialized": _serialize(exception),
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

        job_args_serialized = response_body["job_args_serialized"]
        job_kwargs_serialized = response_body["job_kwargs_serialized"]
        args = _deserialize(job_args_serialized)
        kwargs = _deserialize(job_kwargs_serialized)

        result = None
        try:
            result = function(*args, **kwargs)
        except Exception as e:
            exception = e

        if exception is not None:
            print(f"Error: {exception}")
            response = requests.post(
                url=f"{broker_url}/api/fail_job_run",
                json={
                    "job_run_id": job_run_id,
                    "job_run_exception_serialized": _serialize(exception),
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
                "job_run_result_serialized": _serialize(result),
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
