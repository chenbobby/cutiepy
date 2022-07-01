import pathlib
from typing import Any, Callable, Dict, List, Optional

import requests

from cutiepy.cli import cutiepy_cli_group
from cutiepy.serde import serialize


def main() -> None:
    cutiepy_cli_group()


class Registry:
    _broker_url: str
    _function_key_to_function: Dict[str, Callable]

    def __init__(self, broker_url: str) -> None:
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
    ) -> str:
        """
        `enqueue` enqueues a job to execute `registered_function` with
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

        response: requests.Response = requests.post(
            url=f"{self._broker_url}/api/enqueue_job",
            json={
                "job_function_key": function_key,
                "job_args_serialized": serialize(args),
                "job_kwargs_serialized": serialize(kwargs),
                "job_args_repr": [repr(arg) for arg in args],
                "job_kwargs_repr": {repr(k): repr(v) for k, v in kwargs.items()},
                "job_timeout_ms": job_timeout_ms,
                "job_run_timeout_ms": job_run_timeout_ms,
            },
        )
        response_body = response.json()
        return response_body["job_id"]

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
    ) -> str:
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
