import dataclasses
import sys
from typing import Callable, Dict, List, NoReturn

import requests

from cutiepy.cli import cutiepy_cli_group
from cutiepy.serde import serialize


def main() -> NoReturn:
    sys.exit(cutiepy_cli_group())


@dataclasses.dataclass
class CutiePy:
    broker_url: str

    def enqueue(
        self,
        function: Callable,
        args: List = [],
        kwargs: Dict = {},
    ) -> str:
        job = {
            "function_serialized": serialize(function),
            "args_serialized": serialize(args),
            "kwargs_serialized": serialize(kwargs),
        }
        response: requests.Response = requests.post(
            url=f"{self.broker_url}/api/enqueue_job",
            json={"job": job},
        )
        response_body = response.json()
        return response_body["job"]["job_id"]
