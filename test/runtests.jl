using QiskitIBMRuntime
using Qiskit
using Test
using Aqua

function generate_bell_circuit()
    qc = QuantumCircuit(2, 2) # 2 qubits, 2 clbits
    qc.h(1)
    qc.cx(1, 2)
    qc.measure(1, 1)
    qc.measure(2, 2)
    qc
end

@testset "QiskitIBMRuntime.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(QiskitIBMRuntime)
    end

    @testset "Hex sample parsing" begin
        # Element `j` of the resulting BitVector is classical bit `j - 1`, so
        # index 1 is the least significant bit.
        parse_hex = QiskitIBMRuntime._hex_to_bitvector
        @test parse_hex("0x0", 2) == BitVector([0, 0])
        @test parse_hex("0x3", 2) == BitVector([1, 1])
        @test parse_hex("0x1", 4) == BitVector([1, 0, 0, 0])
        @test parse_hex("0x6", 4) == BitVector([0, 1, 1, 0])
        # A value narrower than the bit width is zero-padded.
        @test parse_hex("0x2", 5) == BitVector([0, 1, 0, 0, 0])
        # More than 64 bits are handled correctly (parsing goes through BigInt).
        wide = string("0x", string(big(1) << 100, base = 16))
        bv = parse_hex(wide, 128)
        @test count(bv) == 1
        @test bv[101]
    end

    # Skip the tests that require a service by default
    if get(ENV, "TEST_QKRT_SERVICE", "0") == "0"
        @info "Skipping the service tests.  To run them, set the environment variable TEST_QKRT_SERVICE=1"
    else
        @info "Running the service tests, since the environment variable TEST_QKRT_SERVICE is nonzero."
        service = Service()
        @testset "Actual service" begin
            search = backend_search(service)
            backend = least_busy(search)
            @show backend.name
            target = target_from_backend(backend, service)

            qc = generate_bell_circuit()

            transpiled_circuit, layout = transpile(qc, target)
            @show transpiled_circuit.num_instructions

            shots = 1024
            job = run_sampler_job(service, backend, transpiled_circuit, shots)
            samples = get_job_results(job, service)
            @show samples
            @test length(samples) == shots
            @test num_bits(samples) == 2
            @test all(shot -> length(shot) == 2, samples)
            bits = BitMatrix(samples)
            @test size(bits) == (2, shots)
            @test bits[:, 1] == samples[1]
        end
    end
end
