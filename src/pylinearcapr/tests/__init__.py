# noqa: D104

from . import (
    test_doctest,
    test_profiler,
)


def load_tests(loader, suite, pattern):
    suite.addTests(loader.loadTestsFromModule(test_doctest))
    suite.addTests(loader.loadTestsFromModule(test_profiler))
    return suite
