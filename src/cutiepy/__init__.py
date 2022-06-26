import sys
from typing import NoReturn

from cutiepy.cli import cutiepy_cli_group


def main() -> NoReturn:
    sys.exit(cutiepy_cli_group())
