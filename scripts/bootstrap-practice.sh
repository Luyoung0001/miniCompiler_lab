#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRACTICE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
LAB_ROOT="${PRACTICE_ROOT}/labs/lab01-step1"

check_cmd() {
  local cmd="$1"
  local hint="$2"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "[ERROR] 缺少命令: $cmd"
    echo "        $hint"
    exit 1
  fi
}

echo "=== minicompiler practice bootstrap ==="
check_cmd gcc "请先安装主机编译器 gcc"
check_cmd riscv64-unknown-linux-gnu-gcc "请先安装 RISC-V 交叉工具链"
check_cmd qemu-riscv32 "请先安装 qemu-user / qemu-riscv32"

echo "[OK] gcc / riscv64-unknown-linux-gnu-gcc / qemu-riscv32 已找到"
echo
echo "=== 进入 Lab01 baseline ==="
set +e
SMOKE_OUTPUT="$(
  cd "${LAB_ROOT}"
  make clean >/dev/null
  make test 2>&1
)"
SMOKE_STATUS=$?
set -e

printf '%s\n' "$SMOKE_OUTPUT"

if [[ $SMOKE_STATUS -ne 0 ]]; then
  if [[ "$SMOKE_OUTPUT" != *"[TEST"* && "$SMOKE_OUTPUT" != *"test(s) FAILED."* ]]; then
    echo "[ERROR] smoke test 没有进入验证阶段，请先修复编译或链接错误。" >&2
    exit "$SMOKE_STATUS"
  fi
fi

cat <<'EOF'

预期说明：
- Chapter 0 的默认基线不是全 PASS
- Lab01 初始状态通常会出现若干 FAIL
- 这说明你已经进入学员实践骨架，而不是完整参考实现

下一步：
1. 返回 course/00-orientation.md 收尾
2. 阅读 course/chapters/ch01-step1-driver.md
3. 打开 labs/lab01-step1/TASK.md 和 framework/student.c
EOF
