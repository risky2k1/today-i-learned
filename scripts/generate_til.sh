#!/bin/bash

set -e

mkdir -p daily/$MONTH
FILE="daily/$MONTH/$DATE.md"

PROMPT='Bạn là một developer Việt Nam đang ghi lại Today I Learned cho chính mình.

Yêu cầu:
- Chọn ngẫu nhiên MỘT trong các category sau: DevOps, Automation, Travel Tech, Programming, Trekking - Hiking - Camping (Các địa điểm ở Việt Nam).
- Hạn chế lặp lại đúng cùng chủ đề nếu vài ngày gần đây đã nói.
- Viết 1 mục Today I Learned ngắn gọn (2-4 câu), tiếng Việt tự nhiên.
- Format markdown:
  - Dòng đầu: ## [Tên category]
  - Sau đó là 1 đoạn text hoặc 1-3 bullet points.
- Có thể thêm 1 câu nhận xét cá nhân hoặc plan áp dụng.'

# Nếu có API key → gọi AI
if [ -n "$OPEN_ROUTER_API_KEY" ]; then

  BODY=$(cat <<EOF
{
  "model": "arcee-ai/trinity-large-preview:free",
  "messages": [
    {
      "role": "user",
      "content": "$PROMPT"
    }
  ]
}
EOF
)

  RESPONSE=$(curl -s -X POST "https://openrouter.ai/api/v1/chat/completions" \
    -H "Authorization: Bearer $OPEN_ROUTER_API_KEY" \
    -H "Content-Type: application/json" \
    -d "$BODY")

  CONTENT=$(echo "$RESPONSE" | jq -r '.choices[0].message.content // empty')

  if [ -n "$CONTENT" ]; then
    if [ -f "$FILE" ]; then
      echo -e "\n\n$CONTENT" >> "$FILE"
      echo "Appended to existing file"
    else
      echo -e "# $DATE\n\n$CONTENT" > "$FILE"
      echo "Created new file with AI content"
    fi
  else
    echo "API failed, fallback"
    if [ ! -f "$FILE" ]; then
      echo -e "# $DATE\n\n## DevOps\n- Hôm nay chưa có thông tin." > "$FILE"
    fi
  fi

else
  echo "No API key, fallback"
  if [ ! -f "$FILE" ]; then
    echo -e "# $DATE\n\n## DevOps\n- Hôm nay chưa có thông tin." > "$FILE"
  fi
fi