import base64
from typing import Any

import pickle5 as pickle


def serialize(x: Any) -> str:
    x_pickled: bytes = pickle.dumps(x, protocol=pickle.HIGHEST_PROTOCOL)
    x_encoded: bytes = base64.b64encode(x_pickled)
    return x_encoded.decode()


def deserialize(x_encoded: str) -> Any:
    x_pickled: bytes = base64.b64decode(x_encoded, validate=True)
    return pickle.loads(x_pickled)
