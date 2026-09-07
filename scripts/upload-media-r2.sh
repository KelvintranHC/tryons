#!/usr/bin/env bash
# Upload Wave landing media to Cloudflare R2 (S3-compatible).
#
# Prerequisites:
#   1. Create an R2 bucket (e.g. wave-media) + public access / custom domain
#   2. Create R2 API token with Object Read & Write
#   3. brew install awscli
#
# Usage:
#   export AWS_ACCESS_KEY_ID="..."
#   export AWS_SECRET_ACCESS_KEY="..."
#   export R2_ACCOUNT_ID="your_cloudflare_account_id"
#   export R2_BUCKET="wave-media"
#   ./scripts/upload-media-r2.sh
#
# Then in index.html <head>:
#   <script>window.WAVE_MEDIA_BASE = 'https://YOUR_PUBLIC_R2_OR_CUSTOM_DOMAIN';</script>

set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

: "${AWS_ACCESS_KEY_ID:?Set AWS_ACCESS_KEY_ID (R2 token)}"
: "${AWS_SECRET_ACCESS_KEY:?Set AWS_SECRET_ACCESS_KEY (R2 token)}"
: "${R2_ACCOUNT_ID:?Set R2_ACCOUNT_ID}"
: "${R2_BUCKET:?Set R2_BUCKET}"

ENDPOINT="https://${R2_ACCOUNT_ID}.r2.cloudflarestorage.com"
AWS=(aws --endpoint-url "$ENDPOINT" --region auto)

FILES=(
  media/hero.mp4
  media/short_01.mp4
  media/short_01.jpg
  media/dongho.png
  media/examples/short_05.mp4
  media/examples/short_05.jpg
  media/examples/short_06.mp4
  media/examples/short_06.jpg
  media/examples/short_07.mp4
  media/examples/short_07.jpg
  media/examples/short_fashion_02.mp4
  media/examples/short_fashion_02.jpg
  media/examples/short_fashion_03.mp4
  media/examples/short_fashion_03.jpg
  media/examples/short_fashion_04.mp4
  media/examples/short_fashion_04.jpg
)

echo "Uploading ${#FILES[@]} files to s3://${R2_BUCKET}/ ..."
for f in "${FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "Skip missing: $f" >&2
    continue
  fi
  case "$f" in
    *.mp4) ctype="video/mp4" ;;
    *.jpg|*.jpeg) ctype="image/jpeg" ;;
    *.png) ctype="image/png" ;;
    *) ctype="application/octet-stream" ;;
  esac
  echo "→ $f ($ctype)"
  "${AWS[@]}" s3 cp "$f" "s3://${R2_BUCKET}/$f" \
    --content-type "$ctype" \
    --cache-control "public, max-age=31536000, immutable"
done

echo ""
echo "Done. Set in index.html <head>:"
echo "  <script>window.WAVE_MEDIA_BASE = 'https://YOUR_PUBLIC_MEDIA_HOST';</script>"
echo "Ensure the R2 bucket/custom domain allows public GET + CORS for your Vercel domain."
