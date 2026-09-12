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
# Or with .env.r2:
#   set -a && source .env.r2 && set +a && ./scripts/upload-media-r2.sh
#
# Then in index.html <head>:
#   window.WAVE_MEDIA_BASE = 'https://YOUR_PUBLIC_R2_OR_CUSTOM_DOMAIN'

set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

: "${AWS_ACCESS_KEY_ID:?Set AWS_ACCESS_KEY_ID (R2 token)}"
: "${AWS_SECRET_ACCESS_KEY:?Set AWS_SECRET_ACCESS_KEY (R2 token)}"
# Accept either R2_ACCOUNT_ID or CLOUDFLARE_ACCOUNT_ID (from .env.r2)
R2_ACCOUNT_ID="${R2_ACCOUNT_ID:-${CLOUDFLARE_ACCOUNT_ID:-}}"
: "${R2_ACCOUNT_ID:?Set R2_ACCOUNT_ID or CLOUDFLARE_ACCOUNT_ID}"
: "${R2_BUCKET:?Set R2_BUCKET}"

ENDPOINT="${R2_ENDPOINT:-https://${R2_ACCOUNT_ID}.r2.cloudflarestorage.com}"
AWS=(aws --endpoint-url "$ENDPOINT" --region auto)

# Heavy video + posters (playback), plus all UI static assets referenced by the page.
FILES=(
  media/hero.mp4
  media/short_01.mp4
  media/short_01.jpg
  media/dongho.png
  media/logo.png
  media/og-image.png
  media/author.jpg
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
  media/gallery/look-1/01.jpg
  media/gallery/look-1/02.jpg
  media/gallery/look-1/03.jpg
  media/gallery/look-1/04.jpg
  media/gallery/look-1/05.jpg
  media/gallery/look-2/01.jpg
  media/gallery/look-2/02.jpg
  media/gallery/look-2/03.jpg
  media/gallery/look-2/04.jpg
  media/gallery/look-2/05.jpg
  media/gallery/look-3/01.jpg
  media/gallery/look-3/02.jpg
  media/gallery/look-3/03.jpg
  media/gallery/look-3/04.jpg
  media/gallery/look-3/05.jpg
  media/gallery/look-4/01.jpg
  media/gallery/look-4/02.jpg
  media/gallery/look-4/03.jpg
  media/gallery/look-4/04.jpg
  media/gallery/look-4/05.jpg
  media/gallery/look-4/06.jpg
  media/gallery/look-5/01.jpg
  media/gallery/look-5/02.jpg
  media/icons/adobe-premiere.svg
  media/icons/canva.svg
  media/icons/capcut.svg
  media/icons/claude.svg
  media/icons/elevenlabs.svg
  media/icons/epidemic-sound.png
  media/icons/gemini.svg
  media/icons/higgsfield.svg
  media/icons/kling.svg
  media/icons/openai.svg
  media/icons/suno.svg
  media/avatars/bao.jpg
  media/avatars/chau.jpg
  media/avatars/chi.jpg
  media/avatars/dat.jpg
  media/avatars/ha.jpg
  media/avatars/huy.jpg
  media/avatars/linh.jpg
  media/avatars/quan.jpg
  media/avatars/thao.jpg
)

content_type_for() {
  case "$1" in
    *.mp4) echo "video/mp4" ;;
    *.jpg|*.jpeg) echo "image/jpeg" ;;
    *.png) echo "image/png" ;;
    *.svg) echo "image/svg+xml" ;;
    *.webp) echo "image/webp" ;;
    *) echo "application/octet-stream" ;;
  esac
}

echo "Uploading ${#FILES[@]} files to s3://${R2_BUCKET}/ ..."
for f in "${FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "Skip missing: $f" >&2
    continue
  fi
  ctype="$(content_type_for "$f")"
  echo "→ $f ($ctype)"
  "${AWS[@]}" s3 cp "$f" "s3://${R2_BUCKET}/$f" \
    --content-type "$ctype" \
    --cache-control "public, max-age=31536000, immutable"
done

echo ""
echo "Done. Public host should serve:"
echo "  \${WAVE_MEDIA_BASE}/media/logo.png"
echo "Ensure the R2 bucket/custom domain allows public GET + CORS for your site origin."
