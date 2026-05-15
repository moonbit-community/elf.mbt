///|
/// Return the symbolic `ELFOSABI_*` name for a known OS ABI byte.
pub fn e_osabi_to_str(e_osabi : Byte) -> String? {
  match e_osabi {
    ELFOSABI_SYSV => Some("ELFOSABI_SYSV")
    ELFOSABI_HPUX => Some("ELFOSABI_HPUX")
    ELFOSABI_NETBSD => Some("ELFOSABI_NETBSD")
    ELFOSABI_LINUX => Some("ELFOSABI_LINUX")
    ELFOSABI_SOLARIS => Some("ELFOSABI_SOLARIS")
    ELFOSABI_AIX => Some("ELFOSABI_AIX")
    ELFOSABI_IRIX => Some("ELFOSABI_IRIX")
    ELFOSABI_FREEBSD => Some("ELFOSABI_FREEBSD")
    ELFOSABI_TRU64 => Some("ELFOSABI_TRU64")
    ELFOSABI_MODESTO => Some("ELFOSABI_MODESTO")
    ELFOSABI_OPENBSD => Some("ELFOSABI_OPENBSD")
    ELFOSABI_OPENVMS => Some("ELFOSABI_OPENVMS")
    ELFOSABI_NSK => Some("ELFOSABI_NSK")
    ELFOSABI_AROS => Some("ELFOSABI_AROS")
    ELFOSABI_FENIXOS => Some("ELFOSABI_FENIXOS")
    ELFOSABI_CLOUDABI => Some("ELFOSABI_CLOUDABI")
    ELFOSABI_OPENVOS => Some("ELFOSABI_OPENVOS")
    _ => None
  }
}

///|
/// Return a symbolic OS ABI name, or a hexadecimal fallback for unknown values.
pub fn e_osabi_to_string(e_osabi : Byte) -> String {
  match e_osabi_to_str(e_osabi) {
    Some(s) => s
    None => "e_osabi(0x" + e_osabi.to_uint().to_string(radix=16) + ")"
  }
}

///|
/// Return a short human-readable description for a known `e_type` value.
pub fn e_type_to_human_str(e_type : UInt16) -> String? {
  match e_type {
    ET_NONE => Some("No file type")
    ET_REL => Some("Relocatable file")
    ET_EXEC => Some("Executable file")
    ET_DYN => Some("Shared object file")
    ET_CORE => Some("Core file")
    _ => None
  }
}

///|
/// Return the symbolic `ET_*` name for a known ELF file type.
pub fn e_type_to_str(e_type : UInt16) -> String? {
  match e_type {
    ET_NONE => Some("ET_NONE")
    ET_REL => Some("ET_REL")
    ET_EXEC => Some("ET_EXEC")
    ET_DYN => Some("ET_DYN")
    ET_CORE => Some("ET_CORE")
    _ => None
  }
}

///|
/// Return a symbolic file-type name, or a hexadecimal fallback for unknown values.
pub fn e_type_to_string(e_type : UInt16) -> String {
  match e_type_to_str(e_type) {
    Some(s) => s
    None => "e_type(0x" + e_type.to_string(radix=16) + ")"
  }
}

///|
/// Return a short human-readable description for a known `e_machine` value.
pub fn e_machine_to_human_str(e_machine : UInt16) -> String? {
  match e_machine {
    EM_NONE => Some("No machine")
    EM_M32 => Some("AT&T WE 32100")
    EM_SPARC => Some("SPARC")
    EM_386 => Some("Intel 80386")
    EM_68K => Some("Motorola 68000")
    EM_88K => Some("Motorola 88000")
    EM_IAMCU => Some("Intel MCU")
    EM_860 => Some("Intel 80860")
    EM_MIPS => Some("MIPS I Architecture")
    EM_S370 => Some("IBM System/370 Processor")
    EM_MIPS_RS3_LE => Some("MIPS RS3000 Little-endian")
    EM_PARISC => Some("Hewlett-Packard PA-RISC")
    EM_VPP500 => Some("Fujitsu VPP500")
    EM_SPARC32PLUS => Some("Enhanced instruction set SPARC")
    EM_960 => Some("Intel 80960")
    EM_PPC => Some("PowerPC")
    EM_PPC64 => Some("64-bit PowerPC")
    EM_S390 => Some("IBM System/390 Processor")
    EM_SPU => Some("IBM SPU/SPC")
    EM_V800 => Some("NEC V800")
    EM_FR20 => Some("Fujitsu FR20")
    EM_RH32 => Some("TRW RH-32")
    EM_RCE => Some("Motorola RCE")
    EM_ARM => Some("ARM 32-bit architecture (AARCH32)")
    EM_ALPHA => Some("Digital Alpha")
    EM_SH => Some("Hitachi SH")
    EM_SPARCV9 => Some("SPARC Version 9")
    EM_TRICORE => Some("Siemens TriCore embedded processor")
    EM_ARC => Some("Argonaut RISC Core, Argonaut Technologies Inc.")
    EM_H8_300 => Some("Hitachi H8/300")
    EM_H8_300H => Some("Hitachi H8/300H")
    EM_H8S => Some("Hitachi H8S")
    EM_H8_500 => Some("Hitachi H8/500")
    EM_IA_64 => Some("Intel IA-64 processor architecture")
    EM_MIPS_X => Some("Stanford MIPS-X")
    EM_COLDFIRE => Some("Motorola ColdFire")
    EM_68HC12 => Some("Motorola M68HC12")
    EM_MMA => Some("Fujitsu MMA Multimedia Accelerator")
    EM_PCP => Some("Siemens PCP")
    EM_NCPU => Some("Sony nCPU embedded RISC processor")
    EM_NDR1 => Some("Denso NDR1 microprocessor")
    EM_STARCORE => Some("Motorola Star*Core processor")
    EM_ME16 => Some("Toyota ME16 processor")
    EM_ST100 => Some("STMicroelectronics ST100 processor")
    EM_TINYJ => Some("Advanced Logic Corp. TinyJ embedded processor family")
    EM_X86_64 => Some("AMD x86-64 architecture")
    EM_PDSP => Some("Sony DSP Processor")
    EM_PDP10 => Some("Digital Equipment Corp. PDP-10")
    EM_PDP11 => Some("Digital Equipment Corp. PDP-11")
    EM_FX66 => Some("Siemens FX66 microcontroller")
    EM_ST9PLUS => Some("STMicroelectronics ST9+ 8/16 bit microcontroller")
    EM_ST7 => Some("STMicroelectronics ST7 8-bit microcontroller")
    EM_68HC16 => Some("Motorola MC68HC16 Microcontroller")
    EM_68HC11 => Some("Motorola MC68HC11 Microcontroller")
    EM_68HC08 => Some("Motorola MC68HC08 Microcontroller")
    EM_68HC05 => Some("Motorola MC68HC05 Microcontroller")
    EM_SVX => Some("Silicon Graphics SVx")
    EM_ST19 => Some("STMicroelectronics ST19 8-bit microcontroller")
    EM_VAX => Some("Digital VAX")
    EM_CRIS => Some("Axis Communications 32-bit embedded processor")
    EM_JAVELIN => Some("Infineon Technologies 32-bit embedded processor")
    EM_FIREPATH => Some("Element 14 64-bit DSP Processor")
    EM_ZSP => Some("LSI Logic 16-bit DSP Processor")
    EM_MMIX => Some("Donald Knuth's educational 64-bit processor")
    EM_HUANY => Some("Harvard University machine-independent object files")
    EM_PRISM => Some("SiTera Prism")
    EM_AVR => Some("Atmel AVR 8-bit microcontroller")
    EM_FR30 => Some("Fujitsu FR30")
    EM_D10V => Some("Mitsubishi D10V")
    EM_D30V => Some("Mitsubishi D30V")
    EM_V850 => Some("NEC v850")
    EM_M32R => Some("Mitsubishi M32R")
    EM_MN10300 => Some("Matsushita MN10300")
    EM_MN10200 => Some("Matsushita MN10200")
    EM_PJ => Some("picoJava")
    EM_OPENRISC => Some("OpenRISC 32-bit embedded processor")
    EM_ARC_COMPACT => Some("ARC International ARCompact processor")
    EM_XTENSA => Some("Tensilica Xtensa Architecture")
    EM_VIDEOCORE => Some("Alphamosaic VideoCore processor")
    EM_TMM_GPP => Some("Thompson Multimedia General Purpose Processor")
    EM_NS32K => Some("National Semiconductor 32000 series")
    EM_TPC => Some("Tenor Network TPC processor")
    EM_SNP1K => Some("Trebia SNP 1000 processor")
    EM_ST200 => Some("STMicroelectronics (www.st.com) ST200 microcontroller")
    EM_IP2K => Some("Ubicom IP2xxx microcontroller family")
    EM_MAX => Some("MAX Processor")
    EM_CR => Some("National Semiconductor CompactRISC microprocessor")
    EM_F2MC16 => Some("Fujitsu F2MC16")
    EM_MSP430 => Some("Texas Instruments embedded microcontroller msp430")
    EM_BLACKFIN => Some("Analog Devices Blackfin (DSP) processor")
    EM_SE_C33 => Some("S1C33 Family of Seiko Epson processors")
    EM_SEP => Some("Sharp embedded microprocessor")
    EM_ARCA => Some("Arca RISC Microprocessor")
    EM_UNICORE =>
      Some(
        "Microprocessor series from PKU-Unity Ltd. and MPRC of Peking University",
      )
    EM_EXCESS => Some("eXcess: 16/32/64-bit configurable embedded CPU")
    EM_DXP => Some("Icera Semiconductor Inc. Deep Execution Processor")
    EM_ALTERA_NIOS2 => Some("Altera Nios II soft-core processor")
    EM_CRX => Some("National Semiconductor CompactRISC CRX microprocessor")
    EM_XGATE => Some("Motorola XGATE embedded processor")
    EM_C166 => Some("Infineon C16x/XC16x processor")
    EM_M16C => Some("Renesas M16C series microprocessors")
    EM_DSPIC30F =>
      Some("Microchip Technology dsPIC30F Digital Signal Controller")
    EM_CE => Some("Freescale Communication Engine RISC core")
    EM_M32C => Some("Renesas M32C series microprocessors")
    EM_TSK3000 => Some("Altium TSK3000 core")
    EM_RS08 => Some("Freescale RS08 embedded processor")
    EM_SHARC => Some("Analog Devices SHARC family of 32-bit DSP processors")
    EM_ECOG2 => Some("Cyan Technology eCOG2 microprocessor")
    EM_SCORE7 => Some("Sunplus S+core7 RISC processor")
    EM_DSP24 => Some("New Japan Radio (NJR) 24-bit DSP Processor")
    EM_VIDEOCORE3 => Some("Broadcom VideoCore III processor")
    EM_LATTICEMICO32 => Some("RISC processor for Lattice FPGA architecture")
    EM_SE_C17 => Some("Seiko Epson C17 family")
    EM_TI_C6000 => Some("The Texas Instruments TMS320C6000 DSP family")
    EM_TI_C2000 => Some("The Texas Instruments TMS320C2000 DSP family")
    EM_TI_C5500 => Some("The Texas Instruments TMS320C55x DSP family")
    EM_TI_ARP32 =>
      Some("Texas Instruments Application Specific RISC Processor, 32bit fetch")
    EM_TI_PRU => Some("Texas Instruments Programmable Realtime Unit")
    EM_MMDSP_PLUS => Some("STMicroelectronics 64bit VLIW Data Signal Processor")
    EM_CYPRESS_M8C => Some("Cypress M8C microprocessor")
    EM_R32C => Some("Renesas R32C series microprocessors")
    EM_TRIMEDIA => Some("NXP Semiconductors TriMedia architecture family")
    EM_QDSP6 => Some("QUALCOMM DSP6 Processor")
    EM_8051 => Some("Intel 8051 and variants")
    EM_STXP7X =>
      Some(
        "STMicroelectronics STxP7x family of configurable and extensible RISC processors",
      )
    EM_NDS32 =>
      Some("Andes Technology compact code size embedded RISC processor family")
    EM_ECOG1X => Some("Cyan Technology eCOG1X family")
    EM_MAXQ30 => Some("Dallas Semiconductor MAXQ30 Core Micro-controllers")
    EM_XIMO16 => Some("New Japan Radio (NJR) 16-bit DSP Processor")
    EM_MANIK => Some("M2000 Reconfigurable RISC Microprocessor")
    EM_CRAYNV2 => Some("Cray Inc. NV2 vector architecture")
    EM_RX => Some("Renesas RX family")
    EM_METAG => Some("Imagination Technologies META processor architecture")
    EM_MCST_ELBRUS => Some("MCST Elbrus general purpose hardware architecture")
    EM_ECOG16 => Some("Cyan Technology eCOG16 family")
    EM_CR16 =>
      Some("National Semiconductor CompactRISC CR16 16-bit microprocessor")
    EM_ETPU => Some("Freescale Extended Time Processing Unit")
    EM_SLE9X => Some("Infineon Technologies SLE9X core")
    EM_L10M => Some("Intel L10M")
    EM_K10M => Some("Intel K10M")
    EM_AARCH64 => Some("ARM 64-bit architecture (AARCH64)")
    EM_AVR32 => Some("Atmel Corporation 32-bit microprocessor family")
    EM_STM8 => Some("STMicroeletronics STM8 8-bit microcontroller")
    EM_TILE64 => Some("Tilera TILE64 multicore architecture family")
    EM_TILEPRO => Some("Tilera TILEPro multicore architecture family")
    EM_MICROBLAZE => Some("Xilinx MicroBlaze 32-bit RISC soft processor core")
    EM_CUDA => Some("NVIDIA CUDA architecture")
    EM_TILEGX => Some("Tilera TILE-Gx multicore architecture family")
    EM_CLOUDSHIELD => Some("CloudShield architecture family")
    EM_COREA_1ST => Some("KIPO-KAIST Core-A 1st generation processor family")
    EM_COREA_2ND => Some("KIPO-KAIST Core-A 2nd generation processor family")
    EM_ARC_COMPACT2 => Some("Synopsys ARCompact V2")
    EM_OPEN8 => Some("Open8 8-bit RISC soft processor core")
    EM_RL78 => Some("Renesas RL78 family")
    EM_VIDEOCORE5 => Some("Broadcom VideoCore V processor")
    EM_78KOR => Some("Renesas 78KOR family")
    EM_56800EX => Some("Freescale 56800EX Digital Signal Controller (DSC)")
    EM_BA1 => Some("Beyond BA1 CPU architecture")
    EM_BA2 => Some("Beyond BA2 CPU architecture")
    EM_XCORE => Some("XMOS xCORE processor family")
    EM_MCHP_PIC => Some("Microchip 8-bit PIC(r) family")
    EM_INTEL205 => Some("Reserved by Intel")
    EM_INTEL206 => Some("Reserved by Intel")
    EM_INTEL207 => Some("Reserved by Intel")
    EM_INTEL208 => Some("Reserved by Intel")
    EM_INTEL209 => Some("Reserved by Intel")
    EM_KM32 => Some("KM211 KM32 32-bit processor")
    EM_KMX32 => Some("KM211 KMX32 32-bit processor")
    EM_KMX16 => Some("KM211 KMX16 16-bit processor")
    EM_KMX8 => Some("KM211 KMX8 8-bit processor")
    EM_KVARC => Some("KM211 KVARC processor")
    EM_CDP => Some("Paneve CDP architecture family")
    EM_COGE => Some("Cognitive Smart Memory Processor")
    EM_COOL => Some("Bluechip Systems CoolEngine")
    EM_NORC => Some("Nanoradio Optimized RISC")
    EM_CSR_KALIMBA => Some("CSR Kalimba architecture family")
    EM_Z80 => Some("Zilog Z80")
    EM_VISIUM => Some("Controls and Data Services VISIUMcore processor")
    EM_FT32 => Some("FTDI Chip FT32 high performance 32-bit RISC architecture")
    EM_MOXIE => Some("Moxie processor family")
    EM_AMDGPU => Some("AMD GPU architecture")
    EM_RISCV => Some("RISC-V")
    EM_BPF => Some("Linux BPF")
    EM_LOONGARCH => Some("LoongArch")
    _ => None
  }
}

///|
/// Return the symbolic `EM_*` name for a known machine architecture.
pub fn e_machine_to_str(e_machine : UInt16) -> String? {
  match e_machine {
    EM_NONE => Some("EM_NONE")
    EM_M32 => Some("EM_M32")
    EM_SPARC => Some("EM_SPARC")
    EM_386 => Some("EM_386")
    EM_68K => Some("EM_68K")
    EM_88K => Some("EM_88K")
    EM_IAMCU => Some("EM_IAMCU")
    EM_860 => Some("EM_860")
    EM_MIPS => Some("EM_MIPS")
    EM_S370 => Some("EM_S370")
    EM_MIPS_RS3_LE => Some("EM_MIPS_RS3_LE")
    EM_PARISC => Some("EM_PARISC")
    EM_VPP500 => Some("EM_VPP500")
    EM_SPARC32PLUS => Some("EM_SPARC32PLUS")
    EM_960 => Some("EM_960")
    EM_PPC => Some("EM_PPC")
    EM_PPC64 => Some("EM_PPC64")
    EM_S390 => Some("EM_S390")
    EM_SPU => Some("EM_SPU")
    EM_V800 => Some("EM_V800")
    EM_FR20 => Some("EM_FR20")
    EM_RH32 => Some("EM_RH32")
    EM_RCE => Some("EM_RCE")
    EM_ARM => Some("EM_ARM")
    EM_ALPHA => Some("EM_ALPHA")
    EM_SH => Some("EM_SH")
    EM_SPARCV9 => Some("EM_SPARCV9")
    EM_TRICORE => Some("EM_TRICORE")
    EM_ARC => Some("EM_ARC")
    EM_H8_300 => Some("EM_H8_300")
    EM_H8_300H => Some("EM_H8_300H")
    EM_H8S => Some("EM_H8S")
    EM_H8_500 => Some("EM_H8_500")
    EM_IA_64 => Some("EM_IA_64")
    EM_MIPS_X => Some("EM_MIPS_X")
    EM_COLDFIRE => Some("EM_COLDFIRE")
    EM_68HC12 => Some("EM_68HC12")
    EM_MMA => Some("EM_MMA")
    EM_PCP => Some("EM_PCP")
    EM_NCPU => Some("EM_NCPU")
    EM_NDR1 => Some("EM_NDR1")
    EM_STARCORE => Some("EM_STARCORE")
    EM_ME16 => Some("EM_ME16")
    EM_ST100 => Some("EM_ST100")
    EM_TINYJ => Some("EM_TINYJ")
    EM_X86_64 => Some("EM_X86_64")
    EM_PDSP => Some("EM_PDSP")
    EM_PDP10 => Some("EM_PDP10")
    EM_PDP11 => Some("EM_PDP11")
    EM_FX66 => Some("EM_FX66")
    EM_ST9PLUS => Some("EM_ST9PLUS")
    EM_ST7 => Some("EM_ST7")
    EM_68HC16 => Some("EM_68HC16")
    EM_68HC11 => Some("EM_68HC11")
    EM_68HC08 => Some("EM_68HC08")
    EM_68HC05 => Some("EM_68HC05")
    EM_SVX => Some("EM_SVX")
    EM_ST19 => Some("EM_ST19")
    EM_VAX => Some("EM_VAX")
    EM_CRIS => Some("EM_CRIS")
    EM_JAVELIN => Some("EM_JAVELIN")
    EM_FIREPATH => Some("EM_FIREPATH")
    EM_ZSP => Some("EM_ZSP")
    EM_MMIX => Some("EM_MMIX")
    EM_HUANY => Some("EM_HUANY")
    EM_PRISM => Some("EM_PRISM")
    EM_AVR => Some("EM_AVR")
    EM_FR30 => Some("EM_FR30")
    EM_D10V => Some("EM_D10V")
    EM_D30V => Some("EM_D30V")
    EM_V850 => Some("EM_V850")
    EM_M32R => Some("EM_M32R")
    EM_MN10300 => Some("EM_MN10300")
    EM_MN10200 => Some("EM_MN10200")
    EM_PJ => Some("EM_PJ")
    EM_OPENRISC => Some("EM_OPENRISC")
    EM_ARC_COMPACT => Some("EM_ARC_COMPACT")
    EM_XTENSA => Some("EM_XTENSA")
    EM_VIDEOCORE => Some("EM_VIDEOCORE")
    EM_TMM_GPP => Some("EM_TMM_GPP")
    EM_NS32K => Some("EM_NS32K")
    EM_TPC => Some("EM_TPC")
    EM_SNP1K => Some("EM_SNP1K")
    EM_ST200 => Some("EM_ST200")
    EM_IP2K => Some("EM_IP2K")
    EM_MAX => Some("EM_MAX")
    EM_CR => Some("EM_CR")
    EM_F2MC16 => Some("EM_F2MC16")
    EM_MSP430 => Some("EM_MSP430")
    EM_BLACKFIN => Some("EM_BLACKFIN")
    EM_SE_C33 => Some("EM_SE_C33")
    EM_SEP => Some("EM_SEP")
    EM_ARCA => Some("EM_ARCA")
    EM_UNICORE => Some("EM_UNICORE")
    EM_EXCESS => Some("EM_EXCESS")
    EM_DXP => Some("EM_DXP")
    EM_ALTERA_NIOS2 => Some("EM_ALTERA_NIOS2")
    EM_CRX => Some("EM_CRX")
    EM_XGATE => Some("EM_XGATE")
    EM_C166 => Some("EM_C166")
    EM_M16C => Some("EM_M16C")
    EM_DSPIC30F => Some("EM_DSPIC30F")
    EM_CE => Some("EM_CE")
    EM_M32C => Some("EM_M32C")
    EM_TSK3000 => Some("EM_TSK3000")
    EM_RS08 => Some("EM_RS08")
    EM_SHARC => Some("EM_SHARC")
    EM_ECOG2 => Some("EM_ECOG2")
    EM_SCORE7 => Some("EM_SCORE7")
    EM_DSP24 => Some("EM_DSP24")
    EM_VIDEOCORE3 => Some("EM_VIDEOCORE3")
    EM_LATTICEMICO32 => Some("EM_LATTICEMICO32")
    EM_SE_C17 => Some("EM_SE_C17")
    EM_TI_C6000 => Some("EM_TI_C6000")
    EM_TI_C2000 => Some("EM_TI_C2000")
    EM_TI_C5500 => Some("EM_TI_C5500")
    EM_TI_ARP32 => Some("EM_TI_ARP32")
    EM_TI_PRU => Some("EM_TI_PRU")
    EM_MMDSP_PLUS => Some("EM_MMDSP_PLUS")
    EM_CYPRESS_M8C => Some("EM_CYPRESS_M8C")
    EM_R32C => Some("EM_R32C")
    EM_TRIMEDIA => Some("EM_TRIMEDIA")
    EM_QDSP6 => Some("EM_QDSP6")
    EM_8051 => Some("EM_8051")
    EM_STXP7X => Some("EM_STXP7X")
    EM_NDS32 => Some("EM_NDS32")
    EM_ECOG1X => Some("EM_ECOG1X")
    EM_MAXQ30 => Some("EM_MAXQ30")
    EM_XIMO16 => Some("EM_XIMO16")
    EM_MANIK => Some("EM_MANIK")
    EM_CRAYNV2 => Some("EM_CRAYNV2")
    EM_RX => Some("EM_RX")
    EM_METAG => Some("EM_METAG")
    EM_MCST_ELBRUS => Some("EM_MCST_ELBRUS")
    EM_ECOG16 => Some("EM_ECOG16")
    EM_CR16 => Some("EM_CR16")
    EM_ETPU => Some("EM_ETPU")
    EM_SLE9X => Some("EM_SLE9X")
    EM_L10M => Some("EM_L10M")
    EM_K10M => Some("EM_K10M")
    EM_AARCH64 => Some("EM_AARCH64")
    EM_AVR32 => Some("EM_AVR32")
    EM_STM8 => Some("EM_STM8")
    EM_TILE64 => Some("EM_TILE64")
    EM_TILEPRO => Some("EM_TILEPRO")
    EM_MICROBLAZE => Some("EM_MICROBLAZE")
    EM_CUDA => Some("EM_CUDA")
    EM_TILEGX => Some("EM_TILEGX")
    EM_CLOUDSHIELD => Some("EM_CLOUDSHIELD")
    EM_COREA_1ST => Some("EM_COREA_1ST")
    EM_COREA_2ND => Some("EM_COREA_2ND")
    EM_ARC_COMPACT2 => Some("EM_ARC_COMPACT2")
    EM_OPEN8 => Some("EM_OPEN8")
    EM_RL78 => Some("EM_RL78")
    EM_VIDEOCORE5 => Some("EM_VIDEOCORE5")
    EM_78KOR => Some("EM_78KOR")
    EM_56800EX => Some("EM_56800EX")
    EM_BA1 => Some("EM_BA1")
    EM_BA2 => Some("EM_BA2")
    EM_XCORE => Some("EM_XCORE")
    EM_MCHP_PIC => Some("EM_MCHP_PIC")
    EM_INTEL205 => Some("EM_INTEL205")
    EM_INTEL206 => Some("EM_INTEL206")
    EM_INTEL207 => Some("EM_INTEL207")
    EM_INTEL208 => Some("EM_INTEL208")
    EM_INTEL209 => Some("EM_INTEL209")
    EM_KM32 => Some("EM_KM32")
    EM_KMX32 => Some("EM_KMX32")
    EM_KMX16 => Some("EM_KMX16")
    EM_KMX8 => Some("EM_KMX8")
    EM_KVARC => Some("EM_KVARC")
    EM_CDP => Some("EM_CDP")
    EM_COGE => Some("EM_COGE")
    EM_COOL => Some("EM_COOL")
    EM_NORC => Some("EM_NORC")
    EM_CSR_KALIMBA => Some("EM_CSR_KALIMBA")
    EM_Z80 => Some("EM_Z80")
    EM_VISIUM => Some("EM_VISIUM")
    EM_FT32 => Some("EM_FT32")
    EM_MOXIE => Some("EM_MOXIE")
    EM_AMDGPU => Some("EM_AMDGPU")
    EM_RISCV => Some("EM_RISCV")
    EM_BPF => Some("EM_BPF")
    EM_LOONGARCH => Some("EM_LOONGARCH")
    _ => None
  }
}

///|
/// Return a symbolic machine name, or a hexadecimal fallback for unknown values.
pub fn e_machine_to_string(e_machine : UInt16) -> String {
  match e_machine_to_str(e_machine) {
    Some(s) => s
    None => "e_machine(0x" + e_machine.to_string(radix=16) + ")"
  }
}

///|
/// Return the symbolic `SHT_*` name for a known section-header type.
pub fn sh_type_to_str(sh_type : UInt) -> String? {
  match sh_type {
    SHT_NULL => Some("SHT_NULL")
    SHT_PROGBITS => Some("SHT_PROGBITS")
    SHT_SYMTAB => Some("SHT_SYMTAB")
    SHT_STRTAB => Some("SHT_STRTAB")
    SHT_RELA => Some("SHT_RELA")
    SHT_HASH => Some("SHT_HASH")
    SHT_DYNAMIC => Some("SHT_DYNAMIC")
    SHT_NOTE => Some("SHT_NOTE")
    SHT_NOBITS => Some("SHT_NOBITS")
    SHT_REL => Some("SHT_REL")
    SHT_SHLIB => Some("SHT_SHLIB")
    SHT_DYNSYM => Some("SHT_DYNSYM")
    SHT_INIT_ARRAY => Some("SHT_INIT_ARRAY")
    SHT_FINI_ARRAY => Some("SHT_FINI_ARRAY")
    SHT_PREINIT_ARRAY => Some("SHT_PREINIT_ARRAY")
    SHT_GROUP => Some("SHT_GROUP")
    SHT_SYMTAB_SHNDX => Some("SHT_SYMTAB_SHNDX")
    SHT_GNU_ATTRIBUTES => Some("SHT_GNU_ATTRIBUTES")
    SHT_GNU_HASH => Some("SHT_GNU_HASH")
    SHT_GNU_LIBLIST => Some("SHT_GNU_LIBLIST")
    SHT_GNU_VERDEF => Some("SHT_GNU_VERDEF")
    SHT_GNU_VERNEED => Some("SHT_GNU_VERNEED")
    SHT_GNU_VERSYM => Some("SHT_GNU_VERSYM")
    _ => None
  }
}

///|
/// Return a symbolic section type name, or a hexadecimal fallback for unknown values.
pub fn sh_type_to_string(sh_type : UInt) -> String {
  match sh_type_to_str(sh_type) {
    Some(s) => s
    None => "sh_type(0x" + sh_type.to_string(radix=16) + ")"
  }
}

///|
/// Return a compact `RWE` permission string for simple `p_flags` values.
pub fn p_flags_to_string(p_flags : UInt) -> String {
  if p_flags < 8U {
    let r = if (p_flags & PF_R) != 0U { "R" } else { " " }
    let w = if (p_flags & PF_W) != 0U { "W" } else { " " }
    let x = if (p_flags & PF_X) != 0U { "E" } else { " " }
    r + w + x
  } else {
    "p_flags(0x" + p_flags.to_string(radix=16) + ")"
  }
}

///|
/// Return the symbolic `PT_*` name for a known program-header type.
pub fn p_type_to_str(p_type : UInt) -> String? {
  match p_type {
    PT_NULL => Some("PT_NULL")
    PT_LOAD => Some("PT_LOAD")
    PT_DYNAMIC => Some("PT_DYNAMIC")
    PT_INTERP => Some("PT_INTERP")
    PT_NOTE => Some("PT_NOTE")
    PT_SHLIB => Some("PT_SHLIB")
    PT_PHDR => Some("PT_PHDR")
    PT_TLS => Some("PT_TLS")
    PT_GNU_EH_FRAME => Some("PT_GNU_EH_FRAME")
    PT_GNU_STACK => Some("PT_GNU_STACK")
    PT_GNU_RELRO => Some("PT_GNU_RELRO")
    PT_GNU_PROPERTY => Some("PT_GNU_PROPERTY")
    _ => None
  }
}

///|
/// Return a symbolic program-header type name, or a hexadecimal fallback for unknown values.
pub fn p_type_to_string(p_type : UInt) -> String {
  match p_type_to_str(p_type) {
    Some(s) => s
    None => "p_type(0x" + p_type.to_string(radix=16) + ")"
  }
}

///|
/// Return the symbolic `STT_*` name for a known symbol type.
pub fn st_symtype_to_str(st_symtype : Byte) -> String? {
  match st_symtype {
    STT_NOTYPE => Some("STT_NOTYPE")
    STT_OBJECT => Some("STT_OBJECT")
    STT_FUNC => Some("STT_FUNC")
    STT_SECTION => Some("STT_SECTION")
    STT_FILE => Some("STT_FILE")
    STT_COMMON => Some("STT_COMMON")
    STT_TLS => Some("STT_TLS")
    STT_GNU_IFUNC => Some("STT_GNU_IFUNC")
    _ => None
  }
}

///|
/// Return a symbolic symbol type name, or a hexadecimal fallback for unknown values.
pub fn st_symtype_to_string(st_symtype : Byte) -> String {
  match st_symtype_to_str(st_symtype) {
    Some(s) => s
    None => "st_symtype(0x" + st_symtype.to_uint().to_string(radix=16) + ")"
  }
}

///|
/// Return the symbolic `STB_*` name for a known symbol binding.
pub fn st_bind_to_str(st_bind : Byte) -> String? {
  match st_bind {
    STB_LOCAL => Some("STB_LOCAL")
    STB_GLOBAL => Some("STB_GLOBAL")
    STB_WEAK => Some("STB_WEAK")
    STB_GNU_UNIQUE => Some("STB_GNU_UNIQUE")
    _ => None
  }
}

///|
/// Return a symbolic symbol binding name, or a hexadecimal fallback for unknown values.
pub fn st_bind_to_string(st_bind : Byte) -> String {
  match st_bind_to_str(st_bind) {
    Some(s) => s
    None => "st_bind(0x\{st_bind.to_uint().to_string(radix=16)})"
  }
}

///|
/// Return the symbolic `STV_*` name for a known symbol visibility.
pub fn st_vis_to_str(st_vis : Byte) -> String? {
  match st_vis {
    STV_DEFAULT => Some("STV_DEFAULT")
    STV_INTERNAL => Some("STV_INTERNAL")
    STV_HIDDEN => Some("STV_HIDDEN")
    STV_PROTECTED => Some("STV_PROTECTED")
    _ => None
  }
}

///|
/// Return a symbolic symbol visibility name, or a hexadecimal fallback for unknown values.
pub fn st_vis_to_string(st_vis : Byte) -> String {
  match st_vis_to_str(st_vis) {
    Some(s) => s
    None => "st_vis(0x" + st_vis.to_uint().to_string(radix=16) + ")"
  }
}

///|
/// Return the symbolic `ELFCOMPRESS_*` name for a known compression type.
pub fn ch_type_to_str(ch_type : UInt) -> String? {
  match ch_type {
    ELFCOMPRESS_ZLIB => Some("ELFCOMPRESS_ZLIB")
    ELFCOMPRESS_ZSTD => Some("ELFCOMPRESS_ZSTD ")
    _ => None
  }
}

///|
/// Return the GNU ABI-tag OS name for a known ABI-tag descriptor value.
pub fn note_abi_tag_os_to_str(os : UInt) -> String? {
  match os {
    ELF_NOTE_GNU_ABI_TAG_OS_LINUX => Some("Linux")
    ELF_NOTE_GNU_ABI_TAG_OS_GNU => Some("GNU")
    ELF_NOTE_GNU_ABI_TAG_OS_SOLARIS2 => Some("Solaris")
    ELF_NOTE_GNU_ABI_TAG_OS_FREEBSD => Some("FreeBSD")
    _ => None
  }
}

///|
/// Return the symbolic `DT_*` name for a known dynamic tag.
pub fn d_tag_to_str(d_tag : Int64) -> String? {
  match d_tag {
    DT_NULL => Some("DT_NULL")
    DT_NEEDED => Some("DT_NEEDED")
    DT_PLTRELSZ => Some("DT_PLTRELSZ")
    DT_PLTGOT => Some("DT_PLTGOT")
    DT_HASH => Some("DT_HASH")
    DT_STRTAB => Some("DT_STRTAB")
    DT_SYMTAB => Some("DT_SYMTAB")
    DT_RELA => Some("DT_RELA")
    DT_RELASZ => Some("DT_RELASZ")
    DT_RELAENT => Some("DT_RELAENT")
    DT_STRSZ => Some("DT_STRSZ")
    DT_SYMENT => Some("DT_SYMENT")
    DT_INIT => Some("DT_INIT")
    DT_FINI => Some("DT_FINI")
    DT_SONAME => Some("DT_SONAME")
    DT_RPATH => Some("DT_RPATH")
    DT_SYMBOLIC => Some("DT_SYMBOLIC")
    DT_REL => Some("DT_REL")
    DT_RELSZ => Some("DT_RELSZ")
    DT_RELENT => Some("DT_RELENT")
    DT_PLTREL => Some("DT_PLTREL")
    DT_DEBUG => Some("DT_DEBUG")
    DT_TEXTREL => Some("DT_TEXTREL")
    DT_JMPREL => Some("DT_JMPREL")
    DT_BIND_NOW => Some("DT_BIND_NOW")
    DT_INIT_ARRAY => Some("DT_INIT_ARRAY")
    DT_FINI_ARRAY => Some("DT_FINI_ARRAY")
    DT_INIT_ARRAYSZ => Some("DT_INIT_ARRAYSZ")
    DT_FINI_ARRAYSZ => Some("DT_FINI_ARRAYSZ")
    DT_RUNPATH => Some("DT_RUNPATH")
    DT_FLAGS => Some("DT_FLAGS")
    DT_PREINIT_ARRAY => Some("DT_PREINIT_ARRAY")
    DT_PREINIT_ARRAYSZ => Some("DT_PREINIT_ARRAYSZ")
    DT_SYMTAB_SHNDX => Some("DT_SYMTAB_SHNDX")
    DT_GUILE_GC_ROOT => Some("DT_GUILE_GC_ROOT")
    DT_GUILE_GC_ROOT_SZ => Some("DT_GUILE_GC_ROOT_SZ")
    DT_GUILE_ENTRY => Some("DT_GUILE_ENTRY")
    DT_GUILE_VM_VERSION => Some("DT_GUILE_VM_VERSION")
    DT_GUILE_FRAME_MAPS => Some("DT_GUILE_FRAME_MAPS")
    DT_LOOS => Some("DT_LOOS")
    DT_GNU_PRELINKED => Some("DT_GNU_PRELINKED")
    DT_GNU_CONFLICTSZ => Some("DT_GNU_CONFLICTSZ")
    DT_GNU_LIBLISTSZ => Some("DT_GNU_LIBLISTSZ")
    DT_CHECKSUM => Some("DT_CHECKSUM")
    DT_PLTPADSZ => Some("DT_PLTPADSZ")
    DT_MOVEENT => Some("DT_MOVEENT")
    DT_MOVESZ => Some("DT_MOVESZ")
    DT_FEATURE_1 => Some("DT_FEATURE_1")
    DT_POSFLAG_1 => Some("DT_POSFLAG_1")
    DT_SYMINSZ => Some("DT_SYMINSZ")
    DT_SYMINENT => Some("DT_SYMINENT")
    DT_GNU_HASH => Some("DT_GNU_HASH")
    DT_TLSDESC_PLT => Some("DT_TLSDESC_PLT")
    DT_TLSDESC_GOT => Some("DT_TLSDESC_GOT")
    DT_GNU_CONFLICT => Some("DT_GNU_CONFLICT")
    DT_GNU_LIBLIST => Some("DT_GNU_LIBLIST")
    DT_CONFIG => Some("DT_CONFIG")
    DT_DEPAUDIT => Some("DT_DEPAUDIT")
    DT_AUDIT => Some("DT_AUDIT")
    DT_PLTPAD => Some("DT_PLTPAD")
    DT_MOVETAB => Some("DT_MOVETAB")
    DT_SYMINFO => Some("DT_SYMINFO")
    DT_VERSYM => Some("DT_VERSYM")
    DT_RELACOUNT => Some("DT_RELACOUNT")
    DT_RELCOUNT => Some("DT_RELCOUNT")
    DT_FLAGS_1 => Some("DT_FLAGS_1")
    DT_VERDEF => Some("DT_VERDEF")
    DT_VERDEFNUM => Some("DT_VERDEFNUM")
    DT_VERNEED => Some("DT_VERNEED")
    DT_VERNEEDNUM => Some("DT_VERNEEDNUM")
    DT_HIOS => Some("DT_HIOS")
    DT_LOPROC => Some("DT_LOPROC")
    DT_HIPROC => Some("DT_HIPROC")
    _ => None
  }
}
