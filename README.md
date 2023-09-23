# zig-x86

x86 and x86_64 library for Zig

Intel® 64 and IA-32 Architectures Software Developer’s Manual: Volume 2

https://www.intel.com/content/www/us/en/architecture-and-technology/64-ia-32-architectures-software-developer-instruction-set-reference-manual-325383.html

## Testing

Tests are located in `src/main.zig`.

```
zig build test --summary all
```

## Creating the disasm reference files

```
$ zig build-obj notes/add.zig -O ReleaseSafe -target x86-linux-gnu -mcpu generic
```

```
$ objdump -d -Mintel --insn-width=11 add.o > notes/objdump.intel.txt
```

```
$ objcopy -O binary --only-sections=.text add.o add.bin
$ ndisasm add.bin > notes/ndisasm.1.txt
```

## License

Mozilla Public License Version 2.0

Copyright 2023 Meghan Denny
