# LM Studio モデル一覧

ダウンロード先: `~/.lmstudio/models/`  
API エンドポイント: `http://localhost:1234`（n8n・SearXNG から参照）

## インストール済みモデル

| モデル名 | サイズ | 量子化 | メモ |
|---------|-------|-------|------|
| `mmnga-o/llm-jp-4-32b-a3b-thinking-gguf` | 20 GB | Q4_K_M | 日本語特化 LLM（llm-jp-4, 思考モデル） |
| `lmstudio-community/LFM2.5-1.2B-Instruct-GGUF` | 1.2 GB | Q8_0 | 軽量モデル（LFM 2.5, 1.2B） |
| `lmstudio-community/gemma-4-26B-A4B-it-GGUF` | 17 GB | Q4_K_M | Gemma 4 26B（マルチモーダル、mmproj 含む） |
| `lmstudio-community/gpt-oss-120b-GGUF` | 60 GB | MXFP4 | OpenAI GPT OSS 120B（2ファイル分割） |
| `lmstudio-community/NVIDIA-Nemotron-3-Super-120B-A12B-GGUF` | 81 GB | Q4_K_M | NVIDIA Nemotron 120B（3ファイル分割） |

**合計: 約 180 GB**

## 再ダウンロード方法

LM Studio GUI の "Discover" タブで各モデル名を検索してダウンロード。  
または lms CLI:

```bash
# LM Studio CLI
lms get mmnga-o/llm-jp-4-32b-a3b-thinking-gguf
lms get lmstudio-community/LFM2.5-1.2B-Instruct-GGUF
lms get lmstudio-community/gemma-4-26B-A4B-it-GGUF
lms get lmstudio-community/gpt-oss-120b-GGUF
lms get lmstudio-community/NVIDIA-Nemotron-3-Super-120B-A12B-GGUF
```

## LM Studio インストール

ARM64 (aarch64) 用を公式サイトからダウンロードして実行。
PATH に `~/.lmstudio/bin` を追加（`.bashrc` に追記済み）:

```bash
export PATH="$PATH:/home/ryusei/.lmstudio/bin"
```
