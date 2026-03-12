# Today I Learned

A collection of small things I learn daily.

## Categories

- DevOps
- Automation
- Travel Tech

## Setup

### GitHub Actions (tự động mỗi ngày)

1. Thêm secret `OPEN_ROUTER_API_KEY` vào repo: **Settings** → **Secrets and variables** → **Actions**
2. Workflow chạy lúc 17:00 UTC (00:00 VN) hoặc **Run workflow** thủ công

### CLI (chạy local)

```bash
# Random tech topic
./til

# Với chủ đề cụ thể
./til "học cách tạo skill, subagent trên cursor"
```

Cần: `jq`, `curl`, và file `.env` với `OPEN_ROUTER_API_KEY=...`
