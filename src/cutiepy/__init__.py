import pathlib
import sys
from typing import Any, Callable, Dict, List, NoReturn

import requests

from cutiepy.cli import cutiepy_cli_group
from cutiepy.serde import serialize


def main() -> NoReturn:
    sys.exit(cutiepy_cli_group())


class Registry:
    _broker_url: str
    _callable_key_to_callable: Dict[str, Callable]

    def __init__(self, broker_url: str) -> None:
        self._broker_url = broker_url
        self._callable_key_to_callable = {}

    def __getitem__(self, callable_key: str) -> Callable:
        return self._callable_key_to_callable[callable_key]

    def __setitem__(self, callable_key: str, callable_: Callable) -> None:
        self._callable_key_to_callable[callable_key] = callable_

    def __delitem__(self, callable_key: str) -> None:
        del self._callable_key_to_callable[callable_key]

    def __contains__(self, callable_key: str) -> bool:
        return callable_key in self._callable_key_to_callable

    def enqueue(
        self,
        callable_: Callable,
        args: List = [],
        kwargs: Dict = {},
    ) -> str:
        """
        `enqueue` enqueues a job to execute `callable` with positional
        arguments `args` and keyword arguments `kwargs`.
        """
        callable_key = _callable_key(callable_)
        if callable_key not in self:
            raise RuntimeError(
                f"callable with key {callable_key} is not registered!",
            )

        job = {
            "callable_key": callable_key,
            "args_serialized": serialize(args),
            "kwargs_serialized": serialize(kwargs),
        }

        response: requests.Response = requests.post(
            url=f"{self._broker_url}/api/enqueue_job",
            json={"job": job},
        )
        response_body = response.json()
        return response_body["job"]["job_id"]

    def job(
        self,
        callable_: Callable,
    ) -> "Job":
        """
        `job` adds `callable` into the CutiePy registry.
        """
        callable_key = _callable_key(callable_)
        self[callable_key] = callable_
        return Job(registry=self, callable_=callable_)


class Job:
    _registry: Registry
    _callable: Callable

    def __init__(self, registry: Registry, callable_: Callable) -> None:
        self._registry = registry
        self._callable = callable_  # type: ignore

    def __call__(self, *args: Any, **kwargs: Any) -> Any:
        return self._callable(*args, **kwargs)

    def enqueue(self, args: List = [], kwargs: Dict = {}) -> str:
        return self._registry.enqueue(
            callable_=self._callable,
            args=args,
            kwargs=kwargs,
        )


def _callable_key(callable_: Callable) -> str:
    module_name = callable_.__module__
    if module_name == "__main__":
        # The module name of `callable_` is "__main__", which indicates
        # that the module is a Python file. In order for CutiePy workers
        # to find the `callable_`, "__main__" must be replaced with the
        # Python file's name.
        import __main__

        file_name = pathlib.Path(__main__.__file__).stem
        module_name = module_name.replace("__main__", file_name)

    return f"{module_name}.{callable_.__name__}"
