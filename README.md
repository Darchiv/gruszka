# GRUSZKA 65C02 OS

## Project directories
  - `libc/` - everything associated with C
    - `runtime/` - 6502-family CPUs lack many instructions and "wide" registers, and as such need many helper procedures stored here; shared by userspace and kernelspace programs
    - `common/` - actual standard library implementation with system-independent code and some helper routines
    - `include/` - header files for the standard library
    - `asminc/` - like include files above but available for the assembly code
  - `src/` - operating system code
  - 
  
Currently libc has files dated by commit f0708db792504dc0639d170a51d72b9379f64624.