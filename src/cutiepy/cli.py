import pathlib
import subprocess

import click

from cutiepy.__version__ import __version__


@click.group(name="cutiepy")
@click.help_option("-h", "--help")
@click.version_option(__version__, "-v", "--version")
def cutiepy_cli_group() -> int:
    pass


@cutiepy_cli_group.group(name="broker")
def broker_cli_group() -> int:
    pass


@broker_cli_group.command(name="migrate")
def broker_migrate_command() -> int:
    path = pathlib.Path(__file__).parent.joinpath(
        "../../cutiepy_broker/_build/prod/rel/cutiepy_broker/bin/migrate"
    )
    return subprocess.call(path)


@broker_cli_group.command(name="run")
def broker_run_command() -> int:
    pass
