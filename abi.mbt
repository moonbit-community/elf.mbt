// ELF ABI constants used by the parser and exposed for callers that need to
// inspect raw header fields.
//
// Constants retain the original ELF names (`EI_*`,
// `ET_*`, `SHT_*`, `PT_*`, `DT_*`, `R_*`, and so on) so values from parsed
// headers can be compared directly with the System V ABI documentation.

// Indexes within the 16-byte `e_ident` identity array at the start of every ELF
// file. These positions are used before endianness and word size are known.

///|
pub const EI_MAG0 : Int = 0

///|
pub const EI_MAG1 : Int = 1

///|
pub const EI_MAG2 : Int = 2

///|
pub const EI_MAG3 : Int = 3

///|
pub const EI_CLASS : Int = 4

///|
pub const EI_DATA : Int = 5

///|
pub const EI_VERSION : Int = 6

///|
pub const EI_OSABI : Int = 7

///|
pub const EI_ABIVERSION : Int = 8

///|
pub const EI_PAD : Int = 9

///|
pub const EI_NIDENT : Int = 16

// Magic bytes identifying an ELF object. The first four bytes must be
// `0x7f, 'E', 'L', 'F'`.

///|
pub const ELFMAG0 : Byte = 0x7f

///|
pub const ELFMAG1 : Byte = 0x45

///|
pub const ELFMAG2 : Byte = 0x4c

///|
pub const ELFMAG3 : Byte = 0x46

///|
pub const ELFMAGIC : Bytes = b"\x7fELF"

// Object class values stored in `e_ident[EI_CLASS]`.

///|
pub const ELFCLASSNONE : Byte = 0

///|
pub const ELFCLASS32 : Byte = 1

///|
pub const ELFCLASS64 : Byte = 2

// Data-encoding values stored in `e_ident[EI_DATA]`.

///|
pub const ELFDATANONE : Byte = 0

///|
pub const ELFDATA2LSB : Byte = 1

///|
pub const ELFDATA2MSB : Byte = 2

// OS ABI identifiers stored in `e_ident[EI_OSABI]`.

///|
pub const ELFOSABI_NONE : Byte = 0

///|
pub const ELFOSABI_SYSV : Byte = 0

///|
pub const ELFOSABI_HPUX : Byte = 1

///|
pub const ELFOSABI_NETBSD : Byte = 2

///|
pub const ELFOSABI_GNU : Byte = 3

///|
pub const ELFOSABI_LINUX : Byte = 3

///|
pub const ELFOSABI_SOLARIS : Byte = 6

///|
pub const ELFOSABI_AIX : Byte = 7

///|
pub const ELFOSABI_IRIX : Byte = 8

///|
pub const ELFOSABI_FREEBSD : Byte = 9

///|
pub const ELFOSABI_TRU64 : Byte = 10

///|
pub const ELFOSABI_MODESTO : Byte = 11

///|
pub const ELFOSABI_OPENBSD : Byte = 12

///|
pub const ELFOSABI_OPENVMS : Byte = 13

///|
pub const ELFOSABI_NSK : Byte = 14

///|
pub const ELFOSABI_AROS : Byte = 15

///|
pub const ELFOSABI_FENIXOS : Byte = 16

///|
pub const ELFOSABI_CLOUDABI : Byte = 17

///|
pub const ELFOSABI_OPENVOS : Byte = 18

// ELF file types stored in `FileHeader.e_type`.

///|
pub const ET_NONE : UInt16 = 0

///|
pub const ET_REL : UInt16 = 1

///|
pub const ET_EXEC : UInt16 = 2

///|
pub const ET_DYN : UInt16 = 3

///|
pub const ET_CORE : UInt16 = 4

///|
pub const ET_LOOS : UInt16 = 0xfe00

///|
pub const ET_HIOS : UInt16 = 0xfeff

///|
pub const ET_LOPROC : UInt16 = 0xff00

///|
pub const ET_HIPROC : UInt16 = 0xffff

// Machine architecture identifiers stored in `FileHeader.e_machine`.

///|
pub const EM_NONE : UInt16 = 0

///|
pub const EM_M32 : UInt16 = 1

///|
pub const EM_SPARC : UInt16 = 2

///|
pub const EM_386 : UInt16 = 3

///|
pub const EM_68K : UInt16 = 4

///|
pub const EM_88K : UInt16 = 5

///|
pub const EM_IAMCU : UInt16 = 6

///|
pub const EM_860 : UInt16 = 7

///|
pub const EM_MIPS : UInt16 = 8

///|
pub const EM_S370 : UInt16 = 9

///|
pub const EM_MIPS_RS3_LE : UInt16 = 10

///|
pub const EM_PARISC : UInt16 = 15

///|
pub const EM_VPP500 : UInt16 = 17

///|
pub const EM_SPARC32PLUS : UInt16 = 18

///|
pub const EM_960 : UInt16 = 19

///|
pub const EM_PPC : UInt16 = 20

///|
pub const EM_PPC64 : UInt16 = 21

///|
pub const EM_S390 : UInt16 = 22

///|
pub const EM_SPU : UInt16 = 23

///|
pub const EM_V800 : UInt16 = 36

///|
pub const EM_FR20 : UInt16 = 37

///|
pub const EM_RH32 : UInt16 = 38

///|
pub const EM_RCE : UInt16 = 39

///|
pub const EM_ARM : UInt16 = 40

///|
pub const EM_ALPHA : UInt16 = 41

///|
pub const EM_SH : UInt16 = 42

///|
pub const EM_SPARCV9 : UInt16 = 43

///|
pub const EM_TRICORE : UInt16 = 44

///|
pub const EM_ARC : UInt16 = 45

///|
pub const EM_H8_300 : UInt16 = 46

///|
pub const EM_H8_300H : UInt16 = 47

///|
pub const EM_H8S : UInt16 = 48

///|
pub const EM_H8_500 : UInt16 = 49

///|
pub const EM_IA_64 : UInt16 = 50

///|
pub const EM_MIPS_X : UInt16 = 51

///|
pub const EM_COLDFIRE : UInt16 = 52

///|
pub const EM_68HC12 : UInt16 = 53

///|
pub const EM_MMA : UInt16 = 54

///|
pub const EM_PCP : UInt16 = 55

///|
pub const EM_NCPU : UInt16 = 56

///|
pub const EM_NDR1 : UInt16 = 57

///|
pub const EM_STARCORE : UInt16 = 58

///|
pub const EM_ME16 : UInt16 = 59

///|
pub const EM_ST100 : UInt16 = 60

///|
pub const EM_TINYJ : UInt16 = 61

///|
pub const EM_X86_64 : UInt16 = 62

///|
pub const EM_PDSP : UInt16 = 63

///|
pub const EM_PDP10 : UInt16 = 64

///|
pub const EM_PDP11 : UInt16 = 65

///|
pub const EM_FX66 : UInt16 = 66

///|
pub const EM_ST9PLUS : UInt16 = 67

///|
pub const EM_ST7 : UInt16 = 68

///|
pub const EM_68HC16 : UInt16 = 69

///|
pub const EM_68HC11 : UInt16 = 70

///|
pub const EM_68HC08 : UInt16 = 71

///|
pub const EM_68HC05 : UInt16 = 72

///|
pub const EM_SVX : UInt16 = 73

///|
pub const EM_ST19 : UInt16 = 74

///|
pub const EM_VAX : UInt16 = 75

///|
pub const EM_CRIS : UInt16 = 76

///|
pub const EM_JAVELIN : UInt16 = 77

///|
pub const EM_FIREPATH : UInt16 = 78

///|
pub const EM_ZSP : UInt16 = 79

///|
pub const EM_MMIX : UInt16 = 80

///|
pub const EM_HUANY : UInt16 = 81

///|
pub const EM_PRISM : UInt16 = 82

///|
pub const EM_AVR : UInt16 = 83

///|
pub const EM_FR30 : UInt16 = 84

///|
pub const EM_D10V : UInt16 = 85

///|
pub const EM_D30V : UInt16 = 86

///|
pub const EM_V850 : UInt16 = 87

///|
pub const EM_M32R : UInt16 = 88

///|
pub const EM_MN10300 : UInt16 = 89

///|
pub const EM_MN10200 : UInt16 = 90

///|
pub const EM_PJ : UInt16 = 91

///|
pub const EM_OPENRISC : UInt16 = 92

///|
pub const EM_ARC_COMPACT : UInt16 = 93

///|
pub const EM_XTENSA : UInt16 = 94

///|
pub const EM_VIDEOCORE : UInt16 = 95

///|
pub const EM_TMM_GPP : UInt16 = 96

///|
pub const EM_NS32K : UInt16 = 97

///|
pub const EM_TPC : UInt16 = 98

///|
pub const EM_SNP1K : UInt16 = 99

///|
pub const EM_ST200 : UInt16 = 100

///|
pub const EM_IP2K : UInt16 = 101

///|
pub const EM_MAX : UInt16 = 102

///|
pub const EM_CR : UInt16 = 103

///|
pub const EM_F2MC16 : UInt16 = 104

///|
pub const EM_MSP430 : UInt16 = 105

///|
pub const EM_BLACKFIN : UInt16 = 106

///|
pub const EM_SE_C33 : UInt16 = 107

///|
pub const EM_SEP : UInt16 = 108

///|
pub const EM_ARCA : UInt16 = 109

///|
pub const EM_UNICORE : UInt16 = 110

///|
pub const EM_EXCESS : UInt16 = 111

///|
pub const EM_DXP : UInt16 = 112

///|
pub const EM_ALTERA_NIOS2 : UInt16 = 113

///|
pub const EM_CRX : UInt16 = 114

///|
pub const EM_XGATE : UInt16 = 115

///|
pub const EM_C166 : UInt16 = 116

///|
pub const EM_M16C : UInt16 = 117

///|
pub const EM_DSPIC30F : UInt16 = 118

///|
pub const EM_CE : UInt16 = 119

///|
pub const EM_M32C : UInt16 = 120

///|
pub const EM_TSK3000 : UInt16 = 131

///|
pub const EM_RS08 : UInt16 = 132

///|
pub const EM_SHARC : UInt16 = 133

///|
pub const EM_ECOG2 : UInt16 = 134

///|
pub const EM_SCORE7 : UInt16 = 135

///|
pub const EM_DSP24 : UInt16 = 136

///|
pub const EM_VIDEOCORE3 : UInt16 = 137

///|
pub const EM_LATTICEMICO32 : UInt16 = 138

///|
pub const EM_SE_C17 : UInt16 = 139

///|
pub const EM_TI_C6000 : UInt16 = 140

///|
pub const EM_TI_C2000 : UInt16 = 141

///|
pub const EM_TI_C5500 : UInt16 = 142

///|
pub const EM_TI_ARP32 : UInt16 = 143

///|
pub const EM_TI_PRU : UInt16 = 144

///|
pub const EM_MMDSP_PLUS : UInt16 = 160

///|
pub const EM_CYPRESS_M8C : UInt16 = 161

///|
pub const EM_R32C : UInt16 = 162

///|
pub const EM_TRIMEDIA : UInt16 = 163

///|
pub const EM_QDSP6 : UInt16 = 164

///|
pub const EM_8051 : UInt16 = 165

///|
pub const EM_STXP7X : UInt16 = 166

///|
pub const EM_NDS32 : UInt16 = 167

///|
pub const EM_ECOG1 : UInt16 = 168

///|
pub const EM_ECOG1X : UInt16 = 168

///|
pub const EM_MAXQ30 : UInt16 = 169

///|
pub const EM_XIMO16 : UInt16 = 170

///|
pub const EM_MANIK : UInt16 = 171

///|
pub const EM_CRAYNV2 : UInt16 = 172

///|
pub const EM_RX : UInt16 = 173

///|
pub const EM_METAG : UInt16 = 174

///|
pub const EM_MCST_ELBRUS : UInt16 = 175

///|
pub const EM_ECOG16 : UInt16 = 176

///|
pub const EM_CR16 : UInt16 = 177

///|
pub const EM_ETPU : UInt16 = 178

///|
pub const EM_SLE9X : UInt16 = 179

///|
pub const EM_L10M : UInt16 = 180

///|
pub const EM_K10M : UInt16 = 181

///|
pub const EM_AARCH64 : UInt16 = 183

///|
pub const EM_AVR32 : UInt16 = 185

///|
pub const EM_STM8 : UInt16 = 186

///|
pub const EM_TILE64 : UInt16 = 187

///|
pub const EM_TILEPRO : UInt16 = 188

///|
pub const EM_MICROBLAZE : UInt16 = 189

///|
pub const EM_CUDA : UInt16 = 190

///|
pub const EM_TILEGX : UInt16 = 191

///|
pub const EM_CLOUDSHIELD : UInt16 = 192

///|
pub const EM_COREA_1ST : UInt16 = 193

///|
pub const EM_COREA_2ND : UInt16 = 194

///|
pub const EM_ARC_COMPACT2 : UInt16 = 195

///|
pub const EM_OPEN8 : UInt16 = 196

///|
pub const EM_RL78 : UInt16 = 197

///|
pub const EM_VIDEOCORE5 : UInt16 = 198

///|
pub const EM_78KOR : UInt16 = 199

///|
pub const EM_56800EX : UInt16 = 200

///|
pub const EM_BA1 : UInt16 = 201

///|
pub const EM_BA2 : UInt16 = 202

///|
pub const EM_XCORE : UInt16 = 203

///|
pub const EM_MCHP_PIC : UInt16 = 204

///|
pub const EM_INTEL205 : UInt16 = 205

///|
pub const EM_INTEL206 : UInt16 = 206

///|
pub const EM_INTEL207 : UInt16 = 207

///|
pub const EM_INTEL208 : UInt16 = 208

///|
pub const EM_INTEL209 : UInt16 = 209

///|
pub const EM_KM32 : UInt16 = 210

///|
pub const EM_KMX32 : UInt16 = 211

///|
pub const EM_KMX16 : UInt16 = 212

///|
pub const EM_KMX8 : UInt16 = 213

///|
pub const EM_KVARC : UInt16 = 214

///|
pub const EM_CDP : UInt16 = 215

///|
pub const EM_COGE : UInt16 = 216

///|
pub const EM_COOL : UInt16 = 217

///|
pub const EM_NORC : UInt16 = 218

///|
pub const EM_CSR_KALIMBA : UInt16 = 219

///|
pub const EM_Z80 : UInt16 = 220

///|
pub const EM_VISIUM : UInt16 = 221

///|
pub const EM_FT32 : UInt16 = 222

///|
pub const EM_MOXIE : UInt16 = 223

///|
pub const EM_AMDGPU : UInt16 = 224

///|
pub const EM_RISCV : UInt16 = 243

///|
pub const EM_LANAI : UInt16 = 244

///|
pub const EM_BPF : UInt16 = 247

///|
pub const EM_VE : UInt16 = 251

///|
pub const EM_CSKY : UInt16 = 252

///|
pub const EM_LOONGARCH : UInt16 = 258

///|
pub const EM_FRV : UInt16 = 0x5441

// ELF object version values. This parser supports `EV_CURRENT`.

///|
pub const EV_NONE : Byte = 0

///|
pub const EV_CURRENT : Byte = 1

// Sentinel for extended program-header counts. When `e_phnum == PN_XNUM`, the
// actual count is read from section header 0's `sh_info`.

///|
pub const PN_XNUM : UInt16 = 0xffff

// Program-header permission flags stored in `ProgramHeader.p_flags`.

///|
pub const PF_NONE : UInt = 0U

///|
pub const PF_X : UInt = 1U

///|
pub const PF_W : UInt = 2U

///|
pub const PF_R : UInt = 4U

///|
pub const PF_MASKOS : UInt = 0x0ff00000U

///|
pub const PF_MASKPROC : UInt = 0xf0000000U

// Program-header segment types stored in `ProgramHeader.p_type`.

///|
pub const PT_NULL : UInt = 0U

///|
pub const PT_LOAD : UInt = 1U

///|
pub const PT_DYNAMIC : UInt = 2U

///|
pub const PT_INTERP : UInt = 3U

///|
pub const PT_NOTE : UInt = 4U

///|
pub const PT_SHLIB : UInt = 5U

///|
pub const PT_PHDR : UInt = 6U

///|
pub const PT_TLS : UInt = 7U

///|
pub const PT_GNU_EH_FRAME : UInt = 0x6474e550U

///|
pub const PT_GNU_STACK : UInt = 0x6474e551U

///|
pub const PT_GNU_RELRO : UInt = 0x6474e552U

///|
pub const PT_GNU_PROPERTY : UInt = 0x6474e553U

///|
pub const PT_LOOS : UInt = 0x60000000U

///|
pub const PT_HIOS : UInt = 0x6fffffffU

///|
pub const PT_LOPROC : UInt = 0x70000000U

///|
pub const PT_HIPROC : UInt = 0x7fffffffU

// Section-header types stored in `SectionHeader.sh_type`.

///|
pub const SHT_NULL : UInt = 0U

///|
pub const SHT_PROGBITS : UInt = 1U

///|
pub const SHT_SYMTAB : UInt = 2U

///|
pub const SHT_STRTAB : UInt = 3U

///|
pub const SHT_RELA : UInt = 4U

///|
pub const SHT_HASH : UInt = 5U

///|
pub const SHT_DYNAMIC : UInt = 6U

///|
pub const SHT_NOTE : UInt = 7U

///|
pub const SHT_NOBITS : UInt = 8U

///|
pub const SHT_REL : UInt = 9U

///|
pub const SHT_SHLIB : UInt = 10U

///|
pub const SHT_DYNSYM : UInt = 11U

///|
pub const SHT_INIT_ARRAY : UInt = 14U

///|
pub const SHT_FINI_ARRAY : UInt = 15U

///|
pub const SHT_PREINIT_ARRAY : UInt = 16U

///|
pub const SHT_GROUP : UInt = 17U

///|
pub const SHT_SYMTAB_SHNDX : UInt = 18U

///|
pub const SHT_LOOS : UInt = 0x60000000U

///|
pub const SHT_GNU_ATTRIBUTES : UInt = 0x6ffffff5U

///|
pub const SHT_GNU_HASH : UInt = 0x6ffffff6U

///|
pub const SHT_GNU_LIBLIST : UInt = 0x6ffffff7U

///|
pub const SHT_GNU_VERDEF : UInt = 0x6ffffffdU

///|
pub const SHT_GNU_VERNEED : UInt = 0x6ffffffeU

///|
pub const SHT_GNU_VERSYM : UInt = 0x6fffffffU

///|
pub const SHT_HIOS : UInt = 0x6fffffffU

///|
pub const SHT_LOPROC : UInt = 0x70000000U

///|
pub const SHT_IA_64_EXT : UInt = 0x70000000U // SHT_LOPROC + 0U

///|
pub const SHT_IA_64_UNWIND : UInt = 0x70000001U // SHT_LOPROC + 1U

///|
pub const SHT_HIPROC : UInt = 0x7fffffffU

///|
pub const SHT_LOUSER : UInt = 0x80000000U

///|
pub const SHT_HIUSER : UInt = 0x8fffffffU

// Special section indexes used by symbols and header extension mechanisms.

///|
pub const SHN_UNDEF : UInt16 = 0

///|
pub const SHN_ABS : UInt16 = 0xfff1

///|
pub const SHN_COMMON : UInt16 = 0xfff2

///|
pub const SHN_XINDEX : UInt16 = 0xffff

// Section flags stored in `SectionHeader.sh_flags`.

///|
pub const SHF_NONE : UInt = 0U

///|
pub const SHF_WRITE : UInt = 1U

///|
pub const SHF_ALLOC : UInt = 1U << 1

///|
pub const SHF_EXECINSTR : UInt = 1U << 2

///|
pub const SHF_MERGE : UInt = 1U << 4

///|
pub const SHF_STRINGS : UInt = 1U << 5

///|
pub const SHF_INFO_LINK : UInt = 1U << 6

///|
pub const SHF_LINK_ORDER : UInt = 1U << 7

///|
pub const SHF_OS_NONCONFORMING : UInt = 1U << 8

///|
pub const SHF_GROUP : UInt = 1U << 9

///|
pub const SHF_TLS : UInt = 1U << 10

///|
pub const SHF_COMPRESSED : UInt = 1U << 11

///|
pub const SHF_MASKOS : UInt = 0x0ff00000U

///|
pub const SHF_MASKPROC : UInt = 0xf0000000U

// Symbol types: low nibble of `Symbol.st_info`.

///|
pub const STT_NOTYPE : Byte = 0

///|
pub const STT_OBJECT : Byte = 1

///|
pub const STT_FUNC : Byte = 2

///|
pub const STT_SECTION : Byte = 3

///|
pub const STT_FILE : Byte = 4

///|
pub const STT_COMMON : Byte = 5

///|
pub const STT_TLS : Byte = 6

///|
pub const STT_GNU_IFUNC : Byte = 10

///|
pub const STT_LOOS : Byte = 10

///|
pub const STT_HIOS : Byte = 12

///|
pub const STT_LOPROC : Byte = 13

///|
pub const STT_HIPROC : Byte = 15

// Symbol bindings: high nibble of `Symbol.st_info`.

///|
pub const STB_LOCAL : Byte = 0

///|
pub const STB_GLOBAL : Byte = 1

///|
pub const STB_WEAK : Byte = 2

///|
pub const STB_GNU_UNIQUE : Byte = 10

///|
pub const STB_LOOS : Byte = 10

///|
pub const STB_HIOS : Byte = 12

///|
pub const STB_LOPROC : Byte = 13

///|
pub const STB_MIPS_SPLIT_COMMON : Byte = STB_LOPROC

///|
pub const STB_HIPROC : Byte = 15

// Symbol visibility values: low two bits of `Symbol.st_other`.

///|
pub const STV_DEFAULT : Byte = 0

///|
pub const STV_INTERNAL : Byte = 1

///|
pub const STV_HIDDEN : Byte = 2

///|
pub const STV_PROTECTED : Byte = 3

// Dynamic table tags stored in `Dyn.d_tag`.

///|
pub const DT_NULL : Int64 = 0L

///|
pub const DT_NEEDED : Int64 = 1L

///|
pub const DT_PLTRELSZ : Int64 = 2L

///|
pub const DT_PLTGOT : Int64 = 3L

///|
pub const DT_HASH : Int64 = 4L

///|
pub const DT_STRTAB : Int64 = 5L

///|
pub const DT_SYMTAB : Int64 = 6L

///|
pub const DT_RELA : Int64 = 7L

///|
pub const DT_RELASZ : Int64 = 8L

///|
pub const DT_RELAENT : Int64 = 9L

///|
pub const DT_STRSZ : Int64 = 10L

///|
pub const DT_SYMENT : Int64 = 11L

///|
pub const DT_INIT : Int64 = 12L

///|
pub const DT_FINI : Int64 = 13L

///|
pub const DT_SONAME : Int64 = 14L

///|
pub const DT_RPATH : Int64 = 15L

///|
pub const DT_SYMBOLIC : Int64 = 16L

///|
pub const DT_REL : Int64 = 17L

///|
pub const DT_RELSZ : Int64 = 18L

///|
pub const DT_RELENT : Int64 = 19L

///|
pub const DT_PLTREL : Int64 = 20L

///|
pub const DT_DEBUG : Int64 = 21L

///|
pub const DT_TEXTREL : Int64 = 22L

///|
pub const DT_JMPREL : Int64 = 23L

///|
pub const DT_BIND_NOW : Int64 = 24L

///|
pub const DT_INIT_ARRAY : Int64 = 25L

///|
pub const DT_FINI_ARRAY : Int64 = 26L

///|
pub const DT_INIT_ARRAYSZ : Int64 = 27L

///|
pub const DT_FINI_ARRAYSZ : Int64 = 28L

///|
pub const DT_RUNPATH : Int64 = 29L

///|
pub const DT_FLAGS : Int64 = 30L

///|
pub const DT_PREINIT_ARRAY : Int64 = 32L

///|
pub const DT_PREINIT_ARRAYSZ : Int64 = 33L

///|
pub const DT_SYMTAB_SHNDX : Int64 = 34L

///|
pub const DT_GUILE_GC_ROOT : Int64 = 0x37146000L

///|
pub const DT_GUILE_GC_ROOT_SZ : Int64 = 0x37146001L

///|
pub const DT_GUILE_ENTRY : Int64 = 0x37146002L

///|
pub const DT_GUILE_VM_VERSION : Int64 = 0x37146003L

///|
pub const DT_GUILE_FRAME_MAPS : Int64 = 0x37146004L

///|
pub const DT_LOOS : Int64 = 0x6000000DL

///|
pub const DT_GNU_PRELINKED : Int64 = 0x6ffffdf5L

///|
pub const DT_GNU_CONFLICTSZ : Int64 = 0x6ffffdf6L

///|
pub const DT_GNU_LIBLISTSZ : Int64 = 0x6ffffdf7L

///|
pub const DT_CHECKSUM : Int64 = 0x6ffffdf8L

///|
pub const DT_PLTPADSZ : Int64 = 0x6ffffdf9L

///|
pub const DT_MOVEENT : Int64 = 0x6ffffdfaL

///|
pub const DT_MOVESZ : Int64 = 0x6ffffdfbL

///|
pub const DT_FEATURE_1 : Int64 = 0x6ffffdfcL

///|
pub const DT_POSFLAG_1 : Int64 = 0x6ffffdfdL

///|
pub const DT_SYMINSZ : Int64 = 0x6ffffdfeL

///|
pub const DT_SYMINENT : Int64 = 0x6ffffdffL

///|
pub const DT_GNU_HASH : Int64 = 0x6ffffef5L

///|
pub const DT_TLSDESC_PLT : Int64 = 0x6ffffef6L

///|
pub const DT_TLSDESC_GOT : Int64 = 0x6ffffef7L

///|
pub const DT_GNU_CONFLICT : Int64 = 0x6ffffef8L

///|
pub const DT_GNU_LIBLIST : Int64 = 0x6ffffef9L

///|
pub const DT_CONFIG : Int64 = 0x6ffffefaL

///|
pub const DT_DEPAUDIT : Int64 = 0x6ffffefbL

///|
pub const DT_AUDIT : Int64 = 0x6ffffefcL

///|
pub const DT_PLTPAD : Int64 = 0x6ffffefdL

///|
pub const DT_MOVETAB : Int64 = 0x6ffffefeL

///|
pub const DT_SYMINFO : Int64 = 0x6ffffeffL

///|
pub const DT_VERSYM : Int64 = 0x6ffffff0L

///|
pub const DT_RELACOUNT : Int64 = 0x6ffffff9L

///|
pub const DT_RELCOUNT : Int64 = 0x6ffffffaL

///|
pub const DT_FLAGS_1 : Int64 = 0x6ffffffbL

///|
pub const DT_VERDEF : Int64 = 0x6ffffffcL

///|
pub const DT_VERDEFNUM : Int64 = 0x6ffffffdL

///|
pub const DT_VERNEED : Int64 = 0x6ffffffeL

///|
pub const DT_VERNEEDNUM : Int64 = 0x6fffffffL

///|
pub const DT_HIOS : Int64 = 0x6ffff000L

///|
pub const DT_LOPROC : Int64 = 0x70000000L

///|
pub const DT_HIPROC : Int64 = 0x7fffffffL

// Dynamic flag bitmasks stored in `DT_FLAGS`, `DT_FLAGS_1`, and
// `DT_POSFLAG_1` entries.

///|
pub const DF_ORIGIN : Int64 = 0x1L

///|
pub const DF_SYMBOLIC : Int64 = 0x2L

///|
pub const DF_TEXTREL : Int64 = 0x4L

///|
pub const DF_BIND_NOW : Int64 = 0x8L

///|
pub const DF_STATIC_TLS : Int64 = 0x10L

///|
pub const DF_1_NOW : Int64 = 0x00000001L

///|
pub const DF_1_GLOBAL : Int64 = 0x00000002L

///|
pub const DF_1_GROUP : Int64 = 0x00000004L

///|
pub const DF_1_NODELETE : Int64 = 0x00000008L

///|
pub const DF_1_LOADFLTR : Int64 = 0x00000010L

///|
pub const DF_1_INITFIRST : Int64 = 0x00000020L

///|
pub const DF_1_NOOPEN : Int64 = 0x00000040L

///|
pub const DF_1_ORIGIN : Int64 = 0x00000080L

///|
pub const DF_1_DIRECT : Int64 = 0x00000100L

///|
pub const DF_1_TRANS : Int64 = 0x00000200L

///|
pub const DF_1_INTERPOSE : Int64 = 0x00000400L

///|
pub const DF_1_NODEFLIB : Int64 = 0x00000800L

///|
pub const DF_1_NODUMP : Int64 = 0x00001000L

///|
pub const DF_1_CONFALT : Int64 = 0x00002000L

///|
pub const DF_1_ENDFILTEE : Int64 = 0x00004000L

///|
pub const DF_1_DISPRELDNE : Int64 = 0x00008000L

///|
pub const DF_1_DISPRELPND : Int64 = 0x00010000L

///|
pub const DF_1_NODIRECT : Int64 = 0x00020000L

///|
pub const DF_1_IGNMULDEF : Int64 = 0x00040000L

///|
pub const DF_1_NOKSYMS : Int64 = 0x00080000L

///|
pub const DF_1_NOHDR : Int64 = 0x00100000L

///|
pub const DF_1_EDITED : Int64 = 0x00200000L

///|
pub const DF_1_NORELOC : Int64 = 0x00400000L

///|
pub const DF_1_SYMINTPOSE : Int64 = 0x00800000L

///|
pub const DF_1_GLOBAUDIT : Int64 = 0x01000000L

///|
pub const DF_1_SINGLETON : Int64 = 0x02000000L

///|
pub const DF_1_STUB : Int64 = 0x04000000L

///|
pub const DF_1_PIE : Int64 = 0x08000000L

///|
pub const DF_1_KMOD : Int64 = 0x10000000L

///|
pub const DF_1_WEAKFILTER : Int64 = 0x20000000L

///|
pub const DF_1_NOCOMMON : Int64 = 0x40000000L

///|
pub const DTF_1_PARINIT : Int64 = 0x00000001L

///|
pub const DTF_1_CONFEXP : Int64 = 0x00000002L

///|
pub const DF_P1_LAZYLOAD : Int64 = 0x00000001L

///|
pub const DF_P1_GROUPPERM : Int64 = 0x00000002L

// GNU symbol-version constants used by `.gnu.version`,
// `.gnu.version_d`, and `.gnu.version_r`.

///|
pub const VER_NDX_LOCAL : UInt16 = 0

///|
pub const VER_NDX_GLOBAL : UInt16 = 1

///|
pub const VER_NDX_VERSION : UInt16 = 0x7fff

///|
pub const VER_NDX_HIDDEN : UInt16 = 0x8000

///|
pub const VER_DEF_CURRENT : UInt16 = 1

///|
pub const VER_NEED_CURRENT : UInt16 = 1

///|
pub const VER_FLG_BASE : UInt16 = 0x1

///|
pub const VER_FLG_WEAK : UInt16 = 0x2

///|
pub const VER_FLG_INFO : UInt16 = 0x4

// Compression algorithm identifiers stored in `CompressionHeader.ch_type`.

///|
pub const ELFCOMPRESS_ZLIB : UInt = 1U

///|
pub const ELFCOMPRESS_ZSTD : UInt = 2U

///|
pub const ELFCOMPRESS_LOOS : UInt = 0x60000000U

///|
pub const ELFCOMPRESS_HIOS : UInt = 0x6fffffffU

///|
pub const ELFCOMPRESS_LOPROC : UInt = 0x70000000U

///|
pub const ELFCOMPRESS_HIPROC : UInt = 0x7fffffffU

// ELF note owner names and note type identifiers.

///|
pub const ELF_NOTE_GNU : Bytes = b"GNU\x00"

///|
pub const NT_PRSTATUS : UInt64 = 1UL

///|
pub const NT_PRFPREG : UInt64 = 2UL

///|
pub const NT_FPREGSET : UInt64 = 2UL

///|
pub const NT_PRPSINFO : UInt64 = 3UL

///|
pub const NT_PRXREG : UInt64 = 4UL

///|
pub const NT_TASKSTRUCT : UInt64 = 4UL

///|
pub const NT_PLATFORM : UInt64 = 5UL

///|
pub const NT_AUXV : UInt64 = 6UL

///|
pub const NT_GWINDOWS : UInt64 = 7UL

///|
pub const NT_ASRS : UInt64 = 8UL

///|
pub const NT_PSTATUS : UInt64 = 10UL

///|
pub const NT_PSINFO : UInt64 = 13UL

///|
pub const NT_PRCRED : UInt64 = 14UL

///|
pub const NT_UTSNAME : UInt64 = 15UL

///|
pub const NT_LWPSTATUS : UInt64 = 16UL

///|
pub const NT_LWPSINFO : UInt64 = 17UL

///|
pub const NT_PRFPXREG : UInt64 = 20UL

///|
pub const NT_SIGINFO : UInt64 = 0x53494749UL

///|
pub const NT_FILE : UInt64 = 0x46494c45UL

///|
pub const NT_PRXFPREG : UInt64 = 0x46e62b7fUL

///|
pub const NT_PPC_VMX : UInt64 = 0x100UL

///|
pub const NT_PPC_SPE : UInt64 = 0x101UL

///|
pub const NT_PPC_VSX : UInt64 = 0x102UL

///|
pub const NT_PPC_TAR : UInt64 = 0x103UL

///|
pub const NT_PPC_PPR : UInt64 = 0x104UL

///|
pub const NT_PPC_DSCR : UInt64 = 0x105UL

///|
pub const NT_PPC_EBB : UInt64 = 0x106UL

///|
pub const NT_PPC_PMU : UInt64 = 0x107UL

///|
pub const NT_PPC_TM_CGPR : UInt64 = 0x108UL

///|
pub const NT_PPC_TM_CFPR : UInt64 = 0x109UL

///|
pub const NT_PPC_TM_CVMX : UInt64 = 0x10aUL

///|
pub const NT_PPC_TM_CVSX : UInt64 = 0x10bUL

///|
pub const NT_PPC_TM_SPR : UInt64 = 0x10cUL

///|
pub const NT_PPC_TM_CTAR : UInt64 = 0x10dUL

///|
pub const NT_PPC_TM_CPPR : UInt64 = 0x10eUL

///|
pub const NT_PPC_TM_CDSCR : UInt64 = 0x10fUL

///|
pub const NT_PPC_PKEY : UInt64 = 0x110UL

///|
pub const NT_386_TLS : UInt64 = 0x200UL

///|
pub const NT_386_IOPERM : UInt64 = 0x201UL

///|
pub const NT_X86_XSTATE : UInt64 = 0x202UL

///|
pub const NT_X86_XSAVE_LAYOUT : UInt64 = 0x205UL

///|
pub const NT_ARM_VFP : UInt64 = 0x400UL

///|
pub const NT_ARM_TLS : UInt64 = 0x401UL

///|
pub const NT_ARM_HW_BREAK : UInt64 = 0x402UL

///|
pub const NT_ARM_HW_WATCH : UInt64 = 0x403UL

///|
pub const NT_ARM_SYSTEM_CALL : UInt64 = 0x404UL

///|
pub const NT_ARM_SVE : UInt64 = 0x405UL

///|
pub const NT_ARM_PAC_MASK : UInt64 = 0x406UL

///|
pub const NT_ARM_PACA_KEYS : UInt64 = 0x407UL

///|
pub const NT_ARM_PACG_KEYS : UInt64 = 0x408UL

///|
pub const NT_ARM_TAGGED_ADDR_CTRL : UInt64 = 0x409UL

///|
pub const NT_ARM_PAC_ENABLED_KEYS : UInt64 = 0x40aUL

///|
pub const NT_VMCOREDD : UInt64 = 0x700UL

///|
pub const NT_GNU_ABI_TAG : UInt64 = 1UL

///|
pub const NT_GNU_HWCAP : UInt64 = 2UL

///|
pub const NT_GNU_BUILD_ID : UInt64 = 3UL

///|
pub const NT_GNU_GOLD_VERSION : UInt64 = 4UL

///|
pub const NT_GNU_PROPERTY_TYPE_0 : UInt64 = 5UL

///|
pub const ELF_NOTE_GNU_ABI_TAG_OS_LINUX : UInt = 0U

///|
pub const ELF_NOTE_GNU_ABI_TAG_OS_GNU : UInt = 1U

///|
pub const ELF_NOTE_GNU_ABI_TAG_OS_SOLARIS2 : UInt = 2U

///|
pub const ELF_NOTE_GNU_ABI_TAG_OS_FREEBSD : UInt = 3U

// ARM-specific file flags, section types, segment types, and relocation values.

///|
pub const EF_ARM_ABI_FLOAT_SOFT : UInt = 0x200U

///|
pub const EF_ARM_SOFT_FLOAT : UInt = EF_ARM_ABI_FLOAT_SOFT

///|
pub const EF_ARM_ABI_FLOAT_HARD : UInt = 0x400U

///|
pub const EF_ARM_VFP_FLOAT : UInt = EF_ARM_ABI_FLOAT_HARD

///|
pub const EF_ARM_BE8 : UInt = 0x00800000U

///|
pub const EF_ARM_GCCMASK : UInt = 0x00400FFFU

///|
pub const EF_ARM_EABIMASK : UInt = 0xFF000000U

///|
pub const EF_ARM_EABI_UNKNOWN : UInt = 0x00000000U

///|
pub const EF_ARM_EABI_VER1 : UInt = 0x01000000U

///|
pub const EF_ARM_EABI_VER2 : UInt = 0x02000000U

///|
pub const EF_ARM_EABI_VER3 : UInt = 0x03000000U

///|
pub const EF_ARM_EABI_VER4 : UInt = 0x04000000U

///|
pub const EF_ARM_EABI_VER5 : UInt = 0x05000000U

///|
pub const SHT_ARM_EXIDX : UInt = 0x70000001U

///|
pub const SHT_ARM_PREEMPTMAP : UInt = 0x70000002U

///|
pub const SHT_ARM_ATTRIBUTES : UInt = 0x70000003U

///|
pub const SHT_ARM_DEBUGOVERLAY : UInt = 0x70000004U

///|
pub const SHT_ARM_OVERLAYSECTION : UInt = 0x70000005U

///|
pub const SHF_ARM_PURECODE : UInt64 = 0x20000000UL

///|
pub const PT_ARM_ARCHEXT : UInt = 0x70000000U

///|
pub const PT_ARM_EXIDX : UInt = 0x70000001U

///|
pub const PT_ARM_UNWIND : UInt = 0x70000001U

///|
pub const PT_ARM_ARCHEXT_FMTMSK : UInt = 0xff000000U

///|
pub const PT_ARM_ARCHEXT_FMT_OS : UInt = 0x00000000U

///|
pub const PT_ARM_ARCHEXT_FMT_ABI : UInt = 0x01000000U

///|
pub const PT_ARM_ARCHEXT_PROFMSK : UInt = 0x00ff0000U

///|
pub const PT_ARM_ARCHEXT_PROF_NONE : UInt = 0x00000000U

///|
pub const PT_ARM_ARCHEXT_PROF_ARM : UInt = 0x00410000U

///|
pub const PT_ARM_ARCHEXT_PROF_RT : UInt = 0x00520000U

///|
pub const PT_ARM_ARCHEXT_PROF_MC : UInt = 0x004D0000U

///|
pub const PT_ARM_ARCHEXT_PROF_CLASSIC : UInt = 0x00530000U

///|
pub const PT_ARM_ARCHEXT_ARCHMSK : UInt = 0x000000ffU

///|
pub const PT_ARM_ARCHEXT_ARCH_UNKN : UInt = 0x00U

///|
pub const PT_ARM_ARCHEXT_ARCHV4 : UInt = 0x01U

///|
pub const PT_ARM_ARCHEXT_ARCHV4T : UInt = 0x02U

///|
pub const PT_ARM_ARCHEXT_ARCHV5T : UInt = 0x03U

///|
pub const PT_ARM_ARCHEXT_ARCHV5TE : UInt = 0x04U

///|
pub const PT_ARM_ARCHEXT_ARCHV5TEJ : UInt = 0x05U

///|
pub const PT_ARM_ARCHEXT_ARCHV6 : UInt = 0x06U

///|
pub const PT_ARM_ARCHEXT_ARCHV6KZ : UInt = 0x07U

///|
pub const PT_ARM_ARCHEXT_ARCHV6T2 : UInt = 0x08U

///|
pub const PT_ARM_ARCHEXT_ARCHV6K : UInt = 0x09U

///|
pub const PT_ARM_ARCHEXT_ARCHV7 : UInt = 0x0AU

///|
pub const PT_ARM_ARCHEXT_ARCHV6M : UInt = 0x0BU

///|
pub const PT_ARM_ARCHEXT_ARCHV6SM : UInt = 0x0CU

///|
pub const PT_ARM_ARCHEXT_ARCHV7EM : UInt = 0x0DU

///|
pub const DT_ARM_SYMTABSZ : Int64 = 0x70000001L

///|
pub const DT_ARM_PREEMPTMAP : Int64 = 0x70000002L

///|
pub const R_ARM_NONE : UInt = 0U

///|
pub const R_ARM_PC24 : UInt = 1U

///|
pub const R_ARM_ABS32 : UInt = 2U

///|
pub const R_ARM_REL32 : UInt = 3U

///|
pub const R_ARM_LDR_PC_G0 : UInt = 4U

///|
pub const R_ARM_ABS16 : UInt = 5U

///|
pub const R_ARM_ABS12 : UInt = 6U

///|
pub const R_ARM_THM_ABS5 : UInt = 7U

///|
pub const R_ARM_ABS8 : UInt = 8U

///|
pub const R_ARM_SBREL32 : UInt = 9U

///|
pub const R_ARM_THM_CALL : UInt = 10U

///|
pub const R_ARM_THM_PC8 : UInt = 11U

///|
pub const R_ARM_BREL_ADJ : UInt = 12U

///|
pub const R_ARM_TLS_DESC : UInt = 13U

///|
pub const R_ARM_THM_SWI8 : UInt = 14U

///|
pub const R_ARM_XPC25 : UInt = 15U

///|
pub const R_ARM_THM_XPC22 : UInt = 16U

///|
pub const R_ARM_TLS_DTPMOD32 : UInt = 17U

///|
pub const R_ARM_TLS_DTPOFF32 : UInt = 18U

///|
pub const R_ARM_TLS_TPOFF32 : UInt = 19U

///|
pub const R_ARM_COPY : UInt = 20U

///|
pub const R_ARM_GLOB_DAT : UInt = 21U

///|
pub const R_ARM_JUMP_SLOT : UInt = 22U

///|
pub const R_ARM_RELATIVE : UInt = 23U

///|
pub const R_ARM_GOTOFF32 : UInt = 24U

///|
pub const R_ARM_BASE_PREL : UInt = 25U

///|
pub const R_ARM_BASE_BREL : UInt = 26U

///|
pub const R_ARM_PLT32 : UInt = 27U

///|
pub const R_ARM_CALL : UInt = 28U

///|
pub const R_ARM_JUMP24 : UInt = 29U

///|
pub const R_ARM_THM_JUMP24 : UInt = 30U

///|
pub const R_ARM_BASE_ABS : UInt = 31U

///|
pub const R_ARM_ALU_PCREL_7_0 : UInt = 32U

///|
pub const R_ARM_ALU_PCREL_15_8 : UInt = 33U

///|
pub const R_ARM_ALU_PCREL_23_15 : UInt = 34U

///|
pub const R_ARM_LDR_SBREL_11_0 : UInt = 35U

///|
pub const R_ARM_ALU_SBREL_19_12 : UInt = 36U

///|
pub const R_ARM_ALU_SBREL_27_20 : UInt = 37U

///|
pub const R_ARM_TARGET1 : UInt = 38U

///|
pub const R_ARM_SBREL31 : UInt = 39U

///|
pub const R_ARM_V4BX : UInt = 40U

///|
pub const R_ARM_TARGET2 : UInt = 41U

///|
pub const R_ARM_PREL31 : UInt = 42U

///|
pub const R_ARM_MOVW_ABS_NC : UInt = 43U

///|
pub const R_ARM_MOVT_ABS : UInt = 44U

///|
pub const R_ARM_MOVW_PREL_NC : UInt = 45U

///|
pub const R_ARM_MOVT_PREL : UInt = 46U

///|
pub const R_ARM_THM_MOVW_ABS_NC : UInt = 47U

///|
pub const R_ARM_THM_MOVT_ABS : UInt = 48U

///|
pub const R_ARM_THM_MOVW_PREL_NC : UInt = 49U

///|
pub const R_ARM_THM_MOVT_PREL : UInt = 50U

///|
pub const R_ARM_THM_JUMP19 : UInt = 51U

///|
pub const R_ARM_THM_JUMP6 : UInt = 52U

///|
pub const R_ARM_THM_ALU_PREL_11_0 : UInt = 53U

///|
pub const R_ARM_THM_PC12 : UInt = 54U

///|
pub const R_ARM_ABS32_NOI : UInt = 55U

///|
pub const R_ARM_REL32_NOI : UInt = 56U

///|
pub const R_ARM_ALU_PC_G0_NC : UInt = 57U

///|
pub const R_ARM_ALU_PC_G0 : UInt = 58U

///|
pub const R_ARM_ALU_PC_G1_NC : UInt = 59U

///|
pub const R_ARM_ALU_PC_G1 : UInt = 60U

///|
pub const R_ARM_ALU_PC_G2 : UInt = 61U

///|
pub const R_ARM_LDR_PC_G1 : UInt = 62U

///|
pub const R_ARM_LDR_PC_G2 : UInt = 63U

///|
pub const R_ARM_LDRS_PC_G0 : UInt = 64U

///|
pub const R_ARM_LDRS_PC_G1 : UInt = 65U

///|
pub const R_ARM_LDRS_PC_G2 : UInt = 66U

///|
pub const R_ARM_LDC_PC_G0 : UInt = 67U

///|
pub const R_ARM_LDC_PC_G1 : UInt = 68U

///|
pub const R_ARM_LDC_PC_G2 : UInt = 69U

///|
pub const R_ARM_ALU_SB_G0_NC : UInt = 70U

///|
pub const R_ARM_ALU_SB_G0 : UInt = 71U

///|
pub const R_ARM_ALU_SB_G1_NC : UInt = 72U

///|
pub const R_ARM_ALU_SB_G1 : UInt = 73U

///|
pub const R_ARM_ALU_SB_G2 : UInt = 74U

///|
pub const R_ARM_LDR_SB_G0 : UInt = 75U

///|
pub const R_ARM_LDR_SB_G1 : UInt = 76U

///|
pub const R_ARM_LDR_SB_G2 : UInt = 77U

///|
pub const R_ARM_LDRS_SB_G0 : UInt = 78U

///|
pub const R_ARM_LDRS_SB_G1 : UInt = 79U

///|
pub const R_ARM_LDRS_SB_G2 : UInt = 80U

///|
pub const R_ARM_LDC_SB_G0 : UInt = 81U

///|
pub const R_ARM_LDC_SB_G1 : UInt = 82U

///|
pub const R_ARM_LDC_SB_G2 : UInt = 83U

///|
pub const R_ARM_MOVW_BREL_NC : UInt = 84U

///|
pub const R_ARM_MOVT_BREL : UInt = 85U

///|
pub const R_ARM_MOVW_BREL : UInt = 86U

///|
pub const R_ARM_THM_MOVW_BREL_NC : UInt = 87U

///|
pub const R_ARM_THM_MOVT_BREL : UInt = 88U

///|
pub const R_ARM_THM_MOVW_BREL : UInt = 89U

///|
pub const R_ARM_TLS_GOTDESC : UInt = 90U

///|
pub const R_ARM_TLS_CALL : UInt = 91U

///|
pub const R_ARM_TLS_DESCSEQ : UInt = 92U

///|
pub const R_ARM_THM_TLS_CALL : UInt = 93U

///|
pub const R_ARM_PLT32_ABS : UInt = 94U

///|
pub const R_ARM_GOT_ABS : UInt = 95U

///|
pub const R_ARM_GOT_PREL : UInt = 96U

///|
pub const R_ARM_GOT_BREL12 : UInt = 97U

///|
pub const R_ARM_GOTOFF12 : UInt = 98U

///|
pub const R_ARM_GOTRELAX : UInt = 99U

///|
pub const R_ARM_GNU_VTENTRY : UInt = 100U

///|
pub const R_ARM_GNU_VTINHERIT : UInt = 101U

///|
pub const R_ARM_THM_JUMP11 : UInt = 102U

///|
pub const R_ARM_THM_JUMP8 : UInt = 103U

///|
pub const R_ARM_TLS_GD32 : UInt = 104U

///|
pub const R_ARM_TLS_LDM32 : UInt = 105U

///|
pub const R_ARM_TLS_LDO32 : UInt = 106U

///|
pub const R_ARM_TLS_IE32 : UInt = 107U

///|
pub const R_ARM_TLS_LE32 : UInt = 108U

///|
pub const R_ARM_TLS_LDO12 : UInt = 109U

///|
pub const R_ARM_TLS_LE12 : UInt = 110U

///|
pub const R_ARM_TLS_IE12GP : UInt = 111U

///|
pub const R_ARM_ME_TOO : UInt = 128U

///|
pub const R_ARM_THM_TLS_DESCSEQ16 : UInt = 129U

///|
pub const R_ARM_THM_TLS_DESCSEQ32 : UInt = 130U

///|
pub const R_ARM_THM_GOT_BREL12 : UInt = 131U

///|
pub const R_ARM_THM_ALU_ABS_G0_NC : UInt = 132U

///|
pub const R_ARM_THM_ALU_ABS_G1_NC : UInt = 133U

///|
pub const R_ARM_THM_ALU_ABS_G2_NC : UInt = 134U

///|
pub const R_ARM_THM_ALU_ABS_G3 : UInt = 135U

///|
pub const R_ARM_THM_BF16 : UInt = 136U

///|
pub const R_ARM_THM_BF12 : UInt = 137U

///|
pub const R_ARM_THM_BF18 : UInt = 138U

///|
pub const R_ARM_IRELATIVE : UInt = 160U

// AArch64 section, segment, property, dynamic, and relocation values.

///|
pub const SHT_AARCH64_ATTRIBUTES : UInt = 0x70000003U

///|
pub const SHT_AARCH64_ATTRIBUTES_SECTION_NAME : String = ".ARM.attributes"

///|
pub const PT_AARCH64_ARCHEXT : UInt = 0x70000000U

///|
pub const PT_AARCH64_UNWIND : UInt = 0x70000001U

///|
pub const PT_AARCH64_MEMTAG_MTE : UInt = 0x70000002U

///|
pub const STO_AARCH64_VARIANT_PCS : Byte = 0x80

///|
pub const GNU_PROPERTY_AARCH64_FEATURE_1_AND : UInt = 0xc0000000U

///|
pub const GNU_PROPERTY_AARCH64_FEATURE_1_BTI : UInt = 0x1U

///|
pub const GNU_PROPERTY_AARCH64_FEATURE_1_PAC : UInt = 0x2U

///|
pub const DT_AARCH64_BTI_PLT : Int64 = 0x70000001L

///|
pub const DT_AARCH64_PAC_PLT : Int64 = 0x70000003L

///|
pub const DT_AARCH64_VARIANT_PCS : Int64 = 0x70000005L

///|
pub const R_AARCH64_NONE : UInt = 0U

///|
pub const R_AARCH64_P32_ABS32 : UInt = 1U

///|
pub const R_AARCH64_P32_COPY : UInt = 180U

///|
pub const R_AARCH64_P32_GLOB_DAT : UInt = 181U

///|
pub const R_AARCH64_P32_JUMP_SLOT : UInt = 182U

///|
pub const R_AARCH64_P32_RELATIVE : UInt = 183U

///|
pub const R_AARCH64_P32_TLS_DTPMOD : UInt = 184U

///|
pub const R_AARCH64_P32_TLS_DTPREL : UInt = 185U

///|
pub const R_AARCH64_P32_TLS_TPREL : UInt = 186U

///|
pub const R_AARCH64_P32_TLSDESC : UInt = 187U

///|
pub const R_AARCH64_P32_IRELATIVE : UInt = 188U

///|
pub const R_AARCH64_ABS64 : UInt = 257U

///|
pub const R_AARCH64_ABS32 : UInt = 258U

///|
pub const R_AARCH64_ABS16 : UInt = 259U

///|
pub const R_AARCH64_PREL64 : UInt = 260U

///|
pub const R_AARCH64_PREL32 : UInt = 261U

///|
pub const R_AARCH64_PREL16 : UInt = 262U

///|
pub const R_AARCH64_MOVW_UABS_G0 : UInt = 263U

///|
pub const R_AARCH64_MOVW_UABS_G0_NC : UInt = 264U

///|
pub const R_AARCH64_MOVW_UABS_G1 : UInt = 265U

///|
pub const R_AARCH64_MOVW_UABS_G1_NC : UInt = 266U

///|
pub const R_AARCH64_MOVW_UABS_G2 : UInt = 267U

///|
pub const R_AARCH64_MOVW_UABS_G2_NC : UInt = 268U

///|
pub const R_AARCH64_MOVW_UABS_G3 : UInt = 269U

///|
pub const R_AARCH64_MOVW_SABS_G0 : UInt = 270U

///|
pub const R_AARCH64_MOVW_SABS_G1 : UInt = 271U

///|
pub const R_AARCH64_MOVW_SABS_G2 : UInt = 272U

///|
pub const R_AARCH64_LD_PREL_LO19 : UInt = 273U

///|
pub const R_AARCH64_ADR_PREL_LO21 : UInt = 274U

///|
pub const R_AARCH64_ADR_PREL_PG_HI21 : UInt = 275U

///|
pub const R_AARCH64_ADR_PREL_PG_HI21_NC : UInt = 276U

///|
pub const R_AARCH64_ADD_ABS_LO12_NC : UInt = 277U

///|
pub const R_AARCH64_LDST8_ABS_LO12_NC : UInt = 278U

///|
pub const R_AARCH64_TSTBR14 : UInt = 279U

///|
pub const R_AARCH64_CONDBR19 : UInt = 280U

///|
pub const R_AARCH64_JUMP26 : UInt = 282U

///|
pub const R_AARCH64_CALL26 : UInt = 283U

///|
pub const R_AARCH64_LDST16_ABS_LO12_NC : UInt = 284U

///|
pub const R_AARCH64_LDST32_ABS_LO12_NC : UInt = 285U

///|
pub const R_AARCH64_LDST64_ABS_LO12_NC : UInt = 286U

///|
pub const R_AARCH64_MOVW_PREL_G0 : UInt = 287U

///|
pub const R_AARCH64_MOVW_PREL_G0_NC : UInt = 288U

///|
pub const R_AARCH64_MOVW_PREL_G1 : UInt = 289U

///|
pub const R_AARCH64_MOVW_PREL_G1_NC : UInt = 290U

///|
pub const R_AARCH64_MOVW_PREL_G2 : UInt = 291U

///|
pub const R_AARCH64_MOVW_PREL_G2_NC : UInt = 292U

///|
pub const R_AARCH64_MOVW_PREL_G3 : UInt = 293U

///|
pub const R_AARCH64_LDST128_ABS_LO12_NC : UInt = 299U

///|
pub const R_AARCH64_MOVW_GOTOFF_G0 : UInt = 300U

///|
pub const R_AARCH64_MOVW_GOTOFF_G0_NC : UInt = 301U

///|
pub const R_AARCH64_MOVW_GOTOFF_G1 : UInt = 302U

///|
pub const R_AARCH64_MOVW_GOTOFF_G1_NC : UInt = 303U

///|
pub const R_AARCH64_MOVW_GOTOFF_G2 : UInt = 304U

///|
pub const R_AARCH64_MOVW_GOTOFF_G2_NC : UInt = 305U

///|
pub const R_AARCH64_MOVW_GOTOFF_G3 : UInt = 306U

///|
pub const R_AARCH64_GOTREL64 : UInt = 307U

///|
pub const R_AARCH64_GOTREL32 : UInt = 308U

///|
pub const R_AARCH64_GOT_LD_PREL19 : UInt = 309U

///|
pub const R_AARCH64_LD64_GOTOFF_LO15 : UInt = 310U

///|
pub const R_AARCH64_ADR_GOT_PAGE : UInt = 311U

///|
pub const R_AARCH64_LD64_GOT_LO12_NC : UInt = 312U

///|
pub const R_AARCH64_LD64_GOTPAGE_LO15 : UInt = 313U

///|
pub const R_AARCH64_TLSGD_ADR_PREL21 : UInt = 512U

///|
pub const R_AARCH64_TLSGD_ADR_PAGE21 : UInt = 513U

///|
pub const R_AARCH64_TLSGD_ADD_LO12_NC : UInt = 514U

///|
pub const R_AARCH64_TLSGD_MOVW_G1 : UInt = 515U

///|
pub const R_AARCH64_TLSGD_MOVW_G0_NC : UInt = 516U

///|
pub const R_AARCH64_TLSLD_ADR_PREL21 : UInt = 517U

///|
pub const R_AARCH64_TLSLD_ADR_PAGE21 : UInt = 518U

///|
pub const R_AARCH64_TLSLD_ADD_LO12_NC : UInt = 519U

///|
pub const R_AARCH64_TLSLD_MOVW_G1 : UInt = 520U

///|
pub const R_AARCH64_TLSLD_MOVW_G0_NC : UInt = 521U

///|
pub const R_AARCH64_TLSLD_LD_PREL19 : UInt = 522U

///|
pub const R_AARCH64_TLSLD_MOVW_DTPREL_G2 : UInt = 523U

///|
pub const R_AARCH64_TLSLD_MOVW_DTPREL_G1 : UInt = 524U

///|
pub const R_AARCH64_TLSLD_MOVW_DTPREL_G1_NC : UInt = 525U

///|
pub const R_AARCH64_TLSLD_MOVW_DTPREL_G0 : UInt = 526U

///|
pub const R_AARCH64_TLSLD_MOVW_DTPREL_G0_NC : UInt = 527U

///|
pub const R_AARCH64_TLSLD_ADD_DTPREL_HI12 : UInt = 528U

///|
pub const R_AARCH64_TLSLD_ADD_DTPREL_LO12 : UInt = 529U

///|
pub const R_AARCH64_TLSLD_ADD_DTPREL_LO12_NC : UInt = 530U

///|
pub const R_AARCH64_TLSLD_LDST8_DTPREL_LO12 : UInt = 531U

///|
pub const R_AARCH64_TLSLD_LDST8_DTPREL_LO12_NC : UInt = 532U

///|
pub const R_AARCH64_TLSLD_LDST16_DTPREL_LO12 : UInt = 533U

///|
pub const R_AARCH64_TLSLD_LDST16_DTPREL_LO12_NC : UInt = 534U

///|
pub const R_AARCH64_TLSLD_LDST32_DTPREL_LO12 : UInt = 535U

///|
pub const R_AARCH64_TLSLD_LDST32_DTPREL_LO12_NC : UInt = 536U

///|
pub const R_AARCH64_TLSLD_LDST64_DTPREL_LO12 : UInt = 537U

///|
pub const R_AARCH64_TLSLD_LDST64_DTPREL_LO12_NC : UInt = 538U

///|
pub const R_AARCH64_TLSIE_MOVW_GOTTPREL_G1 : UInt = 539U

///|
pub const R_AARCH64_TLSIE_MOVW_GOTTPREL_G0_NC : UInt = 540U

///|
pub const R_AARCH64_TLSIE_ADR_GOTTPREL_PAGE21 : UInt = 541U

///|
pub const R_AARCH64_TLSIE_LD64_GOTTPREL_LO12_NC : UInt = 542U

///|
pub const R_AARCH64_TLSIE_LD_GOTTPREL_PREL19 : UInt = 543U

///|
pub const R_AARCH64_TLSLE_MOVW_TPREL_G2 : UInt = 544U

///|
pub const R_AARCH64_TLSLE_MOVW_TPREL_G1 : UInt = 545U

///|
pub const R_AARCH64_TLSLE_MOVW_TPREL_G1_NC : UInt = 546U

///|
pub const R_AARCH64_TLSLE_MOVW_TPREL_G0 : UInt = 547U

///|
pub const R_AARCH64_TLSLE_MOVW_TPREL_G0_NC : UInt = 548U

///|
pub const R_AARCH64_TLSLE_ADD_TPREL_HI12 : UInt = 549U

///|
pub const R_AARCH64_TLSLE_ADD_TPREL_LO12 : UInt = 550U

///|
pub const R_AARCH64_TLSLE_ADD_TPREL_LO12_NC : UInt = 551U

///|
pub const R_AARCH64_TLSLE_LDST8_TPREL_LO12 : UInt = 552U

///|
pub const R_AARCH64_TLSLE_LDST8_TPREL_LO12_NC : UInt = 553U

///|
pub const R_AARCH64_TLSLE_LDST16_TPREL_LO12 : UInt = 554U

///|
pub const R_AARCH64_TLSLE_LDST16_TPREL_LO12_NC : UInt = 555U

///|
pub const R_AARCH64_TLSLE_LDST32_TPREL_LO12 : UInt = 556U

///|
pub const R_AARCH64_TLSLE_LDST32_TPREL_LO12_NC : UInt = 557U

///|
pub const R_AARCH64_TLSLE_LDST64_TPREL_LO12 : UInt = 558U

///|
pub const R_AARCH64_TLSLE_LDST64_TPREL_LO12_NC : UInt = 559U

///|
pub const R_AARCH64_TLSDESC_LD_PREL19 : UInt = 560U

///|
pub const R_AARCH64_TLSDESC_ADR_PREL21 : UInt = 561U

///|
pub const R_AARCH64_TLSDESC_ADR_PAGE21 : UInt = 562U

///|
pub const R_AARCH64_TLSDESC_LD64_LO12 : UInt = 563U

///|
pub const R_AARCH64_TLSDESC_ADD_LO12 : UInt = 564U

///|
pub const R_AARCH64_TLSDESC_OFF_G1 : UInt = 565U

///|
pub const R_AARCH64_TLSDESC_OFF_G0_NC : UInt = 566U

///|
pub const R_AARCH64_TLSDESC_LDR : UInt = 567U

///|
pub const R_AARCH64_TLSDESC_ADD : UInt = 568U

///|
pub const R_AARCH64_TLSDESC_CALL : UInt = 569U

///|
pub const R_AARCH64_TLSLE_LDST128_TPREL_LO12 : UInt = 570U

///|
pub const R_AARCH64_TLSLE_LDST128_TPREL_LO12_NC : UInt = 571U

///|
pub const R_AARCH64_TLSLD_LDST128_DTPREL_LO12 : UInt = 572U

///|
pub const R_AARCH64_TLSLD_LDST128_DTPREL_LO12_NC : UInt = 573U

///|
pub const R_AARCH64_COPY : UInt = 1024U

///|
pub const R_AARCH64_GLOB_DAT : UInt = 1025U

///|
pub const R_AARCH64_JUMP_SLOT : UInt = 1026U

///|
pub const R_AARCH64_RELATIVE : UInt = 1027U

///|
pub const R_AARCH64_TLS_DTPMOD : UInt = 1028U

///|
pub const R_AARCH64_TLS_DTPREL : UInt = 1029U

///|
pub const R_AARCH64_TLS_TPREL : UInt = 1030U

///|
pub const R_AARCH64_TLSDESC : UInt = 1031U

///|
pub const R_AARCH64_IRELATIVE : UInt = 1032U

// PowerPC file flags and relocation values.

///|
pub const EF_PPC_EMB : UInt = 0x80000000U

///|
pub const EF_PPC_RELOCATABLE : UInt = 0x00010000U

///|
pub const EF_PPC_RELOCATABLE_LIB : UInt = 0x00008000U

///|
pub const R_PPC_NONE : UInt = 0U

///|
pub const R_PPC_ADDR32 : UInt = 1U

///|
pub const R_PPC_ADDR24 : UInt = 2U

///|
pub const R_PPC_ADDR16 : UInt = 3U

///|
pub const R_PPC_ADDR16_LO : UInt = 4U

///|
pub const R_PPC_ADDR16_HI : UInt = 5U

///|
pub const R_PPC_ADDR16_HA : UInt = 6U

///|
pub const R_PPC_ADDR14 : UInt = 7U

///|
pub const R_PPC_ADDR14_BRTAKEN : UInt = 8U

///|
pub const R_PPC_ADDR14_BRNTAKEN : UInt = 9U

///|
pub const R_PPC_REL24 : UInt = 10U

///|
pub const R_PPC_REL14 : UInt = 11U

///|
pub const R_PPC_REL14_BRTAKEN : UInt = 12U

///|
pub const R_PPC_REL14_BRNTAKEN : UInt = 13U

///|
pub const R_PPC_GOT16 : UInt = 14U

///|
pub const R_PPC_GOT16_LO : UInt = 15U

///|
pub const R_PPC_GOT16_HI : UInt = 16U

///|
pub const R_PPC_GOT16_HA : UInt = 17U

///|
pub const R_PPC_PLTREL24 : UInt = 18U

///|
pub const R_PPC_COPY : UInt = 19U

///|
pub const R_PPC_GLOB_DAT : UInt = 20U

///|
pub const R_PPC_JMP_SLOT : UInt = 21U

///|
pub const R_PPC_RELATIVE : UInt = 22U

///|
pub const R_PPC_LOCAL24PC : UInt = 23U

///|
pub const R_PPC_UADDR32 : UInt = 24U

///|
pub const R_PPC_UADDR16 : UInt = 25U

///|
pub const R_PPC_REL32 : UInt = 26U

///|
pub const R_PPC_PLT32 : UInt = 27U

///|
pub const R_PPC_PLTREL32 : UInt = 28U

///|
pub const R_PPC_PLT16_LO : UInt = 29U

///|
pub const R_PPC_PLT16_HI : UInt = 30U

///|
pub const R_PPC_PLT16_HA : UInt = 31U

///|
pub const R_PPC_SDAREL16 : UInt = 32U

///|
pub const R_PPC_SECTOFF : UInt = 33U

///|
pub const R_PPC_SECTOFF_LO : UInt = 34U

///|
pub const R_PPC_SECTOFF_HI : UInt = 35U

///|
pub const R_PPC_SECTOFF_HA : UInt = 36U

///|
pub const R_PPC_TLS : UInt = 67U

///|
pub const R_PPC_DTPMOD32 : UInt = 68U

///|
pub const R_PPC_TPREL16 : UInt = 69U

///|
pub const R_PPC_TPREL16_LO : UInt = 70U

///|
pub const R_PPC_TPREL16_HI : UInt = 71U

///|
pub const R_PPC_TPREL16_HA : UInt = 72U

///|
pub const R_PPC_TPREL32 : UInt = 73U

///|
pub const R_PPC_DTPREL16 : UInt = 74U

///|
pub const R_PPC_DTPREL16_LO : UInt = 75U

///|
pub const R_PPC_DTPREL16_HI : UInt = 76U

///|
pub const R_PPC_DTPREL16_HA : UInt = 77U

///|
pub const R_PPC_DTPREL32 : UInt = 78U

///|
pub const R_PPC_GOT_TLSGD16 : UInt = 79U

///|
pub const R_PPC_GOT_TLSGD16_LO : UInt = 80U

///|
pub const R_PPC_GOT_TLSGD16_HI : UInt = 81U

///|
pub const R_PPC_GOT_TLSGD16_HA : UInt = 82U

///|
pub const R_PPC_GOT_TLSLD16 : UInt = 83U

///|
pub const R_PPC_GOT_TLSLD16_LO : UInt = 84U

///|
pub const R_PPC_GOT_TLSLD16_HI : UInt = 85U

///|
pub const R_PPC_GOT_TLSLD16_HA : UInt = 86U

///|
pub const R_PPC_GOT_TPREL16 : UInt = 87U

///|
pub const R_PPC_GOT_TPREL16_LO : UInt = 88U

///|
pub const R_PPC_GOT_TPREL16_HI : UInt = 89U

///|
pub const R_PPC_GOT_TPREL16_HA : UInt = 90U

///|
pub const R_PPC_GOT_DTPREL16 : UInt = 91U

///|
pub const R_PPC_GOT_DTPREL16_LO : UInt = 92U

///|
pub const R_PPC_GOT_DTPREL16_HI : UInt = 93U

///|
pub const R_PPC_GOT_DTPREL16_HA : UInt = 94U

///|
pub const R_PPC_TLSGD : UInt = 95U

///|
pub const R_PPC_TLSLD : UInt = 96U

///|
pub const R_PPC_EMB_NADDR32 : UInt = 101U

///|
pub const R_PPC_EMB_NADDR16 : UInt = 102U

///|
pub const R_PPC_EMB_NADDR16_LO : UInt = 103U

///|
pub const R_PPC_EMB_NADDR16_HI : UInt = 104U

///|
pub const R_PPC_EMB_NADDR16_HA : UInt = 105U

///|
pub const R_PPC_EMB_SDAI16 : UInt = 106U

///|
pub const R_PPC_EMB_SDA2I16 : UInt = 107U

///|
pub const R_PPC_EMB_SDA2REL : UInt = 108U

///|
pub const R_PPC_EMB_SDA21 : UInt = 109U

///|
pub const R_PPC_EMB_MRKREF : UInt = 110U

///|
pub const R_PPC_EMB_RELSEC16 : UInt = 111U

///|
pub const R_PPC_EMB_RELST_LO : UInt = 112U

///|
pub const R_PPC_EMB_RELST_HI : UInt = 113U

///|
pub const R_PPC_EMB_RELST_HA : UInt = 114U

///|
pub const R_PPC_EMB_BIT_FLD : UInt = 115U

///|
pub const R_PPC_EMB_RELSDA : UInt = 116U

///|
pub const R_PPC_DIAB_SDA21_LO : UInt = 180U

///|
pub const R_PPC_DIAB_SDA21_HI : UInt = 181U

///|
pub const R_PPC_DIAB_SDA21_HA : UInt = 182U

///|
pub const R_PPC_DIAB_RELSDA_LO : UInt = 183U

///|
pub const R_PPC_DIAB_RELSDA_HI : UInt = 184U

///|
pub const R_PPC_DIAB_RELSDA_HA : UInt = 185U

///|
pub const R_PPC_IRELATIVE : UInt = 248U

///|
pub const R_PPC_REL16 : UInt = 249U

///|
pub const R_PPC_REL16_LO : UInt = 250U

///|
pub const R_PPC_REL16_HI : UInt = 251U

///|
pub const R_PPC_REL16_HA : UInt = 252U

///|
pub const R_PPC_TOC16 : UInt = 255U

///|
pub const DT_PPC_GOT : Int64 = 0x70000000L

///|
pub const DT_PPC_OPT : Int64 = 0x70000001L

///|
pub const PPC_OPT_TLS : UInt64 = 1UL

// PowerPC64 file flags, dynamic tags, symbol flags, and relocation values.

///|
pub const EF_PPC64_ABI : UInt = 3U

///|
pub const DT_PPC64_GLINK : Int64 = 0x70000000L

///|
pub const DT_PPC64_OPD : Int64 = 0x70000001L

///|
pub const DT_PPC64_OPDSZ : Int64 = 0x70000002L

///|
pub const DT_PPC64_OPT : Int64 = 0x70000003L

///|
pub const PPC64_OPT_TLS : UInt64 = 1UL

///|
pub const PPC64_OPT_MULTI_TOC : UInt64 = 2UL

///|
pub const PPC64_OPT_LOCALENTRY : UInt64 = 4UL

///|
pub const STO_PPC64_LOCAL_BIT : Byte = 5

///|
pub const STO_PPC64_LOCAL_MASK : Byte = 224

///|
pub const R_PPC64_NONE : UInt = 0U

///|
pub const R_PPC64_ADDR32 : UInt = 1U

///|
pub const R_PPC64_ADDR24 : UInt = 2U

///|
pub const R_PPC64_ADDR16 : UInt = 3U

///|
pub const R_PPC64_ADDR16_LO : UInt = 4U

///|
pub const R_PPC64_ADDR16_HI : UInt = 5U

///|
pub const R_PPC64_ADDR16_HA : UInt = 6U

///|
pub const R_PPC64_ADDR14 : UInt = 7U

///|
pub const R_PPC64_ADDR14_BRTAKEN : UInt = 8U

///|
pub const R_PPC64_ADDR14_BRNTAKEN : UInt = 9U

///|
pub const R_PPC64_REL24 : UInt = 10U

///|
pub const R_PPC64_REL14 : UInt = 11U

///|
pub const R_PPC64_REL14_BRTAKEN : UInt = 12U

///|
pub const R_PPC64_REL14_BRNTAKEN : UInt = 13U

///|
pub const R_PPC64_GOT16 : UInt = 14U

///|
pub const R_PPC64_GOT16_LO : UInt = 15U

///|
pub const R_PPC64_GOT16_HI : UInt = 16U

///|
pub const R_PPC64_GOT16_HA : UInt = 17U

///|
pub const R_PPC64_COPY : UInt = 19U

///|
pub const R_PPC64_GLOB_DAT : UInt = 20U

///|
pub const R_PPC64_JMP_SLOT : UInt = 21U

///|
pub const R_PPC64_RELATIVE : UInt = 22U

///|
pub const R_PPC64_UADDR32 : UInt = 24U

///|
pub const R_PPC64_UADDR16 : UInt = 25U

///|
pub const R_PPC64_REL32 : UInt = 26U

///|
pub const R_PPC64_PLT32 : UInt = 27U

///|
pub const R_PPC64_PLTREL32 : UInt = 28U

///|
pub const R_PPC64_PLT16_LO : UInt = 29U

///|
pub const R_PPC64_PLT16_HI : UInt = 30U

///|
pub const R_PPC64_PLT16_HA : UInt = 31U

///|
pub const R_PPC64_SECTOFF : UInt = 33U

///|
pub const R_PPC64_SECTOFF_LO : UInt = 34U

///|
pub const R_PPC64_SECTOFF_HI : UInt = 35U

///|
pub const R_PPC64_SECTOFF_HA : UInt = 36U

///|
pub const R_PPC64_ADDR30 : UInt = 37U

///|
pub const R_PPC64_ADDR64 : UInt = 38U

///|
pub const R_PPC64_ADDR16_HIGHER : UInt = 39U

///|
pub const R_PPC64_ADDR16_HIGHERA : UInt = 40U

///|
pub const R_PPC64_ADDR16_HIGHEST : UInt = 41U

///|
pub const R_PPC64_ADDR16_HIGHESTA : UInt = 42U

///|
pub const R_PPC64_UADDR64 : UInt = 43U

///|
pub const R_PPC64_REL64 : UInt = 44U

///|
pub const R_PPC64_PLT64 : UInt = 45U

///|
pub const R_PPC64_PLTREL64 : UInt = 46U

///|
pub const R_PPC64_TOC16 : UInt = 47U

///|
pub const R_PPC64_TOC16_LO : UInt = 48U

///|
pub const R_PPC64_TOC16_HI : UInt = 49U

///|
pub const R_PPC64_TOC16_HA : UInt = 50U

///|
pub const R_PPC64_TOC : UInt = 51U

///|
pub const R_PPC64_PLTGOT16 : UInt = 52U

///|
pub const R_PPC64_PLTGOT16_LO : UInt = 53U

///|
pub const R_PPC64_PLTGOT16_HI : UInt = 54U

///|
pub const R_PPC64_PLTGOT16_HA : UInt = 55U

///|
pub const R_PPC64_ADDR16_DS : UInt = 56U

///|
pub const R_PPC64_ADDR16_LO_DS : UInt = 57U

///|
pub const R_PPC64_GOT16_DS : UInt = 58U

///|
pub const R_PPC64_GOT16_LO_DS : UInt = 59U

///|
pub const R_PPC64_PLT16_LO_DS : UInt = 60U

///|
pub const R_PPC64_SECTOFF_DS : UInt = 61U

///|
pub const R_PPC64_SECTOFF_LO_DS : UInt = 62U

///|
pub const R_PPC64_TOC16_DS : UInt = 63U

///|
pub const R_PPC64_TOC16_LO_DS : UInt = 64U

///|
pub const R_PPC64_PLTGOT16_DS : UInt = 65U

///|
pub const R_PPC64_PLTGOT16_LO_DS : UInt = 66U

///|
pub const R_PPC64_TLS : UInt = 67U

///|
pub const R_PPC64_DTPMOD64 : UInt = 68U

///|
pub const R_PPC64_TPREL16 : UInt = 69U

///|
pub const R_PPC64_TPREL16_LO : UInt = 60U

///|
pub const R_PPC64_TPREL16_HI : UInt = 71U

///|
pub const R_PPC64_TPREL16_HA : UInt = 72U

///|
pub const R_PPC64_TPREL64 : UInt = 73U

///|
pub const R_PPC64_DTPREL16 : UInt = 74U

///|
pub const R_PPC64_DTPREL16_LO : UInt = 75U

///|
pub const R_PPC64_DTPREL16_HI : UInt = 76U

///|
pub const R_PPC64_DTPREL16_HA : UInt = 77U

///|
pub const R_PPC64_DTPREL64 : UInt = 78U

///|
pub const R_PPC64_GOT_TLSGD16 : UInt = 79U

///|
pub const R_PPC64_GOT_TLSGD16_LO : UInt = 80U

///|
pub const R_PPC64_GOT_TLSGD16_HI : UInt = 81U

///|
pub const R_PPC64_GOT_TLSGD16_HA : UInt = 82U

///|
pub const R_PPC64_GOT_TLSLD16 : UInt = 83U

///|
pub const R_PPC64_GOT_TLSLD16_LO : UInt = 84U

///|
pub const R_PPC64_GOT_TLSLD16_HI : UInt = 85U

///|
pub const R_PPC64_GOT_TLSLD16_HA : UInt = 86U

///|
pub const R_PPC64_GOT_TPREL16_DS : UInt = 87U

///|
pub const R_PPC64_GOT_TPREL16_LO_DS : UInt = 88U

///|
pub const R_PPC64_GOT_TPREL16_HI : UInt = 89U

///|
pub const R_PPC64_GOT_TPREL16_HA : UInt = 90U

///|
pub const R_PPC64_GOT_DTPREL16_DS : UInt = 91U

///|
pub const R_PPC64_GOT_DTPREL16_LO_DS : UInt = 92U

///|
pub const R_PPC64_GOT_DTPREL16_HI : UInt = 93U

///|
pub const R_PPC64_GOT_DTPREL16_HA : UInt = 94U

///|
pub const R_PPC64_TPREL16_DS : UInt = 95U

///|
pub const R_PPC64_TPREL16_LO_DS : UInt = 96U

///|
pub const R_PPC64_TPREL16_HIGHER : UInt = 97U

///|
pub const R_PPC64_TPREL16_HIGHERA : UInt = 98U

///|
pub const R_PPC64_TPREL16_HIGHEST : UInt = 99U

///|
pub const R_PPC64_TPREL16_HIGHESTA : UInt = 100U

///|
pub const R_PPC64_DTPREL16_DS : UInt = 101U

///|
pub const R_PPC64_DTPREL16_LO_DS : UInt = 102U

///|
pub const R_PPC64_DTPREL16_HIGHER : UInt = 103U

///|
pub const R_PPC64_DTPREL16_HIGHERA : UInt = 104U

///|
pub const R_PPC64_DTPREL16_HIGHEST : UInt = 105U

///|
pub const R_PPC64_DTPREL16_HIGHESTA : UInt = 106U

///|
pub const R_PPC64_TLSGD : UInt = 107U

///|
pub const R_PPC64_TLSLD : UInt = 108U

///|
pub const R_PPC64_TOCSAVE : UInt = 109U

///|
pub const R_PPC64_ADDR16_HIGH : UInt = 110U

///|
pub const R_PPC64_ADDR16_HIGHA : UInt = 111U

///|
pub const R_PPC64_TPREL16_HIGH : UInt = 112U

///|
pub const R_PPC64_TPREL16_HIGHA : UInt = 113U

///|
pub const R_PPC64_DTPREL16_HIGH : UInt = 114U

///|
pub const R_PPC64_DTPREL16_HIGHA : UInt = 115U

///|
pub const R_PPC64_JMP_IREL : UInt = 247U

///|
pub const R_PPC64_IRELATIVE : UInt = 248U

///|
pub const R_PPC64_REL16 : UInt = 249U

///|
pub const R_PPC64_REL16_LO : UInt = 250U

///|
pub const R_PPC64_REL16_HI : UInt = 251U

///|
pub const R_PPC64_REL16_HA : UInt = 252U

// RISC-V file flags, section/segment extensions, dynamic tags, and relocations.

///|
pub const EF_RISCV_RVC : UInt = 0x0001U

///|
pub const EF_RISCV_FLOAT_ABI_SOFT : UInt = 0x0000U

///|
pub const EF_RISCV_FLOAT_ABI_SINGLE : UInt = 0x0002U

///|
pub const EF_RISCV_FLOAT_ABI_DOUBLE : UInt = 0x0004U

///|
pub const EF_RISCV_FLOAT_ABI_QUAD : UInt = 0x0006U

///|
pub const EF_RISCV_FLOAT_ABI_MASK : UInt = 0x0006U

///|
pub const EF_RISCV_RVE : UInt = 0x0008U

///|
pub const EF_RISCV_TSO : UInt = 0x0010U

///|
pub const SHT_RISCV_ATTRIBUTES : UInt = 0x70000003U // SHT_LOPROC + 3U

///|
pub const SHT_RISCV_ATTRIBUTES_SECTION_NAME : String = ".riscv.attributes"

///|
pub const PT_RISCV_ATTRIBUTES : UInt = 0x70000003U

///|
pub const STO_RISCV_VARIANT_CC : Byte = 0x80

///|
pub const DT_RISCV_VARIANT_CC : Int64 = 0x70000001L

///|
pub const R_RISCV_NONE : UInt = 0U

///|
pub const R_RISCV_32 : UInt = 1U

///|
pub const R_RISCV_64 : UInt = 2U

///|
pub const R_RISCV_RELATIVE : UInt = 3U

///|
pub const R_RISCV_COPY : UInt = 4U

///|
pub const R_RISCV_JUMP_SLOT : UInt = 5U

///|
pub const R_RISCV_TLS_DTPMOD32 : UInt = 6U

///|
pub const R_RISCV_TLS_DTPMOD64 : UInt = 7U

///|
pub const R_RISCV_TLS_DTPREL32 : UInt = 8U

///|
pub const R_RISCV_TLS_DTPREL64 : UInt = 9U

///|
pub const R_RISCV_TLS_TPREL32 : UInt = 10U

///|
pub const R_RISCV_TLS_TPREL64 : UInt = 11U

///|
pub const R_RISCV_BRANCH : UInt = 16U

///|
pub const R_RISCV_JAL : UInt = 17U

///|
pub const R_RISCV_CALL : UInt = 18U

///|
pub const R_RISCV_CALL_PLT : UInt = 19U

///|
pub const R_RISCV_GOT_HI20 : UInt = 20U

///|
pub const R_RISCV_TLS_GOT_HI20 : UInt = 21U

///|
pub const R_RISCV_TLS_GD_HI20 : UInt = 22U

///|
pub const R_RISCV_PCREL_HI20 : UInt = 23U

///|
pub const R_RISCV_PCREL_LO12_I : UInt = 24U

///|
pub const R_RISCV_PCREL_LO12_S : UInt = 25U

///|
pub const R_RISCV_HI20 : UInt = 26U

///|
pub const R_RISCV_LO12_I : UInt = 27U

///|
pub const R_RISCV_LO12_S : UInt = 28U

///|
pub const R_RISCV_TPREL_HI20 : UInt = 29U

///|
pub const R_RISCV_TPREL_LO12_I : UInt = 30U

///|
pub const R_RISCV_TPREL_LO12_S : UInt = 31U

///|
pub const R_RISCV_TPREL_ADD : UInt = 32U

///|
pub const R_RISCV_ADD8 : UInt = 33U

///|
pub const R_RISCV_ADD16 : UInt = 34U

///|
pub const R_RISCV_ADD32 : UInt = 35U

///|
pub const R_RISCV_ADD64 : UInt = 36U

///|
pub const R_RISCV_SUB8 : UInt = 37U

///|
pub const R_RISCV_SUB16 : UInt = 38U

///|
pub const R_RISCV_SUB32 : UInt = 39U

///|
pub const R_RISCV_SUB64 : UInt = 40U

///|
pub const R_RISCV_ALIGN : UInt = 43U

///|
pub const R_RISCV_RVC_BRANCH : UInt = 44U

///|
pub const R_RISCV_RVC_JUMP : UInt = 45U

///|
pub const R_RISCV_RVC_LUI : UInt = 46U

///|
pub const R_RISCV_RELAX : UInt = 51U

///|
pub const R_RISCV_SUB6 : UInt = 52U

///|
pub const R_RISCV_SET6 : UInt = 53U

///|
pub const R_RISCV_SET8 : UInt = 54U

///|
pub const R_RISCV_SET16 : UInt = 55U

///|
pub const R_RISCV_SET32 : UInt = 56U

///|
pub const R_RISCV_32_PCREL : UInt = 57U

///|
pub const R_RISCV_IRELATIVE : UInt = 58U

// x86-64 section flags and relocation values.

///|
pub const SHF_X86_64_LARGE : UInt64 = 0x10000000UL

///|
pub const SHT_X86_64_UNWIND : UInt = 0x70000001U // SHT_LOPROC + 1U

///|
pub const R_X86_64_NONE : UInt = 0U

///|
pub const R_X86_64_64 : UInt = 1U

///|
pub const R_X86_64_PC32 : UInt = 2U

///|
pub const R_X86_64_GOT32 : UInt = 3U

///|
pub const R_X86_64_PLT32 : UInt = 4U

///|
pub const R_X86_64_COPY : UInt = 5U

///|
pub const R_X86_64_GLOB_DAT : UInt = 6U

///|
pub const R_X86_64_JUMP_SLOT : UInt = 7U

///|
pub const R_X86_64_RELATIVE : UInt = 8U

///|
pub const R_X86_64_GOTPCREL : UInt = 9U

///|
pub const R_X86_64_32 : UInt = 10U

///|
pub const R_X86_64_32S : UInt = 11U

///|
pub const R_X86_64_16 : UInt = 12U

///|
pub const R_X86_64_PC16 : UInt = 13U

///|
pub const R_X86_64_8 : UInt = 14U

///|
pub const R_X86_64_PC8 : UInt = 15U

///|
pub const R_X86_64_DTPMOD64 : UInt = 16U

///|
pub const R_X86_64_DTPOFF64 : UInt = 17U

///|
pub const R_X86_64_TPOFF64 : UInt = 18U

///|
pub const R_X86_64_TLSGD : UInt = 19U

///|
pub const R_X86_64_TLSLD : UInt = 20U

///|
pub const R_X86_64_DTPOFF32 : UInt = 21U

///|
pub const R_X86_64_GOTTPOFF : UInt = 22U

///|
pub const R_X86_64_TPOFF32 : UInt = 23U

///|
pub const R_X86_64_PC64 : UInt = 24U

///|
pub const R_X86_64_GOTOFF64 : UInt = 25U

///|
pub const R_X86_64_GOTPC32 : UInt = 26U

///|
pub const R_X86_64_GOT64 : UInt = 27U

///|
pub const R_X86_64_GOTPCREL64 : UInt = 28U

///|
pub const R_X86_64_GOTPC64 : UInt = 29U

///|
pub const R_X86_64_PLTOFF64 : UInt = 31U

///|
pub const R_X86_64_SIZE32 : UInt = 32U

///|
pub const R_X86_64_SIZE64 : UInt = 33U

///|
pub const R_X86_64_GOTPC32_TLSDESC : UInt = 34U

///|
pub const R_X86_64_TLSDESC_CALL : UInt = 35U

///|
pub const R_X86_64_TLSDESC : UInt = 36U

///|
pub const R_X86_64_IRELATIVE : UInt = 37U

///|
pub const R_X86_64_RELATIVE64 : UInt = 38U

///|
pub const R_X86_64_GOTPCRELX : UInt = 41U

///|
pub const R_X86_64_REX_GOTPCRELX : UInt = 42U

// MIPS file flags, ABI extension constants, dynamic tags, and relocations.

///|
pub const EF_MIPS_NOREORDER : UInt = 0x00000001U

///|
pub const EF_MIPS_PIC : UInt = 0x00000002U

///|
pub const EF_MIPS_CPIC : UInt = 0x00000004U

///|
pub const EF_MIPS_XGOT : UInt = 0x00000008U

///|
pub const EF_MIPS_64BIT_WHIRL : UInt = 0x00000010U

///|
pub const EF_MIPS_ABI2 : UInt = 0x00000020U

///|
pub const EF_MIPS_ABI_ON32 : UInt = 0x00000040U

///|
pub const EF_MIPS_OPTIONS_FIRST : UInt = 0x00000080U

///|
pub const EF_MIPS_32BITMODE : UInt = 0x00000100U

///|
pub const EF_MIPS_FP64 : UInt = 0x00000200U

///|
pub const EF_MIPS_NAN2008 : UInt = 0x00000400U

///|
pub const EF_MIPS_ABI_EABI32 : UInt = 0x00003000U

///|
pub const EF_MIPS_ABI_EABI64 : UInt = 0x00004000U

///|
pub const EF_MIPS_MACH : UInt = 0x00FF0000U

///|
pub const EF_MIPS_ARCH_ASE_MICROMIPS : UInt = 0x02000000U

///|
pub const EF_MIPS_ARCH_ASE : UInt = 0x0f000000U

///|
pub const EF_MIPS_ARCH_ASE_MDMX : UInt = 0x08000000U

///|
pub const EF_MIPS_ARCH_ASE_M16 : UInt = 0x04000000U

///|
pub const EF_MIPS_ARCH : UInt = 0xf0000000U

///|
pub const EF_MIPS_ARCH_1 : UInt = 0x00000000U

///|
pub const EF_MIPS_ARCH_2 : UInt = 0x10000000U

///|
pub const EF_MIPS_ARCH_3 : UInt = 0x20000000U

///|
pub const EF_MIPS_ARCH_4 : UInt = 0x30000000U

///|
pub const EF_MIPS_ARCH_5 : UInt = 0x40000000U

///|
pub const EF_MIPS_ARCH_32 : UInt = 0x50000000U

///|
pub const EF_MIPS_ARCH_64 : UInt = 0x60000000U

///|
pub const EF_MIPS_ARCH_32R2 : UInt = 0x70000000U

///|
pub const EF_MIPS_ARCH_64R2 : UInt = 0x80000000U

///|
pub const EF_MIPS_ARCH_32R6 : UInt = 0x90000000U

///|
pub const EF_MIPS_ARCH_64R6 : UInt = 0xa0000000U

///|
pub const SHT_MIPS_LIBLIST : UInt = 0x70000000U

///|
pub const SHT_MIPS_MSYM : UInt = 0x70000001U

///|
pub const SHT_MIPS_CONFLICT : UInt = 0x70000002U

///|
pub const SHT_MIPS_GPTAB : UInt = 0x70000003U

///|
pub const SHT_MIPS_UCODE : UInt = 0x70000004U

///|
pub const SHT_MIPS_DEBUG : UInt = 0x70000005U

///|
pub const SHT_MIPS_REGINFO : UInt = 0x70000006U

///|
pub const SHT_MIPS_PACKAGE : UInt = 0x70000007U

///|
pub const SHT_MIPS_PACKSYM : UInt = 0x70000008U

///|
pub const SHT_MIPS_RELD : UInt = 0x70000009U

///|
pub const SHT_MIPS_IFACE : UInt = 0x7000000bU

///|
pub const SHT_MIPS_CONTENT : UInt = 0x7000000cU

///|
pub const SHT_MIPS_OPTIONS : UInt = 0x7000000dU

///|
pub const SHT_MIPS_DELTASYM : UInt = 0x7000001bU

///|
pub const SHT_MIPS_DELTAINST : UInt = 0x7000001cU

///|
pub const SHT_MIPS_DELTACLASS : UInt = 0x7000001dU

///|
pub const SHT_MIPS_DWARF : UInt = 0x7000001eU

///|
pub const SHT_MIPS_DELTADECL : UInt = 0x7000001fU

///|
pub const SHT_MIPS_SYMBOL_LIB : UInt = 0x70000020U

///|
pub const SHT_MIPS_EVENTS : UInt = 0x70000021U

///|
pub const SHT_MIPS_TRANSLATE : UInt = 0x70000022U

///|
pub const SHT_MIPS_PIXIE : UInt = 0x70000023U

///|
pub const SHT_MIPS_XLATE : UInt = 0x70000024U

///|
pub const SHT_MIPS_XLATE_DEBUG : UInt = 0x70000025U

///|
pub const SHT_MIPS_WHIRL : UInt = 0x70000026U

///|
pub const SHT_MIPS_EH_REGION : UInt = 0x70000027U

///|
pub const SHT_MIPS_XLATE_OLD : UInt = 0x70000028U

///|
pub const SHT_MIPS_PDR_EXCEPTION : UInt = 0x70000029U

///|
pub const SHF_MIPS_GPREL : UInt = 0x10000000U

///|
pub const SHF_MIPS_MERGE : UInt = 0x20000000U

///|
pub const SHF_MIPS_ADDR : UInt = 0x40000000U

///|
pub const SHF_MIPS_STRING : UInt = 0x80000000U

///|
pub const SHF_MIPS_NOSTRIP : UInt = 0x08000000U

///|
pub const SHF_MIPS_LOCAL : UInt = 0x04000000U

///|
pub const SHF_MIPS_NAMES : UInt = 0x02000000U

///|
pub const SHF_MIPS_NODUPE : UInt = 0x01000000U

///|
pub const STO_EXPORT : Byte = 3

///|
pub const STO_DEFAULT : Byte = 0

///|
pub const STO_INTERNAL : Byte = 1

///|
pub const STO_HIDDEN : Byte = 2

///|
pub const STO_PROTECTED : Byte = 3

///|
pub const STO_OPTIONAL : Byte = 4

///|
pub const STO_MIPS_PLT : Byte = 8

///|
pub const STO_MIPS_SC_ALIGN_UNUSED : Byte = 0xff

///|
pub const SHN_LORESERVE : UInt16 = 0xff00

///|
pub const SHN_LOPROC : UInt16 = 0xff00

///|
pub const SHN_MIPS_ACOMMON : UInt16 = 0xff00

///|
pub const SHN_MIPS_TEXT : UInt16 = 0xff01

///|
pub const SHN_MIPS_DATA : UInt16 = 0xff02

///|
pub const SHN_MIPS_SCOMMON : UInt16 = 0xff03

///|
pub const SHN_MIPS_SUNDEFINED : UInt16 = 0xff04

///|
pub const SHN_MIPS_LCOMMON : UInt16 = 0xff05

///|
pub const SHN_MIPS_LUNDEFINED : UInt16 = 0xff06

///|
pub const SHN_HIPROC : UInt16 = 0xff1f

///|
pub const SHN_HIRESERVE : UInt16 = 0xffff

///|
pub const ODK_NULL : Byte = 0

///|
pub const ODK_REGINF : Byte = 1

///|
pub const ODK_EXCEPTION : Byte = 2

///|
pub const ODK_PA : Byte = 3

///|
pub const ODK_HWPATC : Byte = 4

///|
pub const ODK_FIL : Byte = 5

///|
pub const ODK_TAG : Byte = 6

///|
pub const ODK_HWAN : Byte = 7

///|
pub const ODK_HWO : Byte = 8

///|
pub const ODK_GP_GROU : Byte = 9

///|
pub const ODK_IDEN : Byte = 10

///|
pub const ODK_PAGESIZ : Byte = 11

///|
pub const OEX_FPU_MIN : UInt = 0x0000001fU

///|
pub const OEX_FPU_MAX : UInt = 0x00001f00U

///|
pub const OEX_PAGE0 : UInt = 0x00010000U

///|
pub const OEX_SMM : UInt = 0x00020000U

///|
pub const OEX_PRECISEFP : UInt = 0x00040000U

///|
pub const OEX_DISMISS : UInt = 0x00080000U

///|
pub const OEX_FPU_INEX : UInt = 0x01U

///|
pub const OEX_FPU_UFLO : UInt = 0x02U

///|
pub const OEX_FPU_OFLO : UInt = 0x04U

///|
pub const OEX_FPU_DIV0 : UInt = 0x08U

///|
pub const OEX_FPU_INVAL : UInt = 0x10U

///|
pub const OHW_R4KEOP : UInt = 0x00000001U

///|
pub const OHW_R8KPFETCH : UInt = 0x00000002U

///|
pub const OHW_R5KEOP : UInt = 0x00000004U

///|
pub const OHW_R5KCVTL : UInt = 0x00000008U

///|
pub const OHW_R10KLDL : UInt = 0x00000010U

///|
pub const OPAD_PREFIX : UInt = 0x1U

///|
pub const OPAD_POSTFIX : UInt = 0x2U

///|
pub const OPAD_SYMBOL : UInt = 0x4U

///|
pub const OHWA0_R4KEOP_CHECKED : UInt = 0x00000001U

///|
pub const OHWA0_R4KEOP_CLEAN : UInt = 0x00000002U

///|
pub const OHWO0_FIXADE : UInt = 0x00000001U

///|
pub const RSS_UNDEF : UInt = 0U

///|
pub const RSS_GP : UInt = 1U

///|
pub const RSS_GP0 : UInt = 2U

///|
pub const RSS_LOC : UInt = 3U

///|
pub const R_MIPS_NONE : Byte = 0

///|
pub const R_MIPS_16 : Byte = 1

///|
pub const R_MIPS_32 : Byte = 2

///|
pub const R_MIPS_ADD : Byte = R_MIPS_32

///|
pub const R_MIPS_REL32 : Byte = 3

///|
pub const R_MIPS_REL : Byte = R_MIPS_REL32

///|
pub const R_MIPS_26 : Byte = 4

///|
pub const R_MIPS_HI16 : Byte = 5

///|
pub const R_MIPS_LO16 : Byte = 6

///|
pub const R_MIPS_GPREL16 : Byte = 7

///|
pub const R_MIPS_GPREL : Byte = R_MIPS_GPREL16

///|
pub const R_MIPS_LITERAL : Byte = 8

///|
pub const R_MIPS_GOT16 : Byte = 9

///|
pub const R_MIPS_GOT : Byte = R_MIPS_GOT16

///|
pub const R_MIPS_PC16 : Byte = 10

///|
pub const R_MIPS_CALL16 : Byte = 11

///|
pub const R_MIPS_CALL : Byte = R_MIPS_CALL16

///|
pub const R_MIPS_GPREL32 : Byte = 12

///|
pub const R_MIPS_SHIFT5 : Byte = 16

///|
pub const R_MIPS_SHIFT6 : Byte = 17

///|
pub const R_MIPS_64 : Byte = 18

///|
pub const R_MIPS_GOT_DISP : Byte = 19

///|
pub const R_MIPS_GOT_PAGE : Byte = 20

///|
pub const R_MIPS_GOT_OFST : Byte = 21

///|
pub const R_MIPS_GOT_HI16 : Byte = 22

///|
pub const R_MIPS_GOT_LO16 : Byte = 23

///|
pub const R_MIPS_SUB : Byte = 24

///|
pub const R_MIPS_INSERT_A : Byte = 25

///|
pub const R_MIPS_INSERT_B : Byte = 26

///|
pub const R_MIPS_DELETE : Byte = 27

///|
pub const R_MIPS_HIGHER : Byte = 28

///|
pub const R_MIPS_HIGHEST : Byte = 29

///|
pub const R_MIPS_CALL_HI16 : Byte = 30

///|
pub const R_MIPS_CALL_LO16 : Byte = 31

///|
pub const R_MIPS_SCN_DISP : Byte = 32

///|
pub const R_MIPS_REL16 : Byte = 33

///|
pub const R_MIPS_ADD_IMMEDIATE : Byte = 34

///|
pub const R_MIPS_PJUMP : Byte = 35

///|
pub const R_MIPS_RELGOT : Byte = 36

///|
pub const R_MIPS_JALR : Byte = 37

///|
pub const R_MIPS_TLS_DTPMOD32 : Byte = 38

///|
pub const R_MIPS_TLS_DTPREL3 : Byte = 39

///|
pub const R_MIPS_TLS_DTPMOD6 : Byte = 40

///|
pub const R_MIPS_TLS_DTPREL64 : Byte = 41

///|
pub const R_MIPS_TLS_GD : Byte = 42

///|
pub const R_MIPS_TLS_LDM : Byte = 43

///|
pub const R_MIPS_TLS_DTPREL_HI16 : Byte = 44

///|
pub const R_MIPS_TLS_DTPREL_LO16 : Byte = 45

///|
pub const R_MIPS_TLS_GOTTPREL : Byte = 46

///|
pub const R_MIPS_TLS_TPREL32 : Byte = 47

///|
pub const R_MIPS_TLS_TPREL64 : Byte = 48

///|
pub const R_MIPS_TLS_TPREL_HI16 : Byte = 49

///|
pub const R_MIPS_TLS_TPREL_LO16 : Byte = 50

///|
pub const R_MIPS_GLOB_DAT : Byte = 51

///|
pub const R_MIPS_COPY : Byte = 126

///|
pub const R_MIPS_JUMP_SLOT : Byte = 127

///|
pub const DT_MIPS_RLD_VERSION : UInt = 0x70000001U

///|
pub const DT_MIPS_TIME_STAMP : UInt = 0x70000002U

///|
pub const DT_MIPS_ICHECKSUM : UInt = 0x70000003U

///|
pub const DT_MIPS_IVERSION : UInt = 0x70000004U

///|
pub const DT_MIPS_FLAG : UInt = 0x70000005U

///|
pub const DT_MIPS_BASE_ADDRESS : UInt = 0x70000006U

///|
pub const DT_MIPS_MSYM : UInt = 0x70000007U

///|
pub const DT_MIPS_CONFLICT : UInt = 0x70000008U

///|
pub const DT_MIPS_LIBLIST : UInt = 0x70000009U

///|
pub const DT_MIPS_LOCAL_GOTNO : UInt = 0x7000000aU

///|
pub const DT_MIPS_CONFLICTNO : UInt = 0x7000000bU

///|
pub const DT_MIPS_LIBLISTNO : UInt = 0x70000010U

///|
pub const DT_MIPS_SYMTABNO : UInt = 0x70000011U

///|
pub const DT_MIPS_UNREFEXTNO : UInt = 0x70000012U

///|
pub const DT_MIPS_GOTSYM : UInt = 0x70000013U

///|
pub const DT_MIPS_HIPAGENO : UInt = 0x70000014U

///|
pub const DT_MIPS_RLD_MAP : UInt = 0x70000016U

///|
pub const DT_MIPS_DELTA_CLASS : UInt = 0x70000017U

///|
pub const DT_MIPS_DELTA_CLASS_NO : UInt = 0x70000018U

///|
pub const DT_MIPS_DELTA_INSTANCE : UInt = 0x70000019U

///|
pub const DT_MIPS_DELTA_INSTANCE_NO : UInt = 0x7000001aU

///|
pub const DT_MIPS_DELTA_RELOC : UInt = 0x7000001bU

///|
pub const DT_MIPS_DELTA_RELOC_NO : UInt = 0x7000001cU

///|
pub const DT_MIPS_DELTA_SYM : UInt = 0x7000001dU

///|
pub const DT_MIPS_DELTA_SYM_NO : UInt = 0x7000001eU

///|
pub const DT_MIPS_DELTA_CLASSSYM : UInt = 0x70000020U

///|
pub const DT_MIPS_DELTA_CLASSSYM_NO : UInt = 0x70000021U

///|
pub const DT_MIPS_CXX_FLAGS : UInt = 0x70000022U

///|
pub const DT_MIPS_PIXIE_INIT : UInt = 0x70000023U

///|
pub const DT_MIPS_SYMBOL_LIB : UInt = 0x70000024U

///|
pub const DT_MIPS_LOCALPAGE_GOTIDX : UInt = 0x70000025U

///|
pub const DT_MIPS_LOCAL_GOTIDX : UInt = 0x70000026U

///|
pub const DT_MIPS_HIDDEN_GOTIDX : UInt = 0x70000027U

///|
pub const DT_MIPS_PROTECTED_GOTIDX : UInt = 0x70000028U

///|
pub const DT_MIPS_OPTIONS : UInt = 0x70000029U

///|
pub const DT_MIPS_INTERFACE : UInt = 0x7000002aU

///|
pub const DT_MIPS_DYNSTR_ALIGN : UInt = 0x7000002bU

///|
pub const DT_MIPS_INTERFACE_SIZE : UInt = 0x7000002cU

///|
pub const DT_MIPS_RLD_TEXT_RESOLVE_ADDR : UInt = 0x7000002dU

///|
pub const DT_MIPS_PERF_SUFFIX : UInt = 0x7000002eU

///|
pub const DT_MIPS_COMPACT_SIZE : UInt = 0x7000002fU

///|
pub const DT_MIPS_GP_VALUE : UInt = 0x70000030U

///|
pub const DT_MIPS_AUX_DYNAMIC : UInt = 0x70000031U

///|
pub const DT_MIPS_DIRECT : UInt = 0x70000032U

///|
pub const DT_MIPS_RLD_OBJ_UPDATE : UInt = 0x70000033U

///|
pub const RHF_NONE : UInt = 0x00000000U

///|
pub const RHF_QUICKSTART : UInt = 0x00000001U

///|
pub const RHF_NOTPOT : UInt = 0x00000002U

///|
pub const RHF_NO_LIBRARY_REPLACEMENT : UInt = 0x00000004U

///|
pub const RHF_NO_MOVE : UInt = 0x00000008U

///|
pub const RHF_SGI_ONLY : UInt = 0x00000010U

///|
pub const RHF_GUARANTEE_INIT : UInt = 0x00000020U

///|
pub const RHF_DELTA_C_PLUS_PLUS : UInt = 0x00000040U

///|
pub const RHF_GUARANTEE_START_INIT : UInt = 0x00000080U

///|
pub const RHF_PIXIE : UInt = 0x00000100U

///|
pub const RHF_DEFAULT_DELAY_LOAD : UInt = 0x00000200U

///|
pub const RHF_REQUICKSTART : UInt = 0x00000400U

///|
pub const RHF_REQUICKSTARTED : UInt = 0x00000800U

///|
pub const RHF_CORD : UInt = 0x00001000U

///|
pub const RHF_NO_UNRES_UNDEF : UInt = 0x00002000U

///|
pub const RHF_RLD_ORDER_SAFE : UInt = 0x00004000U

///|
pub const ELF32_EHDR_TAILSIZE : Int = 36

///|
pub const ELF64_EHDR_TAILSIZE : Int = 48
