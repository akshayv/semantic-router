#!/usr/bin/env bash
# Export Rust binding .so files from an existing router image for go-only rebuilds.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
IMAGE="${1:-ghcr.io/vllm-project/semantic-router/vllm-sr:latest}"
OUTDIR="${2:-${ROOT}/.router-prebuilt}"

LIBS=(
	libcandle_semantic_router.so
	libml_semantic_router.so
	libnlp_binding.so
)

mkdir -p "${OUTDIR}/lib"
cid="$(docker create "${IMAGE}")"
trap 'docker rm -f "${cid}" >/dev/null 2>&1 || true' EXIT

for lib in "${LIBS[@]}"; do
	docker cp "${cid}:/usr/local/lib/${lib}" "${OUTDIR}/lib/${lib}"
	echo "exported ${lib}"
done

echo "Bindings written to ${OUTDIR}/lib"
