export LANG=C.UTF-8
Menu()
{
    # Khai bao bien mau cho text
    Gre='\e[0;32m';
    UGre='\e[4;32m';
    Whi='\e[0;37m'; 
    NOCOLOR="\033[0m"
    echo -e "${Gre}"
	echo "~~~~~~~~~~~~~~~~~~~~~"	
	echo " M A I N - M E N U"
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Git pull/push"
	echo "5. Exit"
    while true; do
        read option
        case $option in		
			5)
            break;
            ;;
            1)
			echo "1. Git pull"
			echo "2. Git push"
			echo "3. Exit"
			while true; do
			read option4
			case $option4 in
			3)
			break;
			;;
			1)
				clear
				echo -e "Git pull"
				echo "Nhập UrlGitlab (ex: https://example.com):"
				read urlProject
				echo "Nhập token:"
				read token
				echo "Nhập projectName:"
				read projectName
				echo "Nhập tên folder:"
				read folder
				echo "Nhập tên remote:"
				read remoteName
				gitfull  $urlProject $token $projectName $folder $remoteName
				#break;
				;;
			2)
				clear
				echo "Nhập tên folder:"
				read folder
				echo "Nhập tên:"
				read token
				echo "Nhập projectName:"
				read projectName
				echo "Nhập tên folder:"
				#break;
                ;;
			 esac
			done
			;;
			*)
              Menu
            ;;
        esac
    done
}
gitfull(){
# Các biến truyền vào $urlProject $token $projectName $folder $remoteName
mkdir $4
cd $4
git init
# Lấy Id Project theo project
projectinName=$(curl --insecure --header "PRIVATE-TOKEN: $2" "$1//api/v4/search?scope=projects&search=$3")
projectId=$(echo $(echo $projectinName | cut -d':' -f 2) | cut -d',' -f 1)
# Lấy urlProject theo projectId
projectinId=$(curl --insecure --header "PRIVATE-TOKEN: $2" "$1//api/v4/projects/$projectId")
urlProject=$(echo $(echo $(echo $projectinId | cut -d':' -f 15,16) | cut -d',' -f 1) | cut -d '"' -f 2)
echo $urlProject
git remote add $5 $urlProject
#git checkout -b $4
git pull $urlProject
}


Menu