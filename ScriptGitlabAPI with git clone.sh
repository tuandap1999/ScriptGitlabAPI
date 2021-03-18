export LANG=C.UTF-8

funcInput(){
            echo "Nhập UrlGitlab (ex: https:/git.example.com):"
            read urlGitlab
            echo "Nhập token:"
            read token
}

Menu()
{
    # Khai bao bien mau cho text
    Gre='\e[0;32m';
    UGre='\e[4;32m';
    Whi='\e[0;37m'; 
    NOCOLOR="\033[0m"
	clear
    echo -e "${Gre}"
	Datenow="$(date +'%d/%m/%Y')"
	User="$(whoami)"
    echo "$Datenow" "----------" "$User"
	echo "~~~~~~~~~~~~~~~~~~~~~"	
	echo " M A I N - M E N U"
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Create Project and Add Project for Group"
	echo "2. Git clone/push"
	echo "3. Add Member in Group"
	echo "4. Remove member to Group"
	echo "0. Remove Project"
	echo "5. Exit"
    while true; do
        read option
        case $option in		
			5)
            break;
            ;;
            1)
			clear
			echo -e "** Tạo project và thêm project vào group **"
			funcInput
		    echo "Nhập projectName:"
            read projectName
            echo "Nhập projectDescription:"
            read projectDescription
            echo "Nhập groupName:"
            read groupName
            # Goi ham AssigneProjectToGroup voi cac tham so truyen vao
            AssigneProjectToGroup $urlGitlab $token $projectName $projectDescription $groupName
            #break
			echo -e "Press enter key to continues...."
            ;;
			2)
			MenuG(){
			clear
			echo "1. Git pull"
			echo "2. Git push"
			echo "3. Exit"
			while true; do
			read option2
			case $option2 in
			3)
			Menu
			;;
			1)
				clear
				echo -e "Git pull"
				funcInput
				echo "Nhập projectName:"
				read projectName
				echo "Nhập tên remote(if add new remote 'Default: origin'):"
				read remoteName
				gitclone  $urlGitlab $token $projectName $remoteName
				echo -e "Press enter key to continues...."
				#break;
				;;
			2)
				clear
				echo -e "Git push"
				echo "Nhập projectName:"
				read projectName
				echo "Nhập tên branch:"
				read branchName
				echo "Nhập commit:"
				read commit
				gitpush $projectName $branchName $commit
				echo -e "Press enter key to continues...."
				#break;
			;;
			*)
              MenuG
            ;;
				esac
			done
			}
			MenuG
			;;
            3)
		    clear
			echo -e "** Thêm thanh viên vào group và cấp quyền cho member **"
            funcInput
			echo "Nhập Username:"
            read userName
			echo "Nhập quyền/permission (0, 10, 20, 30, 40, 50):"
            read role
			echo "Nhập GroupName:"
            read groupName
			# Goi ham AddmemberforGroups voi cac tham so truyen vao
            AddmemberforGroups $urlGitlab $token $groupName $userName $role
            #break
			echo -e "Press enter key to continues...."
            ;;
			4)
		    clear
			echo -e "** Xoá thành viên trong Group **"
            funcInput
			echo "Nhập Username:"
            read userName
			echo "Nhập GroupName:"
            read groupName
			# Goi ham RemovememberforGroup voi cac tham so truyen vao
            RemovememberforGroup $urlGitlab $token $groupName $userName
			#break
			echo -e "Press enter key to continues...."
			;;
			0)
		    clear
			echo "Nhập password: "
			read pass
			if [ $pass == "dev123" ]
			then
			 echo -e "** Xoá Project **"
             funcInput
			 echo "Nhập projectName:"
			 read projectName
			 RemoveProject $urlGitlab $token $projectName
			else
			 echo -e "Password invalid"
			fi		
			echo -e "Press enter key to continues...."	
			;;
			*)
              Menu
            ;;
        esac
    done
}

functionTest(){
	#Lấy Id Group theo groupName
	group=$(curl --insecure --header "PRIVATE-TOKEN: $token" "$urlGitlab/api/v4/groups?search=$groupName")
	groupId=$(echo $(echo $group | cut -d':' -f 2) | cut -d',' -f 1)
	# Lấy Id Project theo projectName
	project=$(curl --insecure --header "PRIVATE-TOKEN: $token" "$urlGitlab/api/v4/search?scope=projects&search=$projectName")
	projectId=$(echo $(echo $project | cut -d':' -f 2) | cut -d',' -f 1)
	# Hiển thị userId theo Username
	user=$(curl --insecure --header "PRIVATE-TOKEN: $token" "$urlGitlab/api/v4/search?scope=users&search=$userName")
	userId=$(echo $(echo $user | cut -d':' -f 2) | cut -d',' -f 1)
	# Lấy $urlProject theo projectId
	projectinId=$(curl --insecure --header "PRIVATE-TOKEN: $token" "$urlGitlab/api/v4/projects/$projectId")
	urlProjectbyid=$(echo $(echo $(echo $projectinId | cut -d':' -f 15,16) | cut -d',' -f 1) | cut -d '"' -f 2)
}

##########Thêm Project và đẩy project vào Group
AssigneProjectToGroup (){
# Các biến truyền vào $urlGitlab,$token,$projectName,$projectDescription,$groupName
# Tạo project 
curl --insecure --header "PRIVATE-TOKEN: $2" -X POST "$1/api/v4/projects?name=$3&description=$4"
functionTest
# Gán Project cho Group theo projectId và và groupId
curl --insecure --request POST --header "PRIVATE-TOKEN: $2" "$1/api/v4/groups/$groupId/projects/$projectId"
#In ra thông tin chung
echo -e "URL: $1\r\nToken: $2\r\nProjectName: $3\r\nGroupName: $5\r\n" >> test.txt
rm -f Infomation.txt
awk '!seen[$0]++' test.txt >> Infomation.txt
rm -f test.txt
}

##########Thêm thành viên cho Group và cấp quyên cho thành viên
AddmemberforGroups (){
# Các biến truyền vào $urlGitlab,$token,$groupName,$userName,$role
functionTest
#Thêm member vào group theo UserId và GroupId
curl --insecure --request POST --header "PRIVATE-TOKEN: $2" --data "user_id=$userId&access_level=$5" "$1/api/v4/groups/$groupId/members"
#In ra thông tin chung
echo -e "URL: $1\r\nToken: $2\r\nProjectName: $3\r\nGroupName: $5\r\n\r\nUsername: $4\r\nAccessToken: $5\r\n\r\n" >> test.txt
#rm -f test.txt
rm -f Infomation.txt
awk '!seen[$0]++' test.txt >> Infomation.txt
rm -f test.txt
}

##########Xoá 1 thành viên khỏi Group
RemovememberforGroup(){
# Các biến truyền vào $urlGitlab,$token,$groupName,$userName
functionTest
#Xoá member trong group theo UserId và GroupId
curl --insecure --request DELETE  --header "PRIVATE-TOKEN: $2" "$1/api/v4/groups/$groupId/members/$userId"
}

##########Xoá Project
RemoveProject(){
# Các biến truyền vào $urlGitlab $token $projectName
functionTest
curl --insecure --request DELETE  --header "PRIVATE-TOKEN: $2" "$1/api/v4/projects/$projectId"
}

gitclone(){
# Các biến truyền vào $urlGitlab $token $projectName $folder $remoteName
functionTest
#git checkout -b $4
git clone $urlGitlab
cd $3
git remote add $4 $urlGitlab
}

gitpush(){
# Các biến truyền vào $projectName $branchName $commit 
##mkdir $1
cd $1
git checkout -b $2
git add .
git commit -m "$3"
remotev=$(git remote)
#echo $remotev
git push --set-upstream  $remotev $2
}

# Goi Ham Menu
Menu