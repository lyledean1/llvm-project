; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -O0 -mtriple=aarch64-linux-gnu -global-isel -stop-after=irtranslator %s -o - | FileCheck %s

define i32 @call_trunc_no_flags(i64 %a) {
  ; CHECK-LABEL: name: call_trunc_no_flags
  ; CHECK: bb.1.entry:
  ; CHECK-NEXT:   liveins: $x0
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(s64) = COPY $x0
  ; CHECK-NEXT:   [[TRUNC:%[0-9]+]]:_(s32) = G_TRUNC [[COPY]](s64)
  ; CHECK-NEXT:   $w0 = COPY [[TRUNC]](s32)
  ; CHECK-NEXT:   RET_ReallyLR implicit $w0
entry:
  %result = trunc i64 %a to i32
  ret i32 %result
}

define i32 @call_trunc_nsw_flags(i64 %a) {
  ; CHECK-LABEL: name: call_trunc_nsw_flags
  ; CHECK: bb.1.entry:
  ; CHECK-NEXT:   liveins: $x0
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(s64) = COPY $x0
  ; CHECK-NEXT:   [[TRUNC:%[0-9]+]]:_(s32) = nsw G_TRUNC [[COPY]](s64)
  ; CHECK-NEXT:   $w0 = COPY [[TRUNC]](s32)
  ; CHECK-NEXT:   RET_ReallyLR implicit $w0
entry:
  %result = trunc nsw i64 %a to i32
  ret i32 %result
}

define i32 @call_trunc_nuw_flags(i64 %a) {
  ; CHECK-LABEL: name: call_trunc_nuw_flags
  ; CHECK: bb.1.entry:
  ; CHECK-NEXT:   liveins: $x0
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(s64) = COPY $x0
  ; CHECK-NEXT:   [[TRUNC:%[0-9]+]]:_(s32) = nuw G_TRUNC [[COPY]](s64)
  ; CHECK-NEXT:   $w0 = COPY [[TRUNC]](s32)
  ; CHECK-NEXT:   RET_ReallyLR implicit $w0
entry:
  %result = trunc nuw i64 %a to i32
  ret i32 %result
}

define i32 @call_trunc_all_flags(i64 %a) {
  ; CHECK-LABEL: name: call_trunc_all_flags
  ; CHECK: bb.1.entry:
  ; CHECK-NEXT:   liveins: $x0
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(s64) = COPY $x0
  ; CHECK-NEXT:   [[TRUNC:%[0-9]+]]:_(s32) = nuw nsw G_TRUNC [[COPY]](s64)
  ; CHECK-NEXT:   $w0 = COPY [[TRUNC]](s32)
  ; CHECK-NEXT:   RET_ReallyLR implicit $w0
entry:
  %result = trunc nsw nuw i64 %a to i32
  ret i32 %result
}

define <2 x i64> @call_trunc_noop_signed_vector(<2 x i64> %a) {
  ; CHECK-LABEL: name: call_trunc_noop_signed_vector
  ; CHECK: bb.1.entry:
  ; CHECK-NEXT:   liveins: $q0
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(<2 x s64>) = COPY $q0
  ; CHECK-NEXT:   [[TRUNC:%[0-9]+]]:_(<2 x s32>) = nsw G_TRUNC [[COPY]](<2 x s64>)
  ; CHECK-NEXT:   [[SEXT:%[0-9]+]]:_(<2 x s64>) = G_SEXT [[TRUNC]](<2 x s32>)
  ; CHECK-NEXT:   $q0 = COPY [[SEXT]](<2 x s64>)
  ; CHECK-NEXT:   RET_ReallyLR implicit $q0
entry:
  %truncate = trunc nsw <2 x i64> %a to <2 x i32>
  %result = sext <2 x i32> %truncate to <2 x i64>
  ret <2 x i64> %result
}

define <2 x i64> @call_trunc_noop_unsigned_vector(<2 x i64> %a) {
  ; CHECK-LABEL: name: call_trunc_noop_unsigned_vector
  ; CHECK: bb.1.entry:
  ; CHECK-NEXT:   liveins: $q0
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(<2 x s64>) = COPY $q0
  ; CHECK-NEXT:   [[TRUNC:%[0-9]+]]:_(<2 x s32>) = nuw G_TRUNC [[COPY]](<2 x s64>)
  ; CHECK-NEXT:   [[ZEXT:%[0-9]+]]:_(<2 x s64>) = G_ZEXT [[TRUNC]](<2 x s32>)
  ; CHECK-NEXT:   $q0 = COPY [[ZEXT]](<2 x s64>)
  ; CHECK-NEXT:   RET_ReallyLR implicit $q0
entry:
  %truncate = trunc nuw <2 x i64> %a to <2 x i32>
  %result = zext <2 x i32> %truncate to <2 x i64>
  ret <2 x i64> %result
}
