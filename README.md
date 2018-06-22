# mysql-install

# 使用方法

* sh mysqlinstall.sh 5.7.22
* sh mysqlinstall.sh 5.7.22 y

# 注意事项
* 安装过程中会判断是否通过yum安装过MySQL,如果有，卸载旧版MySQL
* 默认basedir为/usr/local/mysql+版本号（如/usr/local/mysql5722）。datadir为/data/mysql+版本号（如/data/mysql5722）如果这两个位置存在文件，安装过程中会自动删除
* 默认端口为版本号 如5722
* 服务名称为mysql+版本号 (如mysql5722) 可以使用service mysql5722 stop/start 进行停止和启动
* 如果服务器已存在mysql账号，不会进行任何操作，如果不存在mysql账号，添加mysql账号并将该账号密码修改为：Ha.KGbxrd40
* 数据库root账号的默认密码为Ha.HQngmg55 
* my.cnf位于basedir中，参数根据服务器CPU内存配置自动生成。
* 默认从官方下载安装包，如果服务器无法联网，可以修改脚本中的path，将位置修改为ftp等

以上均可在脚本中进行自定义修改
