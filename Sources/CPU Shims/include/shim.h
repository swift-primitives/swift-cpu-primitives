#ifndef SWIFT_CPU_SHIM_H
#define SWIFT_CPU_SHIM_H

#ifdef __cplusplus
extern "C" {
#endif

unsigned long long swift_cpu_timestamp_read_v1(void);

unsigned int swift_cpu_integrity_cyclic_castagnoli_v1(const void* data, unsigned long long len, unsigned int seed);

unsigned int swift_cpu_integrity_cyclic_castagnoli_software_v1(const void* data, unsigned long long len, unsigned int seed);

#ifdef __cplusplus
}
#endif

#endif
