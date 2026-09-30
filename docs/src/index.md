```@meta
CurrentModule = QiskitIBMRuntime
```

# QiskitIBMRuntime

Documentation for [QiskitIBMRuntime.jl](https://github.com/Qiskit/QiskitIBMRuntime.jl).

In order to use this package, the credentials currently must first be saved to `$HOME/.qiskit/qiskit-ibm.json` following [the procedure in the qiskit-ibm-runtime README](https://github.com/Qiskit/qiskit-ibm-runtime?tab=readme-ov-file#qiskit-runtime-service-on-the-new-ibm-quantum-platform-ibm-cloud).

## Example

This example constructs a circuit that generates a [Bell state](https://en.wikipedia.org/wiki/Bell_state).  It transpiles and submits that circuit to the least busy quantum backend.  When the job is done, it displays the results.

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

`samples` is an `AbstractVector` of shots, where each shot is a `BitVector`
whose element `j` is classical bit `j - 1`.  The above code is expected to
generate output similar to the following:

```
backend.name = "ibm_fez"
transpiled_circuit.num_instructions = 10
samples[1:20] = BitVector[[1, 1], [0, 0], [1, 1], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [1, 1], [0, 0], [1, 1], [1, 1], [0, 0], [0, 0], [1, 1], [0, 0], [0, 0], [0, 1], [0, 0], [1, 1]]
countmap(samples) = Dict{BitVector, Int64}([0, 1] => 14, [0, 0] => 518, [1, 1] => 446, [1, 0] => 46)
```

To work with every shot at once, convert the samples to a dense
`num_bits × shots` matrix, where column `k` is shot `k`:

```julia
bits = BitMatrix(samples)
@show size(bits)
# Number of shots in which classical bit 0 was measured as 1:
@show count(bits[1, :])
```

## API Reference

```@index
```

```@autodocs
Modules = [QiskitIBMRuntime]
```
