#!/bin/bash

# 用法: ./resize.sh <資料夾路徑> [最短邊大小]
# 例如 ./resize.sh staff
 
FOLDER=$1
MIN_SIZE=${2:-250}  # 預設 250

if [ -z "$FOLDER" ]; then
  echo "用法: $0 <資料夾路徑> [最短邊大小]"
  exit 1
fi

# 進入資料夾
cd "$FOLDER" || exit 1

# 處理 jpg/jpeg/png
for f in *.jpg *.jpeg *.png; do
  [ -e "$f" ] || continue
  echo "處理 $f ..."
  mogrify -resize "${MIN_SIZE}x${MIN_SIZE}" "$f"
done

