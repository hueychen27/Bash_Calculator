#!/bin/bash
red='\033[0;31m'
blue='\033[34m'
nc='\033[0m'
numCheck() {
	re='^[0-9]+$'
	if ! [[ $1 =~ $re ]]; then
		echo -e "${red}Not valid. Exiting...${nc}" >&2
		exit 1
	else
		return 0
	fi
}
decCheck() {
	re='^[-]?[0-9]+([.][0-9]+)?$'
	if ! [[ $1 =~ $re ]]; then
		echo -e "${red}Not valid. Exiting...${nc}" >&2
		exit 1
	else
		return 0
	fi

}
scale() {
	read -r -p "Choose the scale (decimal precision) number bc will use: " scale
	numCheck $scale
	if ! [[ $scale -ge 1 ]]; then
		echo -e "${red}Not valid. Exiting...${nc}" >&2
		exit 1
	fi
}
echo "Checking if pi is installed..."
if ! command -v pi &>/dev/null; then
	echo "Please install pi using your package manager."
	exit 1
fi
echo "Checking if bc is installed..."
if ! command -v bc &>/dev/null; then
	echo "Please install bc using your package manager."
	exit 1
fi
scale
echo -e "-----------------${blue}Bash Calculator${nc}-----------------"
echo -e "|                                               |"
echo -e "|                   Controls                    |"
echo -e "|       1) Add                                  |"
echo -e "|       2) Subtract                             |"
echo -e "|       3) Multiply                             |"
echo -e "|       4) Divide                               |"
echo -e "|       5) Exponents                            |"
echo -e "|       6) Nth Root                             |"
echo -e "|       7) Log Base x                           |"
echo -e "|       8) Trigonometry Functions               |"
echo -e "|       9) Print x Digits of Pi                 |"
echo -e "|       10) x Modulo y                          |"
echo -e "|       11) Quit                                |"
echo -e "|       12) Change Scale                        |"
echo -e "|                                               |"
echo -e "|_______________________________________________|"
while :; do
	read -r -p "Enter operation between 1 and 12: " operation
	numCheck $operation
	if ! [[ $operation -ge 1 && $operation -le 12 ]]; then
		echo -e "${red}Not valid. Exiting...${nc}" >&2
		exit 1
	fi
	case $operation in
	1)
		read -r -p "Enter first number: " first
		decCheck $first
		read -r -p "Enter second number: " second
		decCheck $second
		answer=$(echo "scale=$scale; $first+$second" | bc -l)
		echo -e "$first plus $second equals $answer"
		;;
	2)
		read -r -p "Enter first number: " first
		decCheck $first
		read -r -p "Enter second number: " second
		decCheck $second
		answer=$(echo "scale=$scale; $first-$second" | bc -l)
		echo -e "$first minus $second equals $answer"
		;;
	3)
		read -r -p "Enter first number: " first
		decCheck $first
		read -r -p "Enter second number: " second
		decCheck $second
		answer=$(echo "$scale=$scale; first*$second" | bc -l)
		echo -e "$first multiplied by $second equals $answer"
		;;
	4)
		read -r -p "Enter first number: " first
		decCheck $first
		read -r -p "Enter second number: " second
		decCheck $second
		answer=$(echo "scale=$scale; $first/$second" | bc -l)
		echo -e "$first divided by $second equals $answer"
		;;
	5)
		read -r -p "Enter the base number: " first
		decCheck $first
		read -r -p "Enter the power number: " second
		decCheck $second
		answer=$(echo "scale=$scale; $first^$second" | bc -l)
		echo -e "$first to the power of $second equals $answer"
		;;
	6)
		read -r -p "Enter the radicand number: " first
		decCheck $first
		read -r -p "Enter the index number: " second
		decCheck $second
		root=$(echo "scale=$scale; e( l($first)/$second )" | bc -l)
		echo -e "The ${second}th root of $first equals $root"
		;;
	7)
		read -r -p "Enter the argument number: " first
		decCheck $first
		read -r -p "Enter the base number: " second
		decCheck $second
		answer=$(echo "scale=$scale; l($first)/l($second)" | bc -l)
		echo -e "Log base $second of $first equals $answer"
		;;
	8)
		echo -e "Trigonometry Function:"
		echo -e "1) Sine of x"
		echo -e "2) Cosine of x"
		echo -e "3) Arctangent of x"
		read -r -p "Enter operation between 1 and 3: " operation
		numCheck $operation
		if ! [[ $operation -ge 1 && $operation -le 3 ]]; then
			echo -e "${red}Not valid. Exiting...${nc}" >&2
			exit 1
		fi
		case $operation in
		1)
			read -r -p "Enter number: " number
			decCheck $number
			answer=$(echo "scale=$scale; s($number)" | bc -l)
			echo -e "The sine of $number equals $answer"
			;;
		2)
			read -r -p "Enter number: " number
			decCheck $number
			answer=$(echo "scale=$scale; c($number)" | bc -l)
			echo -e "The cosine of $number equals $answer"
			;;
		3)
			read -r -p "Enter number: " number
			decCheck $number
			answer=$(echo "scale=$scale; a($number)" | bc -l)
			echo -e "The arctangent of $number equals $answer"
			;;
		esac
		;;
	9)
		read -r -p "Enter number greater than 0: " number
		numCheck $number
		if ! [[ $number -ge 0 ]]; then
			echo -e "${red}Not valid. Exiting...${nc}" >&2
			exit 1
		fi
		answer=$(pi $number)
		echo -e "$answer"
		;;
	11)
		echo -e "${red}Quitting...${nc} See ya next time."
		exit 0
		;;
	12)
		scale
		;;
	esac
done
