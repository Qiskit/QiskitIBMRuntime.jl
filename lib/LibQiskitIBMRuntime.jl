module LibQiskitIBMRuntime

using qiskit_ibm_runtime_jll
export qiskit_ibm_runtime_jll

using CEnum: CEnum, @cenum

using Qiskit.C

const QkComplex64 = ComplexF64


function qk_complex64_from_native(arg1)
    ccall((:qk_complex64_from_native, libqiskit_ibm_runtime), QkComplex64, (Cint,), arg1)
end

mutable struct Service end

mutable struct Job end

mutable struct Backend end

mutable struct BackendSearchResults end

mutable struct Samples end

mutable struct Counts end

mutable struct ExpectationValues end

function qkrt_service_new(out)
    ccall((:qkrt_service_new, libqiskit_ibm_runtime), Int32, (Ptr{Ptr{Service}},), out)
end

function qkrt_service_free(service)
    ccall((:qkrt_service_free, libqiskit_ibm_runtime), Cvoid, (Ptr{Service},), service)
end

function qkrt_backend_search(out, service)
    ccall((:qkrt_backend_search, libqiskit_ibm_runtime), Int32, (Ptr{Ptr{BackendSearchResults}}, Ptr{Service}), out, service)
end

function qkrt_backend_search_results_free(results)
    ccall((:qkrt_backend_search_results_free, libqiskit_ibm_runtime), Cvoid, (Ptr{BackendSearchResults},), results)
end

function qkrt_backend_search_results_length(results)
    ccall((:qkrt_backend_search_results_length, libqiskit_ibm_runtime), UInt64, (Ptr{BackendSearchResults},), results)
end

function qkrt_backend_search_results_data(results)
    ccall((:qkrt_backend_search_results_data, libqiskit_ibm_runtime), Ptr{Ptr{Backend}}, (Ptr{BackendSearchResults},), results)
end

function qkrt_backend_search_results_least_busy(results)
    ccall((:qkrt_backend_search_results_least_busy, libqiskit_ibm_runtime), Ptr{Backend}, (Ptr{BackendSearchResults},), results)
end

function qkrt_get_backend_target(service, backend)
    ccall((:qkrt_get_backend_target, libqiskit_ibm_runtime), Ptr{QkTarget}, (Ptr{Service}, Ptr{Backend}), service, backend)
end

function qkrt_backend_name(backend)
    ccall((:qkrt_backend_name, libqiskit_ibm_runtime), Ptr{Cchar}, (Ptr{Backend},), backend)
end

function qkrt_backend_instance_crn(backend)
    ccall((:qkrt_backend_instance_crn, libqiskit_ibm_runtime), Ptr{Cchar}, (Ptr{Backend},), backend)
end

function qkrt_backend_instance_name(backend)
    ccall((:qkrt_backend_instance_name, libqiskit_ibm_runtime), Ptr{Cchar}, (Ptr{Backend},), backend)
end

function qkrt_sampler_job_run(out, service, backend, circuit, shots, runtime)
    ccall((:qkrt_sampler_job_run, libqiskit_ibm_runtime), Int32, (Ptr{Ptr{Job}}, Ptr{Service}, Ptr{Backend}, Ptr{QkCircuit}, Int32, Ptr{Cchar}), out, service, backend, circuit, shots, runtime)
end

function qkrt_estimator_job_run(out, service, backend, circuit, observable, runtime)
    ccall((:qkrt_estimator_job_run, libqiskit_ibm_runtime), Int32, (Ptr{Ptr{Job}}, Ptr{Service}, Ptr{Backend}, Ptr{QkCircuit}, Ptr{QkObs}, Ptr{Cchar}), out, service, backend, circuit, observable, runtime)
end

function qkrt_job_status(out, service, job)
    ccall((:qkrt_job_status, libqiskit_ibm_runtime), Int32, (Ptr{UInt32}, Ptr{Service}, Ptr{Job}), out, service, job)
end

function qkrt_job_free(job)
    ccall((:qkrt_job_free, libqiskit_ibm_runtime), Cvoid, (Ptr{Job},), job)
end

function generate_qpy(circuit, filename)
    ccall((:generate_qpy, libqiskit_ibm_runtime), Cvoid, (Ptr{QkCircuit}, Ptr{Cchar}), circuit, filename)
end

function qkrt_sampler_job_results(out, service, job)
    ccall((:qkrt_sampler_job_results, libqiskit_ibm_runtime), Int32, (Ptr{Ptr{Samples}}, Ptr{Service}, Ptr{Job}), out, service, job)
end

function qkrt_estimator_job_results(out, service, job)
    ccall((:qkrt_estimator_job_results, libqiskit_ibm_runtime), Int32, (Ptr{Ptr{ExpectationValues}}, Ptr{Service}, Ptr{Job}), out, service, job)
end

function qkrt_samples_num_samples(samples)
    ccall((:qkrt_samples_num_samples, libqiskit_ibm_runtime), Csize_t, (Ptr{Samples},), samples)
end

function qkrt_expectation_values_num_evs(evs)
    ccall((:qkrt_expectation_values_num_evs, libqiskit_ibm_runtime), Csize_t, (Ptr{ExpectationValues},), evs)
end

function qkrt_samples_num_bits(samples)
    ccall((:qkrt_samples_num_bits, libqiskit_ibm_runtime), UInt32, (Ptr{Samples},), samples)
end

function qkrt_samples_get_sample(samples, index)
    ccall((:qkrt_samples_get_sample, libqiskit_ibm_runtime), Ptr{Cchar}, (Ptr{Samples}, Csize_t), samples, index)
end

function qkrt_expectation_values_get_ev(evs, index)
    ccall((:qkrt_expectation_values_get_ev, libqiskit_ibm_runtime), Cdouble, (Ptr{ExpectationValues}, Csize_t), evs, index)
end

function qkrt_expectation_values_copy_into(evs, out)
    ccall((:qkrt_expectation_values_copy_into, libqiskit_ibm_runtime), Cvoid, (Ptr{ExpectationValues}, Ptr{Cdouble}), evs, out)
end

function qkrt_samples_free(samples)
    ccall((:qkrt_samples_free, libqiskit_ibm_runtime), Cvoid, (Ptr{Samples},), samples)
end

function qkrt_samples_to_counts(samples)
    ccall((:qkrt_samples_to_counts, libqiskit_ibm_runtime), Ptr{Counts}, (Ptr{Samples},), samples)
end

function qkrt_counts_length(counts)
    ccall((:qkrt_counts_length, libqiskit_ibm_runtime), Csize_t, (Ptr{Counts},), counts)
end

function qkrt_counts_display(counts)
    ccall((:qkrt_counts_display, libqiskit_ibm_runtime), Cvoid, (Ptr{Counts},), counts)
end

function qkrt_counts_most_frequent(counts)
    ccall((:qkrt_counts_most_frequent, libqiskit_ibm_runtime), Ptr{Cchar}, (Ptr{Counts},), counts)
end

function qkrt_counts_least_frequent(counts)
    ccall((:qkrt_counts_least_frequent, libqiskit_ibm_runtime), Ptr{Cchar}, (Ptr{Counts},), counts)
end

function qkrt_counts_sort_by_frequency(counts, most_frequent_first)
    ccall((:qkrt_counts_sort_by_frequency, libqiskit_ibm_runtime), Cvoid, (Ptr{Counts}, Cint), counts, most_frequent_first)
end

function qkrt_counts_get_by_sample(counts, sample)
    ccall((:qkrt_counts_get_by_sample, libqiskit_ibm_runtime), UInt64, (Ptr{Counts}, Ptr{Cchar}), counts, sample)
end

#function qkrt_count_clear(count)
#    ccall((:qkrt_count_clear, libqiskit_ibm_runtime), Cvoid, (Ptr{QkrtCount},), count)
#end

#function qkrt_counts_get_count(counts, index, out_count)
#    ccall((:qkrt_counts_get_count, libqiskit_ibm_runtime), Int32, (Ptr{Counts}, Csize_t, Ptr{QkrtCount}), counts, index, out_count)
#end

function qkrt_counts_free(counts)
    ccall((:qkrt_counts_free, libqiskit_ibm_runtime), Cvoid, (Ptr{Counts},), counts)
end

function qkrt_expectation_values_free(evs)
    ccall((:qkrt_expectation_values_free, libqiskit_ibm_runtime), Cvoid, (Ptr{ExpectationValues},), evs)
end

function qkrt_str_free(string)
    ccall((:qkrt_str_free, libqiskit_ibm_runtime), Cvoid, (Ptr{Cchar},), string)
end

# exports
const PREFIXES = ["qkrt_"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module
