#It will Automate the installtion of git
#!/bin/bash

clear_screen()
{
  clear
}

install_req_pkgs()
{
 while read line
 do
    #echo "${line}"
    flag=`yum list installed | grep -w ${line} | wc -l`
    if [ ${flag} -eq 0 ]
    then
      echo "The pkg ${line} is not there with your system so going to install....." 
      yum install ${line}  -y
    fi
 done < required_pkgs.txt
}

download_git_tar_ball()
{
 git_url=`cat  git_url.txt`
 wget ${git_url}
 if [ $? -ne 0 ]
 then
   echo "Something goes wrong check it and try once again"
   exit 1
 fi
}

un_tar_git()
{ 
 tar_zip_name=` cat git_url.txt | awk -F '/' '{ print $8 }'`
 tar -xvzf ${tar_zip_name}
 if [ $? -ne 0 ]
 then
   echo "Something goes wrong check it and try once again"
   exit 2
 fi

}

install_git()
{
 tar_zip_name=` cat git_url.txt | awk -F '/' '{ print $8 }'`
 tar_name=`echo ${tar_zip_name%.*}`
 path=`echo ${tar_name%.*}`
 cd ${path}
 #pwd
 ./configure
 make
 make install
 rm -rf /bin/git
 ln -s /usr/local/bin/git /bin/git
 echo "The lastest git is"
 git --version
}


clear_screen
install_req_pkgs
download_git_tar_ball
un_tar_git
install_git
