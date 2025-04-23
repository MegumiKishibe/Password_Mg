#!/bin/bash
        echo "パスワードマネージャーへようこそ！"
        while true; do
        echo "次の選択肢から入力してください(Add Password/Get Password/Exit)"
        read personal_info

                if [ "$personal_info" == "Add Password" ]; then
                        echo "サービス名を入力してください："
                        read service_name
                        echo "$service_name" >> service_name.txt

                        echo "ユーザー名を入力してください："
                        read username
                        echo "$username" >> user_name.txt

                        echo "パスワードを入力してください："
                        read password
                        echo "$password" >> pass_word.txt
			gpg --yes --symmetric --chipher-algo AES256 --output pass_word.txt.gpg pass_word.txt

                        echo "パスワードの追加は成功しました。"

                elif [ "$personal_info" == "Get Password" ]; then
                        echo "サービス名を入力してください："
                        read service_name

                        line=$(grep -n "^${service_name}$" service_name.txt | cut -d: -f1) # *

                        if [ -z "$line" ]; then #**
                                echo "そのサービス名は登録されていません。"

                        else
				gpg --quiet --decrypt pass_word.txt.gpg > pass_word.txt

                                echo "サービス名：$(sed -n "${line}p" service_name.txt)" # ***
                                echo "ユーザー名：$(sed -n "${line}p" user_name.txt)"
                                echo "パスワード：$(sed -n "${line}p" pass_word.txt)"

				rm pass_word.txt
                        fi

                elif [ "$personal_info" == "Exit" ]; then
                        echo "Thank you!"
                        exit 0

                else
                        echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
                fi
        done
#-----BEGIN PGP PUBLIC KEY BLOCK-----

mDMEaAjXvxYJKwYBBAHaRw8BAQdAOVexEa70bT9M3bxJqG1YAAhFPed+m8r7lkr+
RCS6xja0Jk1lZ3VtaSBLaXNoaWJlIDxLaXNoaWJlMDQxN0BnbWFpbC5jb20+iJkE
ExYKAEEWIQQHcivkSWCkNduXAM+Rx8xNDxtKCQUCaAjXvwIbAwUJBaOagAULCQgH
AgIiAgYVCgkICwIEFgIDAQIeBwIXgAAKCRCRx8xNDxtKCZ8SAP95Mo1jcDwivQk/
gJtz0WBMG0dCj8UaBrjHvE8RmQfGhwEAzav85avRxKv4lxA5NUentEJ8hvk8jzK0
ay5dobR3iQG4OARoCNe/EgorBgEEAZdVAQUBAQdAqpkaAiyz8a9r9Wtt7jFvpSVB
BmC9J5xP+iMUtjyDQ08DAQgHiH4EGBYKACYWIQQHcivkSWCkNduXAM+Rx8xNDxtK
CQUCaAjXvwIbDAUJBaOagAAKCRCRx8xNDxtKCZDWAP43rvjns6EF8caEqJW02odW
LXd02uRUOu8In8BJa4N3jQD+Lze/JxC7l5DVwdCnHAyRR/cQVEG8fPaduT4sBqFL
hAQ=
=rCot
-----END PGP PUBLIC KEY BLOCK-----
# *標準入力からservice_name.txtの何行目にあるかを調べたい。lineコマンド
元コード：find ./ -type f -name 'service_name.txt' | xargs grep -n --color=auto "${service_name}"
修正後  ：line=$(grep -n "^${service_name}$" sevice_name.txt | cut -d: -f1)
解説    ：line=$(grep -n "検索条件" "検索対象" | cut -d: -f1)
line=$(...)：コマンドの結果を変数に代入/line以下が変数になってる！lineには見つけた行番号が代入される。
grep：ファイルの中からキーワードを検索。（catはファイルを検索するコマンド）
-n　：マッチした行の行番号も表示。
"{$...}：ユーザーが入力した標準入力
"^${...}$"：^行の先頭、＄行の末尾＝文字列の完全一致を表す。
cut：決まったルールで文字列を分割して、必要な部分だけ取り出す。
-d：どこ出来るかを指定。→「：」で切る。と指定（-d:)
-f：何番目を取り出すかを指定する。→1番目を指定（-f1)
        # *xargs grep
        xargs：標準入力を引数としてコマンドに渡す役割を担う。grepと組み合わせることで大量のファイルを効率的に検索できる。
        １、基本的な使い方
        ディレクトリ内の全ての人.txtファイルから特定してのキーワードを検索したい場合：
        find . -name “*.txt” | xargs grep “検索する文字列”
        find . -name “*.txt”：現在のディレクトリから.txtファイルを探す
        xargs：見つかったファイルのリストをgrepに渡す
        grep “検索する文字列”：各ファイルの中で、指定した文字列を検索する
                # **同じ変数を比べても無意味。上のlineコマンドでlineが空なら登録なしと判断。
                元コード：if [ "${service_name}" != "${service_name}" ]; then
                修正後　:if [ -z "$line" ]; then
                -z：文字列が空かどうかをチェック
                次のifに対応するコマンドをelseにすることで、登録が無い処理に該当しなければ登録がある方の処理に流れる。
                        # *** ファイルの中身を表示sedコマンド
                        １、コマンド置換
                        $(…)の中のコマンドを実行して、その結果（出力）を文字列として埋め込む構文。
                        ex)echo “今日は $(date)です”→今日は　Mon Apr 22　です
                        ２、sed -n “${line}p”とは
                        -n：通常の出力を抑制（何も表示しない）
                        “${line}p”：指定した行だけをprint(表示）する
                        ex) sed -n “3p” service_name.txt→service_name.txtの３行目だけを表示する
				#--encryptは「公開鍵暗号方式」：メールアドレスのGPG公開鍵がローカルにインポートされている必要有。
				 --symmetricは「対称鍵方式」：対話式
