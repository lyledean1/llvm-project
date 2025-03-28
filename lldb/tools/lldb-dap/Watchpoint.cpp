//===-- Watchpoint.cpp ------------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Watchpoint.h"
#include "DAP.h"
#include "JSONUtils.h"
#include "lldb/API/SBTarget.h"
#include "lldb/lldb-enumerations.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/JSON.h"
#include <cstdint>
#include <string>

namespace lldb_dap {
Watchpoint::Watchpoint(DAP &d, const llvm::json::Object &obj)
    : BreakpointBase(d, obj) {
  llvm::StringRef dataId = GetString(obj, "dataId").value_or("");
  std::string accessType = GetString(obj, "accessType").value_or("").str();
  auto [addr_str, size_str] = dataId.split('/');
  llvm::to_integer(addr_str, addr, 16);
  llvm::to_integer(size_str, size);
  options.SetWatchpointTypeRead(accessType != "write");
  if (accessType != "read")
    options.SetWatchpointTypeWrite(lldb::eWatchpointWriteTypeOnModify);
}

void Watchpoint::SetCondition() { wp.SetCondition(condition.c_str()); }

void Watchpoint::SetHitCondition() {
  uint64_t hitCount = 0;
  if (llvm::to_integer(hitCondition, hitCount))
    wp.SetIgnoreCount(hitCount - 1);
}

void Watchpoint::CreateJsonObject(llvm::json::Object &object) {
  if (!error.IsValid() || error.Fail()) {
    object.try_emplace("verified", false);
    if (error.Fail())
      EmplaceSafeString(object, "message", error.GetCString());
  } else {
    object.try_emplace("verified", true);
  }
}

void Watchpoint::SetWatchpoint() {
  wp = dap.target.WatchpointCreateByAddress(addr, size, options, error);
  if (!condition.empty())
    SetCondition();
  if (!hitCondition.empty())
    SetHitCondition();
}
} // namespace lldb_dap
