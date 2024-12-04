#!/bin/bash

clear

echo "1) Create an account"
echo "2) Log in"
echo "q) Exit"
read -p ">" log

case $log in
	1)
		read -p "Enter a username: " username
		ID="USER${username}${RANDOM}"
		echo "Enter password:"
		read -s password

		touch .${username} 
		echo "${ID}" > .${username} 
		echo "${password}" > .passwords_${username}
		echo "0" > .cash_${username}
		echo "Account created successfully."
		;;
	2)
		read -p "Enter your username: " username
		read -sp "Enter your password: " password
		echo

		if [[ -f ".passwords_${username}" ]]; then
			STOREDPSWD=$(cat .passwords_${username})

			if [[ "$password" == "$STOREDPSWD" ]]; then
				echo "Login successful."
				CASH=$(cat .cash_${username})
				PRICE=$((RANDOM % 100 + 1))
			else
				echo "Invalid credentials, aborting."
				exit 1
			fi
		else
			echo "Username not found."
			exit 1
		fi
		;;
	q)
		clear
		exit 0
		;;
	*)
		echo "[!] Invalid option"
		;;
esac

clear
echo ""
echo ""
echo "░▒▓█▓▒░░▒▓█▓▒░▒▓██████████████▓▒░       ░▒▓███████▓▒░ ░▒▓██████▓▒░░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░"
echo "░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░"
echo " ░▒▓█▓▒▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░"
echo " ░▒▓█▓▒▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░      ░▒▓███████▓▒░░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░"
echo "  ░▒▓█▓▓█▓▒░ ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░"
echo "  ░▒▓█▓▓█▓▒░ ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓██▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░"
echo "   ░▒▓██▓▒░  ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓██▓▒░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░"
echo ""
echo ""
echo "virtual bank"
echo ""
echo "0. see how much money you own"
echo "1. fake deposit"
echo "2. pay"
echo "3. list of payments"
echo "4. refund"
echo "5. list of refunds"
echo "6. withdraw"
echo "h. help"
echo "c. clear"
echo "q. quit"

while true; do
	read -p "[vm.bank] > " cmd
	
	case $cmd in
		0)
			echo "Current cash: $(cat .cash_${username})$"
			;;
		1)
			echo "How much money to deposit?"
			read -p "[money] >" MONEY
			((CASH += $MONEY))
			echo $CASH > .cash_${username}
			echo "Deposited."
			;;
		2)
			echo "Paying for which product?"
			read -p "[product] >" PRODUCT
			echo "Product price: $PRICE"
			read -p "Pay? [y/n] " pay_product_yn

			if [[ "$pay_product_yn" == [Yy] ]]; then
				echo "Paid."
				echo "Paid for ${PRODUCT}, ${PRICE}" >> .payments
				CASH=0 
				echo $CASH > .cash_${username}
			else
				echo "Abort."
			fi
			;;
		3)
			less .payments
			;;
		4)
			echo "Refunding which product?"
			read -p "[product] >" PRODUCT
			echo "Refunded."
			echo "Refunded ${PRODUCT}" >> .refunds
			CASH=100 
			echo $CASH > .cash_${username}
			;;
		5)
			less .refunds
			;;
		6)
			read -p "How much to withdraw?" withdraw
			((CASH -= ${withdraw}))
			echo $CASH > .cash_${username}
			echo "Withdrawn."
			;;
		h)
			echo "0. see how much money you own"
			echo "1. fake deposit"
			echo "2. pay"
			echo "3. list of payments"
			echo "4. refund"
			echo "5. list of refunds"
			echo "6. withdraw"
			echo "h. help"
			echo "c. clear"
			echo "q. quit"
			;;
		c)
			clear
			;;
		q)
			clear
			exit 0
			;;
		*)
			echo "vmbank: ${cmd} is not a valid command"
			echo "[i] Maybe type 'h' for help?"
			;;
	esac
done
