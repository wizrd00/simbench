# SIMBENCH
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Language](https://img.shields.io/badge/language-x86__64%20Assembly-lightgrey.svg)
![Platform](https://img.shields.io/badge/platform-Linux-yellow.svg)
![Arch](https://img.shields.io/badge/arch-x86__64-orange.svg)

A tiny, dependency-free CPU benchmark written in pure x86_64 assembly (AT&T syntax, GNU `as`). No libc, no external calls beyond raw Linux syscalls — just a counter and a clock.

## How it works

The benchmark calls `sys_time` (syscall `0xc9` / 201) to get a timestamp, then spins in a tight loop decrementing `%rcx` from `0xfffffffff` (68,719,476,735) down to `0`. Once the loop finishes, it calls `sys_time` again and subtracts the start time from the end time. The difference — in whole seconds — is printed to stdout as the score.

```
Score -> <seconds>
```

Lower is better: fewer seconds means the CPU chewed through the decrement loop faster.

### Why seconds, not cycles?

`sys_time` has 1-second resolution, so the loop bound (`0xfffffffff`) is intentionally large enough that the benchmark runs for a measurable number of whole seconds on typical hardware. This keeps the implementation dead simple (no `rdtsc`, no syscall overhead from higher-resolution timers like `clock_gettime`) at the cost of coarse precision.

## Requirements

- Linux on x86_64
- GNU Binutils (`as`, `ld`)
- `make`

## Build

```sh
make
```

This assembles `simbench.s` into `simbench.o` and links it into a standalone static binary named `simbench` (no libc linkage required).

## Run

```sh
./simbench
```

Example output:

```
Score -> 12
```

## Clean

```sh
make clean
```

Removes the built `simbench` binary and `simbench.o` object file.

## Notes / Caveats

- This is a single-threaded, single-core benchmark — it only stresses scalar integer decrement/compare/jump throughput on one core, not memory bandwidth, SIMD, or multi-core performance.
- Results are sensitive to CPU frequency scaling, thermal throttling, and background load. For consistent comparisons, pin the process to a core (`taskset`) and disable turbo/frequency scaling if possible.
- If the `sys_time` syscall fails (returns `-1`), the program prints an error message and exits instead of producing a score.

## License

MIT — see [LICENSE](LICENSE).
