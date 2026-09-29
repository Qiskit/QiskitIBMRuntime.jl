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

    # `Job`, `Samples` and `BackendSearchResults` have public positional
    # constructors, and `Backend` has a generated one, so a NULL-pointer instance
    # can be built directly to exercise the `TypeName(NULL)` branch.  `Service`
    # has only `Service()`, which reads credentials, so it is covered in the
    # service testset instead.
    @testset "Base.show for NULL objects" begin
        @testset "Base.show for Backend" begin
            # `Backend` has no inner constructor, so Julia generates
            # `Backend(ptr, search_results)`; the field is typed `Any`.
            b = Backend(Ptr{QiskitIBMRuntime.QkrtBackend}(C_NULL), nothing)

            # Compact form
            io = IOBuffer()
            show(io, b)
            @test String(take!(io)) == "Backend(NULL)"

            # text/plain form
            io = IOBuffer()
            show(io, MIME"text/plain"(), b)
            @test String(take!(io)) == "Backend(NULL)"

            @test :name in propertynames(b)
        end

        @testset "Base.show for BackendSearchResults" begin
            sresults =
                BackendSearchResults(Ptr{QiskitIBMRuntime.QkrtBackendSearchResults}(C_NULL))

            # Compact form
            io = IOBuffer()
            show(io, sresults)
            @test String(take!(io)) == "BackendSearchResults(NULL)"

            # text/plain form
            io = IOBuffer()
            show(io, MIME"text/plain"(), sresults)
            @test String(take!(io)) == "BackendSearchResults(NULL)"
        end

        @testset "Base.show for Job" begin
            job = QiskitIBMRuntime.Job(Ptr{QiskitIBMRuntime.QkrtJob}(C_NULL))

            # Compact form
            io = IOBuffer()
            show(io, job)
            @test String(take!(io)) == "Job(NULL)"

            # text/plain form
            io = IOBuffer()
            show(io, MIME"text/plain"(), job)
            @test String(take!(io)) == "Job(NULL)"
        end

        @testset "Base.show for Samples" begin
            samples = QiskitIBMRuntime.Samples(Ptr{QiskitIBMRuntime.QkrtSamples}(C_NULL))

            # Compact form
            io = IOBuffer()
            show(io, samples)
            @test String(take!(io)) == "Samples(NULL)"

            # text/plain form
            io = IOBuffer()
            show(io, MIME"text/plain"(), samples)
            @test String(take!(io)) == "Samples(NULL)"
        end
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
            # `@show` uses `repr`, which has no `:limit`, so this prints every
            # shot; the elided REPL forms are asserted in the `Samples` testset.
            @show samples

            @testset "Base.show for Service" begin
                # Compact form: no readable state, so nothing to show
                io = IOBuffer()
                show(io, service)
                @test String(take!(io)) == "Service(...)"

                # text/plain form for REPL display: no extra state, so it matches the compact form
                io = IOBuffer()
                show(io, MIME"text/plain"(), service)
                @test String(take!(io)) == "Service(...)"
            end

            @testset "Base.show for Backend" begin
                # Compact form: only the constructor-relevant field
                io = IOBuffer()
                show(io, backend)
                @test String(take!(io)) == "Backend(\"$(backend.name)\")"

                # text/plain form for REPL display: starts with the escaped compact
                # form, then labeled fields
                io = IOBuffer()
                show(io, MIME"text/plain"(), backend)
                output = String(take!(io))
                @test startswith(output, "Backend(\"$(backend.name)\")\n")
                @test contains(output, "\n  instance_name: $(backend.instance_name)")
                @test contains(output, "\n  instance_crn: $(backend.instance_crn)")
            end

            @testset "Base.show for BackendSearchResults" begin
                n = length(search)

                # `BackendSearchResults` is an `AbstractVector{Backend}`, so like
                # `Samples` both forms defer to Base's standard array printer,
                # which elides long output when `:limit` is set.
                buf = IOBuffer()
                io = IOContext(buf, :limit => true, :displaysize => (24, 80))

                # text/plain form for REPL display: `N-element BackendSearchResults:`
                show(io, MIME"text/plain"(), search)
                plain = String(take!(buf))
                header = first(eachsplit(plain, '\n'))
                @test startswith(header, "$n-element ")
                @test endswith(header, "BackendSearchResults:")

                # Compact form: a single-line vector with the element-type prefix,
                # like `BigInt[1, 2]`
                show(io, search)
                compact = String(take!(buf))
                @test startswith(compact, "Backend[")
                @test endswith(compact, "]")

                # Elided, not dumped
                @test count(==('\n'), plain) < 25
                @test !occursin('\n', compact)
            end

            @testset "Base.show for Job" begin
                # Compact form
                io = IOBuffer()
                show(io, job)
                @test String(take!(io)) == "Job(...)"

                # text/plain form for REPL display: like `Service`, no extra state,
                # so it matches the compact form
                io = IOBuffer()
                show(io, MIME"text/plain"(), job)
                @test String(take!(io)) == "Job(...)"
            end

            @testset "Base.show for Samples" begin
                n = length(samples)

                # `Samples` is an `AbstractVector{String}`, so both forms defer to
                # Base's standard array printer. `:limit` is what Base uses to
                # elide long output, and it is what keeps a 1024-shot run from
                # flooding the REPL.
                buf = IOBuffer()
                io = IOContext(buf, :limit => true, :displaysize => (24, 80))

                # text/plain form for REPL display: `N-element Samples:` then the shots
                show(io, MIME"text/plain"(), samples)
                plain = String(take!(buf))
                header = first(eachsplit(plain, '\n'))
                @test startswith(header, "$n-element ")
                @test endswith(header, "Samples:")

                # Compact form is a single-line, quoted vector literal
                show(io, samples)
                compact = String(take!(buf))
                @test startswith(compact, "[\"")
                @test endswith(compact, "\"]")

                # Elided rather than dumped (10 shots, an ellipsis, 10 more -- not 1024
                # lines), and no pointer leaks into any display
                @test count(==('\n'), plain) < 25
                @test !occursin('\n', compact)
                @test length(compact) < 200
                @test !occursin("Ptr{", sprint(show, backend))
            end
        end
    end
end
