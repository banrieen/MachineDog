# Global config remote repo and target repo list
remote_tag=v1.1.0-rc0
remote_origin=git@apulis-gitlab.apulis.cn:sdk/go-utils.git
targe_branch=v1.6.0
gitee_origin=git@gitee.com:apulisplatform/go-utils.git
# Assert if used tag not branch
Tag=false 
cd ..
git clone -b $remote_tag $remote_origin
local_dir_git=${remote_origin##*/}
local_dir=${local_dir_git%.git}
cd $local_dir
git branch  $targe_branch
if ($Tag == true);then
git switch -c $targe_branch
else
git checkout $targe_branch
fi
git merge $remote_tag    
# Add Account 
git config --global user.name "banrieen"
git config --global user.email "haiyuan.bian@apulis.com"
git remote add gitee $gitee_origin
# Add MIT LICENSE
rm LICENSE.*
cp ../LICENSE .
git add LICENSE
git commit -m "add license"
# Push to gitee
git push -u gitee $targe_branch

