SECTIONS
{
    .  = 0x0;

    .text : 
    {
	*(.preamble_section)
	*(.start_section)
        *(.text)
    }

    .rodata :
    {
        *(.rodata)
    }

    .data :
    {
        *(.data)
    }

    .bss :
    {
        *(.bss)
    }
}
