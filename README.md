[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://qiskit.github.io/QiskitIBMRuntimeC.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://qiskit.github.io/QiskitIBMRuntimeC.jl/dev/)
[![Qiskit Ecosystem](https://qisk.it/e-bcde78a1)](https://qisk.it/ecosystem)
[![Build Status](https://github.com/Qiskit/QiskitIBMRuntimeC.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/Qiskit/QiskitIBMRuntimeC.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://coveralls.io/repos/github/Qiskit/QiskitIBMRuntimeC.jl/badge.svg?branch=main)](https://coveralls.io/github/Qiskit/QiskitIBMRuntimeC.jl?branch=main)
[![PkgEval](https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/Q/Qiskit.svg)](https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/Q/Qiskit.html)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

# QiskitIBMRuntimeC.jl

This package allows you to execute circuits on a quantum computer from the [Julia programming language](https://julialang.org/) using the Qiskit IBM Runtime service.  It builds on [Qiskit.jl](https://github.com/Qiskit/Qiskit.jl) and provides a lightweight Julia wrapper of the [qiskit-ibm-runtime-c](https://github.com/Qiskit/qiskit-ibm-runtime-c) client.

## Example

The following example constructs a circuit that generates a [Bell state](https://en.wikipedia.org/wiki/Bell_state). It transpiles and submits that circuit to the least busy quantum backend. When the job is done, it displays the results.

```julia
using Qiskit
using QiskitIBMRuntimeC

function generate_bell_circuit()
    qc = QuantumCircuit(2, 2) # 2 qubits, 2 clbits
    qc.h(1)
    qc.cx(1, 2)
    qc.measure(1, 1)
    qc.measure(2, 2)
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
samples = get_job_results(job, service)
@show samples
```

When run with the [appropriate credentials](https://github.com/Qiskit/qiskit-ibm-runtime?tab=readme-ov-file#qiskit-runtime-service-on-the-new-ibm-quantum-platform-ibm-cloud) to access quantum hardware, the above code may generate output similar to the following:

```
backend.name = "ibm_fez"
transpiled_circuit.num_instructions = 10
samples = ["0x0", "0x0", "0x0", "0x3", "0x0", "0x3", "0x0", "0x3", "0x0", "0x0", "0x3", "0x0", "0x0", "0x3", "0x3", "0x3", "0x0", "0x0", "0x3", "0x0", "0x0", "0x3", "0x0", "0x0", "0x3", "0x3", "0x3", ...]
```

## Installation instructions

### Install Julia

The official install instructions are at https://julialang.org/install/.

If you are a Rust user, you may choose to obtain `juliaup` via `cargo`.

```sh
cargo install juliaup
juliaup add release
```

### Install `QiskitIBMRuntimeC.jl`

#### Latest stable release

Type `] add QiskitIBMRuntimeC` in the Julia REPL, or run the following command:

```sh
julia -e 'using Pkg; pkg"add QiskitIBMRuntimeC"'
```

#### Development version

Type `] dev QiskitIBMRuntimeC` in the Julia REPL, or run the following command:

```sh
julia -e 'using Pkg; pkg"dev QiskitIBMRuntimeC"'
```

Afterward, the repository will be cloned to `~/.julia/dev/QiskitIBMRuntimeC`.

## Run tests

Type `] test QiskitIBMRuntimeC` in the Julia REPL, or run the following command:

```sh
julia -e 'using Pkg; Pkg.test("QiskitIBMRuntimeC")'
```

## Documentation

Documentation is available at https://qiskit.github.io/QiskitIBMRuntimeC.jl.

## License

Apache License 2.0
