SECTION "Extended WRAM Bank 3", WRAMX[$d000], BANK[3]

wExtendedRAMStart::

    ds 3840

wExtendedRAMEnd::

ASSERT wExtendedRAMEnd <= $df00
