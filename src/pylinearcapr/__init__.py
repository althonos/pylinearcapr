# noqa: D104
from . import _linearcapr
from ._linearcapr import (
    Context,
    Profile,
    StructuralProfiler,
)

__doc__ = _linearcapr.__doc__
__version__ = _linearcapr.__version__
__all__ = [
    "Context",
    "Profile",
    "StructuralProfiler",
]

__author__ = "Martin Larralde <martin.larralde@idiap.ch>"
__license__ = "MIT"
