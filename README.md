# node.js + express 実行・開発環境

### テンプレート展開とコンテナ起動

appテンプレートの展開とサーバの起動

起動後はログをtailする。CTRL+Cで中断してもコンテナ自体はバックグラウンドで動作。

サーバがエラーで起動できなかった場合でもEXITしないため、shellが実行可能。

	$ ./control.sh create

### コンテナ削除

appを作り直す場合は、別途appディレクトリを削除する。

	$ ./control.sh destroy

### コンテナ停止

	$ ./control.sh stop

### コンテナ開始

	$ ./control.sh start

### コンテナ再起動

	$ ./control.sh restart

### シェル

	$ ./control.sh shell

# ドキュメント

* [Express 4.x API](http://expressjs.com/en/4x/api.html)


