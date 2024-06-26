// RUN: llvm-tblgen -gen-asm-matcher -I %p/../../include %s | FileCheck %s

// Check that MatchRegisterName and MatchRegisterAltName are generated
// correctly when multiple registers are defined with the same name and
// AllowDuplicateRegisterNames is set.

include "llvm/Target/Target.td"

def ArchInstrInfo : InstrInfo;

def ArchAsmParser : AsmParser {
  let AllowDuplicateRegisterNames = 1;
  let ShouldEmitMatchRegisterAltName = 1;
}

def Arch : Target {
  let InstructionSet = ArchInstrInfo;
  let AssemblyParsers = [ArchAsmParser];
}

let Namespace = "Arch" in {
class ArchReg<string n, list <string> alt, list <RegAltNameIndex> altidx>
    : Register<n> {
  let AltNames = alt;
  let RegAltNameIndices = altidx;
}

def ABIRegAltName : RegAltNameIndex;

foreach i = 0...3 in {
  def R#i#_32 : ArchReg<"r"#i, ["x"#i], [ABIRegAltName]>;
  def R#i#_64 : ArchReg<"r"#i, ["x"#i], [ABIRegAltName]>;
}
} // Namespace = "Arch"

def GPR32 : RegisterClass<"Arch", [i32], 32, (add
    (sequence "R%u_32", 0, 3)
)>;

def GPR64 : RegisterClass<"Arch", [i64], 64, (add
    (sequence "R%u_64", 0, 3)
)>;

// CHECK: static MCRegister MatchRegisterName(StringRef Name) {
// CHECK:   switch (Name.size()) {
// CHECK:   default: break;
// CHECK:   case 2:  // 8 strings to match.
// CHECK:     if (Name[0] != 'r')
// CHECK:       break;
// CHECK:     switch (Name[1]) {
// CHECK:     default: break;
// CHECK:     case '0':  // 2 strings to match.
// CHECK:       return Arch::R0_32;  // "r0"
// CHECK:     case '1':  // 2 strings to match.
// CHECK:       return Arch::R1_32;  // "r1"
// CHECK:     case '2':  // 2 strings to match.
// CHECK:       return Arch::R2_32;  // "r2"
// CHECK:     case '3':  // 2 strings to match.
// CHECK:       return Arch::R3_32;  // "r3"
// CHECK:     }
// CHECK:     break;
// CHECK:   }
// CHECK:   return Arch::NoRegister;
// CHECK: }

// CHECK: static MCRegister MatchRegisterAltName(StringRef Name) {
// CHECK:   switch (Name.size()) {
// CHECK:   default: break;
// CHECK:   case 2:  // 8 strings to match.
// CHECK:     if (Name[0] != 'x')
// CHECK:       break;
// CHECK:     switch (Name[1]) {
// CHECK:     default: break;
// CHECK:     case '0':  // 2 strings to match.
// CHECK:       return Arch::R0_32;  // "x0"
// CHECK:     case '1':  // 2 strings to match.
// CHECK:       return Arch::R1_32;  // "x1"
// CHECK:     case '2':  // 2 strings to match.
// CHECK:       return Arch::R2_32;  // "x2"
// CHECK:     case '3':  // 2 strings to match.
// CHECK:       return Arch::R3_32;  // "x3"
// CHECK:     }
// CHECK:     break;
// CHECK:   }
// CHECK:   return Arch::NoRegister;
// CHECK: }
