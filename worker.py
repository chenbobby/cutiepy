import importlib

from cutiepy.serde import deserialize

job_run = {
    "callable_key": "cutie._cutiepy_cli_group",
    "args_serialized": "gAVdlC4=",
    "kwargs_serialized": "gAV9lC4=",
}

module = importlib.import_module("cutie")
registry = getattr(module, "registry")

function = registry[job_run["callable_key"]]
args = deserialize(job_run["args_serialized"])
kwargs = deserialize(job_run["kwargs_serialized"])
result = function(*args, **kwargs)
print(result)
