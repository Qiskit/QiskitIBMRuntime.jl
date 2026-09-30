[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://qiskit.github.io/QiskitIBMRuntime.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://qiskit.github.io/QiskitIBMRuntime.jl/dev/)
[![Qiskit Ecosystem](https://qisk.it/e-bcde78a1)](https://qisk.it/ecosystem)
[![Build Status](https://github.com/Qiskit/QiskitIBMRuntime.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/Qiskit/QiskitIBMRuntime.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://coveralls.io/repos/github/Qiskit/QiskitIBMRuntime.jl/badge.svg?branch=main)](https://coveralls.io/github/Qiskit/QiskitIBMRuntime.jl?branch=main)
[![PkgEval](https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/Q/Qiskit.svg)](https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/Q/Qiskit.html)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

# QiskitIBMRuntime.jl

This package allows you to execute circuits on a quantum computer from the [Julia programming language](https://julialang.org/) using the Qiskit IBM Runtime service.  It builds on [Qiskit.jl](https://github.com/Qiskit/Qiskit.jl) and provides a lightweight Julia wrapper of the [qiskit-ibm-runtime-c](https://github.com/Qiskit/qiskit-ibm-runtime-c) client.

> [!NOTE]
> This package was formerly known as QiskitIBMRuntimeC.jl.

## Example

The following example constructs a circuit that generates a [Bell state](https://en.wikipedia.org/wiki/Bell_state). It transpiles and submits that circuit to the least busy quantum backend. When the job is done, it displays the results.

```julia
using Qiskit
using Qiskit.Operations
using QiskitIBMRuntime
using StatsBase

function generate_bell_circuit()
    qc = QuantumCircuit(2, 2) # 2 qubits, 2 clbits
    h!(qc, 1)
    cx!(qc, 1, 2)
    measure!(qc, 1, 1)
    measure!(qc, 2, 2)
    qc
end

service = Service()
search_results = backend_search(service)
backend = least_busy(search_results)
@show backend.name
target = target_from_backend(backend, service)

qc = generate_bell_circuit()

transpiled_circuit, layout = transpile(qc, target)
@show transpiled_circuit.num_instructions

shots = 1024
job = run_sampler_job(service, backend, transpiled_circuit, shots)
samples = get_sampler_job_results(job, service)

# Display the first 20 samples
@show samples[1:20]

# Show counts
@show countmap(samples)
```

When run with the [appropriate credentials](https://github.com/Qiskit/qiskit-ibm-runtime?tab=readme-ov-file#qiskit-runtime-service-on-the-new-ibm-quantum-platform-ibm-cloud) to access quantum hardware, the above code may generate output similar to the following:

```
backend.name = "ibm_fez"
transpiled_circuit.num_instructions = 10
samples[1:20] = BitVector[[1, 1], [0, 0], [1, 1], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [1, 1], [0, 0], [1, 1], [1, 1], [0, 0], [0, 0], [1, 1], [0, 0], [0, 0], [0, 1], [0, 0], [1, 1]]
countmap(samples) = Dict{BitVector, Int64}([0, 1] => 14, [0, 0] => 518, [1, 1] => 446, [1, 0] => 46)
```

## Installation instructions

### Install Julia

The official install instructions are at https://julialang.org/install/.

If you are a Rust user, you may choose to obtain `juliaup` via `cargo`.

```sh
cargo install juliaup
juliaup add release
```

### Install `QiskitIBMRuntime.jl`

#### Latest stable release

Type `] add QiskitIBMRuntime` in the Julia REPL, or run the following command:

```sh
julia -e 'using Pkg; pkg"add QiskitIBMRuntime"'
```

#### Development version

Type `] dev QiskitIBMRuntime` in the Julia REPL, or run the following command:

```sh
julia -e 'using Pkg; pkg"dev QiskitIBMRuntime"'
```

Afterward, the repository will be cloned to `~/.julia/dev/QiskitIBMRuntime`.

## Run tests

Type `] test QiskitIBMRuntime` in the Julia REPL, or run the following command:

```sh
julia -e 'using Pkg; Pkg.test("QiskitIBMRuntime")'
```

## Code formatting

This repository is formatted using [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl), and CI checks that the code is formatted.  To format the code in place:

```sh
make format
```

The `format/` environment pins the JuliaFormatter version so that local runs and CI agree.

## Documentation

Documentation is available at https://qiskit.github.io/QiskitIBMRuntime.jl.

## License

Apache License 2.0
