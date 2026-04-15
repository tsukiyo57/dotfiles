# dotfiles — DGX Spark (ARM64 Ubuntu 24.04)

OS 再インストール後の環境復元用リポジトリ。

## 構成

```
dotfiles/
  setup.sh                  # マスタインストールスクリプト
  comfyui/
    custom_nodes.txt         # カスタムノード一覧
    install.sh               # インストール手順
  searxng/
    settings.yml             # SearXNG 設定（secret_key は要変更）
  vscode/
    settings.json            # VS Code 設定
    extensions.txt           # 拡張機能一覧
    install.sh               # 拡張機能インストーラ
  keyboard/
    keyboard                 # /etc/default/keyboard（JP レイアウト, ctrl:nocaps）
    ibus_config.textproto    # IBus/Mozc 設定
    xrdp_keyboard.ini        # XRDP キーボードマッピング
    install.sh               # 設定適用スクリプト
  docker/
    docker-compose.yml       # n8n
  whisper/
    launch.sh                # Whisper server 起動スクリプト
  browser/
    chromium-hw              # Chromium ハードウェアデコード wrapper
    firefox-hw               # Firefox ハードウェアデコード wrapper
```

## クイックスタート

```bash
git clone https://github.com/tsukiyo57/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x setup.sh
./setup.sh --all
```

個別に実行することも可能:

```bash
./setup.sh --vscode    # VS Code
./setup.sh --keyboard  # キーボード設定
./setup.sh --browser   # ブラウザスクリプト
./setup.sh --docker    # n8n Docker
./setup.sh --searxng   # SearXNG
./setup.sh --comfyui   # ComfyUI カスタムノード
./setup.sh --whisper   # Whisper サーバー
```

## 注意事項

### SearXNG
`searxng/settings.yml` の `secret_key` を新しいランダム値に変更すること:
```bash
openssl rand -hex 32
# → 生成された値を settings.yml の REPLACE_WITH_RANDOM_SECRET と置換
```

### n8n
`~/docker-services/.env` を作成して以下を設定:
```
NOTION_TOKEN=secret_...
NOTION_DATABASE_ID=...
NOTION_DIGEST_DATABASE_ID=...
GEMINI_API_KEY=...
```

### ComfyUI
モデル（167GB）は手動で再ダウンロード。  
カスタムノードは ComfyUI-Manager の UI または `comfyui/install.sh` を参照。

### ハードウェアビデオデコード
XRDP + X11 + NVIDIA 環境では現時点（2026-04）でブラウザのハードウェアデコードは動作しない:
- Chromium (snap): VA-API がコンパイルされていない
- Firefox: バグ [1924578](https://bugzilla.mozilla.org/show_bug.cgi?id=1924578) (NVIDIA binary + X11 + DMA-BUF 非互換)

`browser/` スクリプトはベストエフォートとして残してある。

### nvidia-vaapi-driver
```bash
sudo apt install nvidia-vaapi-driver
# → /usr/lib/aarch64-linux-gnu/dri/nvidia_drv_video.so
# setup.sh --browser で ~/.local/lib/dri/ へコピーされる
```
