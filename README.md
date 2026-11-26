# PyLinearCapR [![Stars](https://img.shields.io/github/stars/althonos/pylinearcapr.svg?style=social&maxAge=3600&label=Star)](https://github.com/althonos/pylinearcapr/stargazers)

*[Cython](https://cython.org/) bindings and Python interface to [LinearCapR](https://github.com/hoget157/LinearCapR), a fast method to compute structural-context probabilities for RNA nucleotides.*

[![Actions](https://img.shields.io/github/actions/workflow/status/althonos/pylinearcapr/test.yml?branch=main&logo=github&style=flat-square&maxAge=300)](https://github.com/althonos/pylinearcapr/actions)
[![Coverage](https://img.shields.io/codecov/c/gh/althonos/pylinearcapr?style=flat-square&maxAge=3600&logo=codecov)](https://codecov.io/gh/althonos/pylinearcapr/)
[![License](https://img.shields.io/badge/license-GPLv3-blue.svg?style=flat-square&maxAge=2678400)](https://choosealicense.com/licenses/gpl-3.0/)
[![PyPI](https://img.shields.io/pypi/v/pylinearcapr.svg?style=flat-square&maxAge=3600&logo=PyPI)](https://pypi.org/project/pylinearcapr)
[![Bioconda](https://img.shields.io/conda/vn/bioconda/pylinearcapr?style=flat-square&maxAge=3600&logo=anaconda)](https://anaconda.org/bioconda/pylinearcapr)
[![AUR](https://img.shields.io/aur/version/python-pylinearcapr?logo=archlinux&style=flat-square&maxAge=3600)](https://aur.archlinux.org/packages/python-pylinearcapr)
[![Wheel](https://img.shields.io/pypi/wheel/pylinearcapr.svg?style=flat-square&maxAge=3600)](https://pypi.org/project/pylinearcapr/#files)
[![Python Versions](https://img.shields.io/pypi/pyversions/pylinearcapr.svg?style=flat-square&maxAge=600&logo=python)](https://pypi.org/project/pylinearcapr/#files)
[![Python Implementations](https://img.shields.io/pypi/implementation/pylinearcapr.svg?style=flat-square&maxAge=600&label=impl)](https://pypi.org/project/pylinearcapr/#files)
[![Source](https://img.shields.io/badge/source-GitHub-303030.svg?maxAge=2678400&style=flat-square)](https://github.com/althonos/pylinearcapr/)
[![Mirror](https://img.shields.io/badge/mirror-Codeberg-2185d0?style=flat-square&maxAge=2678400)](https://codeberg.org/althonos/pylinearcapr)
[![Issues](https://img.shields.io/github/issues/althonos/pylinearcapr.svg?style=flat-square&maxAge=600)](https://github.com/althonos/pylinearcapr/issues)
[![Docs](https://img.shields.io/readthedocs/pylinearcapr/latest?style=flat-square&maxAge=600)](https://pylinearcapr.readthedocs.io)
[![Changelog](https://img.shields.io/badge/keep%20a-changelog-8A0707.svg?maxAge=2678400&style=flat-square)](https://github.com/althonos/pylinearcapr/blob/main/CHANGELOG.md)
[![Downloads](https://img.shields.io/badge/dynamic/regex?url=https%3A%2F%2Fpepy.tech%2Fprojects%2Fpylinearcapr&search=%5B0-9%5D%2B.%5B0-9%5D%2B(k%7CM)&style=flat-square&label=downloads&color=303f9f&cacheSeconds=86400)](https://pepy.tech/project/pylinearcapr)


## 🗺️ Overview

[LinearCapR](https://github.com/hoget157/LinearCapR) is a fast method by
Otagaki _et al._ [\[1\]](#ref1) for linear-time computation of per-nucleotide structural-context probabilities of RNA. 

PyLinearCapR is a Python module that provides bindings to LinearCapR `v1.0`
using [Cython](https://cython.org/). It implements a user-friendly, Pythonic
interface to profile sequences and output probability arrays, which has the
following advantage:

- **single dependency**: PyLinearCapR is distributed as a Python package, so 
  you can add it as a dependency to your project, and stop worrying about the
  LinearCapR binaries being present on the end-user machine.
- **no intermediate files**: Everything happens in memory, through Python 
  objects you control, so you don't have to invoke the LinearCapR CLI using a
  sub-process and temporary files.
- **transparent output**: The per-nucleotide structural-context probabilities
  are returned into an array that can be immediately used with popular scientific
  libraries such as NumPy or PyTorch.

## 🔧 Installing

PyLinearCapR can be installed directly from [PyPI](https://pypi.org/project/pylinearcapr/),
which hosts some pre-built wheels for common architectures & operating systems,
as well as the code required to compile from source with Cython:

```console
$ pip install pylinearcapr
```

<!-- PyLinearCapR is also available as a [Bioconda](https://bioconda.github.io/)
package:
```console
$ conda install -c bioconda pylinearcapr
```

Otherwise, have a look at the [Installation page](https://pylinearcapr.readthedocs.io/en/stable/guide/install.html) 
of the [online documentation](https://pylinearcapr.readthedocs.io/) -->

## 💡 Example

Let's use the Python interface to compute per-nucleotide structural-context 
probabilities for a sequence stored in a Python string:

```python
import pylinearcapr

seq = "ACGCUGUCUGUACUUGUAUCAGUACACUGACGAGUCCCUAAAGGACGAAACAGCGC"

profiler = pylinearcapr.StructuralProfiler()    # profiler with default parameters
profile = profiler.profile(sequence)            # run LinearCapR on a text profile

print("free energy: ", profile.free_energy)
print("consensus: ", profile.consensus())
print("probabilities: ", profile.matrix)        # matrix of shape (6, seq_len)
```

The probability matrix implements the buffer protocol, so you can turn it 
transparently into a NumPy array without copying the underlying:

```python
probabilities = numpy.asarray(profile.matrix)
probabilities.sum(axis=0)  # should be 1.0 at every position
```

## 🧶 Thread-safety

`pylinearcapr.StructuralProfiler` instances are thread-safe, and the 
`profile` method is re-entrant. This is handled by allocating new working
buffers for every input, which may be unefficient and prevents memory 
re-use; a future plan is to use thread-local storage instead to re-use
memory within a worker thread.

You can use a pool to process sequences in parallel, for instance:
```python
import multiprocessing.pool
import pylinearcapr

profiler = pylinearcapr.StructuralProfiler()

with multiprocessing.pool.ThreadPool() as pool:
    profiles = pool.map(profiler.profile, sequences)
```

<!-- ## ⏱️ Benchmarks -->

<!-- ## 🔎 See Also -->

## 💭 Feedback

### ⚠️ Issue Tracker

Found a bug ? Have an enhancement request ? Head over to the 
[GitHub issue tracker](https://github.com/althonos/pylinearcapr/issues)
if you need to report or ask something. If you are filing in on a bug,
please include as much information as you can about the issue, and try to
recreate the same bug in a simple, easily reproducible situation.


### 🏗️ Contributing

Contributions are more than welcome! See
[`CONTRIBUTING.md`](https://github.com/althonos/pylinearcapr/blob/main/CONTRIBUTING.md)
for more details.


## 📋 Changelog

This project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html)
and provides a [changelog](https://github.com/althonos/pylinearcapr/blob/main/CHANGELOG.md)
in the [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) format.


## ⚖️ License

This library is provided under the [MIT License](https://choosealicense.com/licenses/mit/). 
CD-HIT is developed by [Takumi Otagaki](https://github.com/hoget157)
and is distributed under the terms of the [MIT License](https://choosealicense.com/licenses/mit/) as well. 
See `vendor/LinearCapR/LICENSE` for more information.

*This project is in no way not affiliated, sponsored, or otherwise endorsed
by the [LinearCapR authors](https://github.com/hoget157). It was developed
by [Martin Larralde](https://github.com/althonos/) during his post-doctoral 
project at the [Idiap Research Institute](https://idiap.ch/en) in
the [Human-Centered Health AI](https://idiap.ch/en/research/groups/human-centered-health-ai) group.*


## 📚 References

- <a id="ref1">\[1\]</a> Takumi Otagaki, Hiroaki Hosokawa, Tsukasa Fukunaga, Junichi Iwakiri, Goro Terai, Kiyoshi Asai, LinearCapR: linear-time computation of per-nucleotide structural-context probabilities of RNA without base-pair span limits, _Bioinformatics_, Volume 42, Issue 6, June 2026, btag295, [doi:10.1093/bioinformatics/btag295](https://doi.org/10.1093/bioinformatics/btag295).



