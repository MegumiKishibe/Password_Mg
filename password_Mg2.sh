#!/bin/bash
	echo "パスワードマネージャーへようこそ！"
	while true
	do
	echo "次の選択肢から入力してください(Add Password/Get Password/Exit)"
	read personal_info

		if [ "$personal_info" == "Add Password" ]; then 
			echo "サービス名を入力してください："
			read sevicename
			echo "$service_name" >> service_name.txt
 
			echo "ユーザー名を入力してください："
			read username
			echo "$username" >> user_name.txt

			echo "パスワードを入力してください："
			read password
			echo "$password" >> pass_word.txt

			echo "パスワードの追加は成功しました。

		elif [ "$personal_info" == "Get Password"]; then
			echo "サービス名を入力してください："
			read service_name

			find ./ -type f -name 'service_name.txt' | xargs grep -n "${service_name}"
		
			if [ "${servicce_name}" !=  ]
			echo "そのサービス名は登録されていません。"

			elif [ service_name == "${service_name}" ] 
			echo "サービス名：./servise_name.txt"
			echo "ユーザー名：./user_name.txt"
			echo "パスワード：./pass_word.txt"
			fi
        	
		elif [ "$personal_info" == "Exit" ]; then
			echo "Thank you!"
			exit 0

		else 
			echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
		fi
	done
