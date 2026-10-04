#!/bin/bash
# PreToolUse: ユーザーのメールアドレスを外部へ送りうるツール入力を止める。
# 2026-09-24 に User-Agent へ無断で入れて送信した事故の再発防止。
# 公開リポジトリで管理するため、アドレスは直書きせず git の設定から読む。
# JSON のまま見るため、URL エンコード(%40)と JSON の @ も拾う。
email=$(git config --global user.email 2>/dev/null)
[ -z "$email" ] && exit 0
local_part=$(printf '%s' "${email%@*}" | sed 's/[.[\*^$+?(){}|]/\\&/g')
domain=$(printf '%s' "${email#*@}" | sed 's/[.[\*^$+?(){}|]/\\&/g')
if grep -Eiq "${local_part}(@|%40|\\\\u0040)${domain}"; then
  echo "ユーザーのメールアドレスを含むツール呼び出しはブロックします。外部へのリクエスト(ヘッダー・URL・ペイロード)に入れてはいけません。連絡先が必要なら、送らずにユーザーへ確認してください。" >&2
  exit 2
fi
exit 0
