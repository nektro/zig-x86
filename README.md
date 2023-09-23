# zig-x86

x86 and x86_64 library for Zig

Intel® 64 and IA-32 Architectures Software Developer’s Manual: Volume 2

https://www.intel.com/content/www/us/en/architecture-and-technology/64-ia-32-architectures-software-developer-instruction-set-reference-manual-325383.html

## Testing

Tests are located in `src/main.zig`.

```
zig build test --summary all
```

## License

Mozilla Public License Version 2.0

Copyright 2023 Meghan Denny

<!--  -->

// https://unix.stackexchange.com/questions/30173/how-to-remove-duplicate-lines-inside-a-text-file
// awk '!seen[$0]++' filename
