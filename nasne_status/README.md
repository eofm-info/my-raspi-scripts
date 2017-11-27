nasne の情報を取得して、Zabbix へ送りつけるかんたんなスクリプトです。

## 各情報 (key) の説明

- hdd_count
    - nasne に繋がれて、現在マウントされている HDD の数です
    - nasne ひとつに対して外付け HDD はひとつしか増設できないため、Zabbix 側では 2 未満になったら障害としています
        - なんか知らないけど、家の nasne のひとつが HDD 認識できなくなったあと死ぬことがまれにあって、とくに監視したかった項目のひとつ
- hdd0_free / hdd0_used
    - 内蔵 HDD の空き容量と使用容量です
- hdd1_free / hdd1_used
    - 外付け HDD の空き容量と使用容量です
    - hdd0_, hdd1_ と固定の名前にしていますが、もしかしたら id 変わったりするのかもしれません。知らん！
- rec_count
    - 録画件数です
    - 1000 を超えると録画できなくなるという言い伝えがあるため監視しています。なぜ 1000 なのか……
    - だそうです！ [今日から｢nasne(ナスネ)™｣がVer.2.60にアップデート！ 最大録画件数が1,000件から3,000件に大幅拡張！ | PlayStation.Blog](https://www.jp.playstation.com/blog/detail/5997/20171116-nasne.html)

## その他

ご自由にお使いください。

使用する場合は `cnf.yml.default` を `cnf.yml` に変更して、適当な値に変更してください。

`cnf.yml` の `nasne` の配列に追加すれば、きっと数が増えても大丈夫ですが、HDD は増設することを前提としています。nasne に HDD 増設せずに使っている人なんてきっといません。

下記一連の連載、参考にさせていただきましたm(_ _)m

[これから始めるZabbix Sender(1) サーバにデータを送るには？](http://pocketstudio.jp/log3/2015/01/07/howto-use-zabbix-sender/)
