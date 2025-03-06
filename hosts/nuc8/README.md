# Windows 10 installation

> Important: Install Windows 10 *before* NixOS

Before setup, press `CTRL+F10`. Then, enter the following commands in the terminal window:

```
diskpart
```

Get your drive number with:

```
list disk
```

> most likely `0`

```
select disk 0
clean
convert gpt

create partition efi size=1024
format quick fs=fat32 label="System"

create partition msr size=16

create partition primary
shrink minimum=1024
format quick fs=ntfs label="Windows"

create partition primary
format quick fs=ntfs label="Recovery"

exit
```

Close the terminal and proceed as usual.

After booting into your finished Windows installation, resize the C drive to make some space for your Linux root and swap partitions.
