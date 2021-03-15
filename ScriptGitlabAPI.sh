export LANG=C.UTF-8
Menu()
{
    # Khai bao bien mau cho text
    Gre='\e[0;32m';
    UGre='\e[4;32m';
    Whi='\e[0;37m'; 
    NOCOLOR="\033[0m"
    clear
    echo -e "${Gre}"
	now="$(date +'%d/%m/%Y')"
    echo "Current date: " "$now"
	echo "~~~~~~~~~~~~~~~~~~~~~"	
	echo " M A I N - M E N U"
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Create Project and Add Project to Group"
	echo "2. Add Member to Group"
	echo "3. Remove member to Group"
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
            echo "Nhập UrlGitlab (ex: https://example.com):"
            read urlProject
            echo "Nhập token:"
            read token
            echo "Nhập projectName:"
            read projectName
            echo "Nhập projectDescription:"
            read projectDescription
            echo "Nhập groupName:"
            read groupName
            # Goi ham AssigneProjectToGroup voi cac tham so truyen vao
            AssigneProjectToGroup $urlProject $token $projectName $projectDescription $groupName
            #break
			echo -e "Press enter key to continues...."
            ;;
            2)
		    clear
			echo -e "** Thêm thanh viên vào group và cấp quyền cho member **"
            echo "Nhập UrlGitlab (ex: https://example.com):"
            read urlGitlab
            echo "Nhập Token:"
            read token
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
			3)
		    clear
			echo -e "** Xoá thành viên trong Group **"
            echo "Nhập UrlGitlab (ex: https://example.com):"
            read urlGitlab
            echo "Nhập Token:"
            read token
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
            echo "Nhập UrlGitlab (ex: https://example.com):"
			 read urlGitlab
			 echo "Nhập token:"
			 read token
			 echo "Nhập projectName:"
			 read projectName
			 RemovememberforGroup $urlGitlab $token $projectName
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

##########Thêm Project và đẩy project vào Group
AssigneProjectToGroup (){
# Các biến truyền vào $urlProject,$token,$projectName,$projectDescription,$groupName
# Tạo project 
curl --insecure --header "PRIVATE-TOKEN: $2" -X POST "$1/api/v4/projects?name=$3&description=$4"
#Lấy Id Group theo groupName
group=$(curl --insecure --header "PRIVATE-TOKEN: $2" "$1//api/v4/groups?search=$5")
groupId=$(echo $(echo $group | cut -d':' -f 2) | cut -d',' -f 1)
#echo $groupId
# Lấy Id Project theo project
project=$(curl --insecure --header "PRIVATE-TOKEN: $2" "$1//api/v4/search?scope=projects&search=$3")
projectId=$(echo $(echo $project | cut -d':' -f 2) | cut -d',' -f 1)
#echo $projectId
# Gán Project cho Group theo projectId và và groupId
curl --insecure --request POST --header "PRIVATE-TOKEN: $2" "$1/api/v4/groups/$groupId/projects/$projectId"
}

##########Thêm thành viên cho Group và cấp quyên cho thành viên
AddmemberforGroups (){
# Các biến truyền vào $urlGitlab,$token,$groupName,$userName,$role
# Hiển thị userId theo Username
user=$(curl --insecure --header "PRIVATE-TOKEN: $2" "$1//api/v4/search?scope=users&search=$4")
userId=$(echo $(echo $user | cut -d':' -f 2) | cut -d',' -f 1)
#echo $userId
#Hiển thị GroupID theo GroupName
group=$(curl --insecure --header "PRIVATE-TOKEN: $2" "$1//api/v4/groups?search=$3")
groupId=$(echo $(echo $group | cut -d':' -f 2) | cut -d',' -f 1)
#echo $groupId
#Thêm member vào group theo UserId và GroupId
curl --insecure --request POST --header "PRIVATE-TOKEN: $2" --data "user_id=$userId&access_level=$5" "$1/api/v4/groups/$groupId/members"
}
##########Xoá 1 thành viên khỏi Group
RemovememberforGroup(){
# Các biến truyền vào $urlGitlab,$token,$groupName,$userName
# Hiển thị userId theo Username
user=$(curl --insecure --header "PRIVATE-TOKEN: $2" "$1//api/v4/search?scope=users&search=$4")
userId=$(echo $(echo $user | cut -d':' -f 2) | cut -d',' -f 1)
#echo $userId
#Hiển thị GroupID theo GroupName
group=$(curl --insecure --header "PRIVATE-TOKEN: $2" "$1//api/v4/groups?search=$3")
groupId=$(echo $(echo $group | cut -d':' -f 2) | cut -d',' -f 1)
#echo $groupId
#Xoá member trong group theo UserId và GroupId
curl --insecure --request DELETE  --header "PRIVATE-TOKEN: $2" "$1//api/v4/groups/$groupId/members/$userId"
}

##########Xoá Project
RemoveProject(){
# Các biến truyền vào $urlGitlab $token $projectName
# Lấy Id Project theo project
project=$(curl --insecure --header "PRIVATE-TOKEN: $2" "$1//api/v4/search?scope=projects&search=$3")
projectId=$(echo $(echo $project | cut -d':' -f 2) | cut -d',' -f 1)
#echo $projectId

curl --insecure --request DELETE  --header "PRIVATE-TOKEN: $2" "$1//api/v4/projects/$projectId"
}

# Goi Ham Menu
 Menu