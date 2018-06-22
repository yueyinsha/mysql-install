#!/bin/sh

Get57cnf()
{
if test $[cpu*8] -lt 256;then thread_cache_size=256;else thread_cache_size=[cpu*8];fi
slave_parallel_workers=$[cpu*2]
innodb_buffer_pool_size=$[mem*6/10/128/1024*128*1024*1024]
if test $[mem*6/10/1024/1024] -lt 64;then instances=$[mem*6/10/1024/1024];else instances=64;fi
innodb_buffer_pool_instances=$instances
server_id=$RANDOM
port=${suffix}
socket=/tmp/mysql${suffix}.sock

cat>${temppath}/my.cnf<<EOF
[mysql]
auto-rehash
[mysqld]
#### for global
user                                =mysql                          
basedir                             =${basedir}             
datadir                             =${datadir}      
server_id                           =${server_id}                            
port                                =${port}                          
character_set_server                =utf8                           
log_bin_trust_function_creators     =on                             
explicit_defaults_for_timestamp     =off                            
log_timestamps                      =system                         
socket                              =${socket}            
read_only                           =0                              
skip_name_resolve                   =1                              
auto_increment_increment            =1                              
auto_increment_offset               =1                              
lower_case_table_names              =1                              
secure_file_priv                    =                               
open_files_limit                    =65536                          
max_connections                     =2000                            
thread_cache_size                   =${thread_cache_size}  
table_open_cache                    =4096                           
table_definition_cache              =2000                           
table_open_cache_instances          =32                             

#### for binlog
binlog_format                       =row                          
log_bin                             =mysql-bin 
log_bin_index                       =mysql-bin.index
binlog_rows_query_log_events        =on                             
log_slave_updates                   =on                             
expire_logs_days                    =7                              
binlog_cache_size                   =65536                          
binlog_checksum                     =none                           
sync_binlog                         =1                              
slave-preserve-commit-order         =ON                             

#### for error-log
log_error                           =err.log                        

general_log                         =off                            
general_log_file                    =general.log                    

#### for slow query log
slow_query_log                      =on                             
slow_query_log_file                 =slow.log                       
log_queries_not_using_indexes       =on                             
long_query_time                     =10.000000                       


#### for replication
skip_slave_start                    =0   
relay_log                           =relay-log
relay_log_index                     =relay-log.index
master_info_repository              =table                         
relay_log_info_repository           =table                         
slave_parallel_type                 =logical_clock                 
slave_parallel_workers              =${slave_parallel_workers}   
####: for innodb
default_storage_engine                          =innodb                     
default_tmp_storage_engine                      =innodb                     
innodb_data_file_path                           =ibdata1:64M:autoextend     
innodb_temp_data_file_path                      =ibtmp1:12M:autoextend      
innodb_buffer_pool_filename                     =ib_buffer_pool             
innodb_log_group_home_dir                       =./                         
innodb_log_files_in_group                       =2                         
innodb_log_file_size                            =50331648                    
innodb_file_per_table                           =on                         
innodb_online_alter_log_max_size                =128M                  
innodb_open_files                               =2000                       
innodb_page_size                                =16k                        
innodb_thread_concurrency                       =0                          
innodb_read_io_threads                          =4                          
innodb_write_io_threads                         =4                          
innodb_purge_threads                            =4                          
innodb_page_cleaners                            =4                          
innodb_print_all_deadlocks                      =on                         
EOF

if $(version:4:6) -ge 15
then
	cat>>${temppath}/my.cnf<<EOF
innodb_deadlock_detect                          =on 
EOF
fi

cat>>${temppath}/my.cnf<<EOF
innodb_lock_wait_timeout                        =50                         
innodb_spin_wait_delay                          =6                          
innodb_autoinc_lock_mode                        =2                          
innodb_io_capacity                              =200                        
innodb_io_capacity_max                          =2000                       


innodb_stats_auto_recalc                        =on                         
innodb_stats_persistent                         =on                         
innodb_stats_persistent_sample_pages            =20                         
innodb_adaptive_hash_index                      =on                         
innodb_change_buffering                         =all                        
innodb_change_buffer_max_size                   =25                         
innodb_flush_neighbors                          =1                          
innodb_doublewrite                              =on                         
innodb_flush_log_at_timeout                     =1                          
innodb_flush_log_at_trx_commit                  =1                          
    
innodb_buffer_pool_size                         =${innodb_buffer_pool_size}
innodb_buffer_pool_instances                    =${innodb_buffer_pool_instances}

autocommit                                      =1                          

innodb_old_blocks_pct                           =37                         
innodb_old_blocks_time                          =1000                       

innodb_read_ahead_threshold                     =56                         
innodb_random_read_ahead                        =OFF                        

innodb_buffer_pool_dump_pct                     =25                         
innodb_buffer_pool_dump_at_shutdown             =ON                         
innodb_buffer_pool_load_at_startup              =ON                         


####  for performance_schema
performance_schema                                                      =on    
performance_schema_consumer_global_instrumentation                      =on    
performance_schema_consumer_thread_instrumentation                      =on    
performance_schema_consumer_events_stages_current                       =on    
performance_schema_consumer_events_stages_history                       =on    
performance_schema_consumer_events_stages_history_long                  =off   
performance_schema_consumer_statements_digest                           =on    
performance_schema_consumer_events_statements_current                   =on    
performance_schema_consumer_events_statements_history                   =on    
performance_schema_consumer_events_statements_history_long              =off   
performance_schema_consumer_events_waits_current                        =on    
performance_schema_consumer_events_waits_history                        =on    
performance_schema_consumer_events_waits_history_long                   =off   
performance-schema-instrument ='memory/%=COUNTED'

EOF
}

Get56cnf(){
slave_parallel_workers=$[cpu*2]
innodb_buffer_pool_size=$[mem*6/10/128/1024*128*1024*1024]
if test $[mem*6/10/1024/1024] -lt 64;then instances=$[mem*6/10/1024/1024];else instances=64;fi
innodb_buffer_pool_instances=$instances
server_id=$RANDOM
port=${suffix}
socket=/tmp/mysql${suffix}.sock
if test $[cpu*8] -lt 256;then thread_cache_size=256;else thread_cache_size=[cpu*8];fi

cat>${temppath}/my.cnf<<EOF
[mysql]
auto-rehash
[mysqld]
#### for global
user                                =mysql                          
basedir                             =${basedir}             
datadir                             =${datadir}      
server_id                           =${server_id}                            
port                                =${port}                          
character_set_server                =utf8                           
log_bin_trust_function_creators     =on                             
explicit_defaults_for_timestamp     =off                                                    
socket                              =${socket}            
read_only                           =0                              
skip_name_resolve                   =1                              
auto_increment_increment            =1                              
auto_increment_offset               =1                              
lower_case_table_names              =1                              
secure_file_priv                    =                               
open_files_limit                    =65536                          
max_connections                     =2000                            
thread_cache_size                   =${thread_cache_size}  
table_open_cache                    =4096                           
table_definition_cache              =2000                           
table_open_cache_instances          =32                             

#### for binlog
binlog_format                       =row                          
log_bin                             =mysql-bin 
log_bin_index                       =mysql-bin.index
binlog_rows_query_log_events        =on                             
log_slave_updates                   =on                             
expire_logs_days                    =7                              
binlog_cache_size                   =65536                          
binlog_checksum                     =none                           
sync_binlog                         =1                                                       

#### for error-log
log_error                           =err.log                        

general_log                         =off                            
general_log_file                    =general.log                    

#### for slow query log
slow_query_log                      =on                             
slow_query_log_file                 =slow.log                       
log_queries_not_using_indexes       =on                             
long_query_time                     =10.000000                       


#### for replication
skip_slave_start                    =0   
relay_log                           =relay-log
relay_log_index                     =relay-log.index
master_info_repository              =table                         
relay_log_info_repository           =table                                     
slave_parallel_workers              =${slave_parallel_workers}   
####: for innodb
default_storage_engine                          =innodb                     
default_tmp_storage_engine                      =innodb                     
innodb_data_file_path                           =ibdata1:64M:autoextend          
innodb_buffer_pool_filename                     =ib_buffer_pool             
innodb_log_group_home_dir                       =./                         
innodb_log_files_in_group                       =2                         
innodb_log_file_size                            =50331648                       
innodb_file_per_table                           =on                         
innodb_online_alter_log_max_size                =128M                  
innodb_open_files                               =2000                       
innodb_page_size                                =16k                        
innodb_thread_concurrency                       =0                          
innodb_read_io_threads                          =4                          
innodb_write_io_threads                         =4                          
innodb_purge_threads                            =4                                          
innodb_print_all_deadlocks                      =on                                                 
innodb_lock_wait_timeout                        =50                         
innodb_spin_wait_delay                          =6                          
innodb_autoinc_lock_mode                        =2                          
innodb_io_capacity                              =200                        
innodb_io_capacity_max                          =2000                       


innodb_stats_auto_recalc                        =on                         
innodb_stats_persistent                         =on                         
innodb_stats_persistent_sample_pages            =20                         
innodb_adaptive_hash_index                      =on                         
innodb_change_buffering                         =all                        
innodb_change_buffer_max_size                   =25                         
innodb_flush_neighbors                          =1                          
innodb_doublewrite                              =on                         
innodb_flush_log_at_timeout                     =1                          
innodb_flush_log_at_trx_commit                  =1                          
    
innodb_buffer_pool_size                         =${innodb_buffer_pool_size}
innodb_buffer_pool_instances                    =${innodb_buffer_pool_instances}

autocommit                                      =1                          

innodb_old_blocks_pct                           =37                         
innodb_old_blocks_time                          =1000                       

innodb_read_ahead_threshold                     =56                         
innodb_random_read_ahead                        =OFF                        
                       
innodb_buffer_pool_dump_at_shutdown             =ON                         
innodb_buffer_pool_load_at_startup              =ON                         


####  for performance_schema
performance_schema                                                      =on    
performance_schema_consumer_global_instrumentation                      =on    
performance_schema_consumer_thread_instrumentation                      =on    
performance_schema_consumer_events_stages_current                       =on    
performance_schema_consumer_events_stages_history                       =on    
performance_schema_consumer_events_stages_history_long                  =off   
performance_schema_consumer_statements_digest                           =on    
performance_schema_consumer_events_statements_current                   =on    
performance_schema_consumer_events_statements_history                   =on    
performance_schema_consumer_events_statements_history_long              =off   
performance_schema_consumer_events_waits_current                        =on    
performance_schema_consumer_events_waits_history                        =on    
performance_schema_consumer_events_waits_history_long                   =off   
performance-schema-instrument ='memory/%=COUNTED'

EOF
}

Get80cnf(){

if test $[cpu*4] -lt 32;then slave_parallel_workers=$[cpu*4] ;else slave_parallel_workers=32;fi
innodb_buffer_pool_size=$[mem*6/10/128/1024*128*1024*1024]
if test $[mem*6/10/1024/1024] -lt 64;then instances=$[mem*6/10/1024/1024];else instances=64;fi
innodb_buffer_pool_instances=$instances
server_id=$RANDOM
port=${suffix}
socket=/tmp/mysql${suffix}.sock

cat>${temppath}/my.cnf<<EOF
[mysql]

auto-rehash
[mysqld]
###: for global
user                                =mysql                          
basedir                             =${basedir}              
datadir                             =${datadir}     
server_id                           =${server_id}                           
port                                =${port}                         
character_set_server                =utf8                           
log_bin_trust_function_creators     =on                             
log_timestamps                      =system                         
socket                              =${socket}                
read_only                           =0                              
skip_name_resolve                   =1                              
auto_increment_increment            =1                              
auto_increment_offset               =1                              
lower_case_table_names              =1                              
secure_file_priv                    =                               
open_files_limit                    =65536                          
max_connections                     =2000                            
thread_cache_size                   =128                              
table_open_cache                    =4096                           
table_definition_cache              =2000                           
table_open_cache_instances          =32                             
###: for binlog
binlog_format                       =row                            
log_bin                             =mysql-bin                      
log_bin_index                       =mysql-bin.index
binlog_rows_query_log_events        =on                             
log_slave_updates                   =on                             
binlog_expire_logs_seconds          =604800                         
binlog_cache_size                   =64k                          
binlog_checksum                     =none                           
sync_binlog                         =1                              
slave_preserve_commit_order         =ON                             
###: for error-log
log_error                           =err.log                        
general_log                         =off                            
general_log_file                    =general.log                    
###: for slow query log
slow_query_log                      =on                             
slow_query_log_file                 =slow.log                       
log_queries_not_using_indexes       =off                            
long_query_time                     =2.000000                       
###: for gtid
gtid_executed_compression_period    =1000                          
gtid_mode                           =on                            
enforce_gtid_consistency            =on                            
###: for replication
skip_slave_start                    =0                              
master_info_repository              =table                         
relay_log_info_repository           =table                         
slave_parallel_type                 =logical_clock                 
slave_parallel_workers              =${slave_parallel_workers}                             
rpl_semi_sync_master_enabled        =1                             
rpl_semi_sync_slave_enabled         =1                             
rpl_semi_sync_master_timeout        =1000                          
plugin_load_add                     =semisync_master.so            
plugin_load_add                     =semisync_slave.so             
binlog_group_commit_sync_delay      =0                             
binlog_group_commit_sync_no_delay_count =0                         
###: for innodb
default_storage_engine                          =innodb                     
default_tmp_storage_engine                      =innodb                     
innodb_data_file_path                           =ibdata1:64M:autoextend     
innodb_temp_data_file_path                      =ibtmp1:12M:autoextend      
innodb_buffer_pool_filename                     =ib_buffer_pool             
innodb_log_group_home_dir                       =./                         
innodb_log_files_in_group                       =8                         
innodb_log_file_size                            =134217728                       
innodb_file_per_table                           =on                         
innodb_online_alter_log_max_size                =134217728                       
innodb_open_files                               =65535                      
innodb_page_size                                =16k                        
innodb_thread_concurrency                       =0                          
innodb_read_io_threads                          =4                          
innodb_write_io_threads                         =4                          
innodb_purge_threads                            =4                          
innodb_page_cleaners                            =4                          
innodb_print_all_deadlocks                      =on                         
innodb_deadlock_detect                          =on                         
innodb_lock_wait_timeout                        =50                         
innodb_spin_wait_delay                          =6                          
innodb_autoinc_lock_mode                        =2                          
innodb_io_capacity                              =200                        
innodb_io_capacity_max                          =2000                       
innodb_stats_auto_recalc                        =on                         
innodb_stats_persistent                         =on                         
innodb_stats_persistent_sample_pages            =20                         
innodb_buffer_pool_instances                    =${innodb_buffer_pool_instances}
innodb_adaptive_hash_index                      =on                         
innodb_change_buffering                         =all                        
innodb_change_buffer_max_size                   =25                         
innodb_flush_neighbors                          =1                          
innodb_doublewrite                              =on                         
innodb_log_buffer_size                          =67108864                        
innodb_flush_log_at_timeout                     =1                          
innodb_flush_log_at_trx_commit                  =1                          
innodb_buffer_pool_size                         =${innodb_buffer_pool_size}                  
autocommit                                      =1                          
innodb_old_blocks_pct                           =37                         
innodb_old_blocks_time                          =1000                       
innodb_read_ahead_threshold                     =56                         
innodb_random_read_ahead                        =OFF                        
innodb_buffer_pool_dump_pct                     =25                         
innodb_buffer_pool_dump_at_shutdown             =ON                         
innodb_buffer_pool_load_at_startup              =ON                         
###  for performance_schema
performance_schema                                                      =on
performance_schema_consumer_global_instrumentation                      =on    
performance_schema_consumer_thread_instrumentation                      =on    
performance_schema_consumer_events_stages_current                       =on    
performance_schema_consumer_events_stages_history                       =on    
performance_schema_consumer_events_stages_history_long                  =off   
performance_schema_consumer_statements_digest                           =on    
performance_schema_consumer_events_statements_current                   =on    
performance_schema_consumer_events_statements_history                   =on    
performance_schema_consumer_events_statements_history_long              =off   
performance_schema_consumer_events_waits_current                        =on    
performance_schema_consumer_events_waits_history                        =on    
performance_schema_consumer_events_waits_history_long                   =off   
performance-schema-instrument                                           ='memory/%=COUNTED'
EOF
}
#

if [ -z "$1" ]
then
	echo 'please input mysql version you want to install:'
	echo 'eg:5.7.22'
#version 
	read version
else
	version=$1
fi

echo ${version}|grep -E ^[0-9]\.[0-9]\.[0-9][0-9]?$ >>/dev/nul
until [ $? -eq 0 ]
	do
	echo "Your version is not a vaid value! please input version like this: 5.7.22"
	read version
	echo ${version}|grep -E ^[0-9]\.[0-9]\.[0-9][0-9]?$ >>/dev/nul
done

#Make sure
if [ -z "$2" ]
then
	info="n"
else
	info=$2
fi



until [ "$info" = "y" ]
do  
	echo "Do you want to install MySQL ${version}? [y|n]"
	read info
	
	if  [ "$info" = "n" ]
	then 
		echo "please input mysql version you want to install:"
		read version
		
		echo ${version}|grep -E ^[0-9]\.[0-9]\.[0-9][0-9]?$ >>/dev/nul
	
		until [ $? -eq 0 ]
		do
			echo "Your version is not a vaid value ! please input version like this: 5.7.22 "
			read version
			echo ${version}|grep -E ^[0-9]\.[0-9]\.[0-9][0-9]?$ >>/dev/nul
		done
	
	elif [ "$info" = "y" ]
	then
		break
	else
		echo "Please input 'y' or 'n' ："
	
	fi
	
done

#def

suffix=${version//"."/""}
path="https://dev.mysql.com/get/Downloads/MySQL-${version:0:3}/"
packagename="mysql-${version}-linux-glibc2.*-x86_64.tar*"
temppath="/tmp/mysql${suffix}$RANDOM/"
basedir="/usr/local/mysql${suffix}"
datadir="/data/mysql${suffix}"
servicename="mysql${suffix}"
mysqlpassword="Ha.KGbxrd40"
rootpassword="Ha.HQngmg55"


echo "*****Start installing MySQL${version} at $(date)"$'\n'


mem=$(awk '($1 == "MemTotal:"){print $2}' /proc/meminfo)
cpu=$(grep 'processor' /proc/cpuinfo |sort |uniq |wc -l)

echo "*****Remove old MySQL..."$'\n'
yum list installed |grep mysql >>/dev/null
if test $? -eq 0
then
	yum -y remove mysql >/dev/null
	echo ""*****Remove old MySQL...[ok]"$'\n'"
else
	echo "No MySQL has been installed"
fi
#get Package
echo "*****Start getting package from ftp..."$'\n'
mkdir -p $temppath
cd $temppath
wget -c "${path}${packagename}" >/dev/null
if [ -a ${packagename} ]
then 
	echo "*****Get MySQL Package...[ok]"$'\n'
else 
	echo "*****No Package! Please check your version! ..."$'\n'
	rm -rf $temppath
	exit
fi


echo "*****Start adding system user..."$'\n'
useradd mysql >/dev/null && echo "'${mysqlpassword}'"|passwd --stdin mysql >>/dev/null
if test $? -eq 0
then 
	echo "*****Add user mysql...[ok]"$'\n'
fi

echo "*****Start installing mysql server..."$'\n'
tar -zxf ${packagename}
if [ -d "${basedir}" ]
then
	rm -rf ${basedir}/*
else
	mkdir -p ${basedir}
fi
mv ${packagename%%.tar*}/* ${basedir}
if test $? -eq 0
then
	echo "installing mysql server...[ok]"$'\n'
else
	echo "installing mysql server...[failed]"$'\n'
	rm -rf $temppath
	exit
fi

chown -R mysql:mysql ${basedir}

if [ -a /etc/my.cnf ]
then
	mv /etc/my.cnf /etc/my.cnf_old >>/dev/null
fi

echo "*****Start configing my.cnf..."$'\n'

touch ${temppath}/my.cnf
###
###配置my.cnf
if test ${version:0:3} == "5.7"
then 
	Get57cnf
elif test ${version:0:3} == "5.6"
then
	Get56cnf
elif test ${version:0:3} == "8.0"
then
	Get80cnf
else
	echo "Not Support the version"
fi

echo "*****Config my.cnf...[ok]"$'\n'

echo "*****Start initializing mysql server..."$'\n'
cd ${basedir}

if [ -d "${datadir}" ]
then
	rm -rf ${datadir}/*
else
	mkdir -p ${datadir}
fi
chown mysql:mysql -R ${datadir}

if test ${version:0:3} == "5.6"
then
	./scripts/mysql_install_db --defaults-file=${temppath}/my.cnf --user=mysql --port=${suffix} --datadir=${datadir} 
else
	./bin/mysqld --defaults-file=${temppath}/my.cnf --initialize-insecure  --user=mysql --basedir=${basedir} --datadir=${datadir} 
	
fi

if test $? -eq 0;
then 
	echo "*****MySQL initialize...[ok]"$'\n'
else 
	echo "*****MySQL initialize...[Failed]"$'\n'
	echo "MySQLBaseDir=$basedir,please manually initialize MySQL "
	exit
fi


###service 


echo "*****Start creating mysql servervice..."$'\n'

cp ${basedir}/support-files/mysql.server /etc/init.d/${servicename}
sed -i "s@^basedir=@basedir=${basedir}@" /etc/init.d/${servicename}
sed -i "s@^datadir=@datadir=${datadir}@" /etc/init.d/${servicename}
if test $? -eq 0;
then 
	echo "*****ADD MySQL Service...[ok]"$'\n'
fi



echo "*****Start starting MySQL service..."$'\n'
cp ${temppath}/my.cnf ${basedir}/my.cnf
service ${servicename} start 
	
if test $? -eq 0;then 
	echo "*****MySQL Service Start...[ok]"$'\n'
else 
	echo "*****MySQL Service Start...[Failed]"$'\n' 
	more ${datadir}/err.log | grep ERROR
	rm -rf ${temppath}
	exit
fi

#
if [ -a /usr/bin/mysql ]
then
	ln -s ${basedir}/bin/mysql /usr/bin/mysql >>/dev/null
fi

# swappiness
echo "*****Start configing swappiness..."$'\n'
swappiness=$(cat /proc/sys/vm/swappiness)
if test ${swappiness} -ge 10
then
	sysctl -w vm.swappiness=1 >>/dev/null
	echo 'vm.swappiness = 1'>>/etc/sysctl.conf
	echo "*****Config swappiness...[ok]"$'\n'
else
	echo "swappiness=${swappiness}"
fi


echo "*****Start adding mysql user..."$'\n'
touch ${temppath}dxc.sql
if test "${version:0:3}" == "5.6"
then
	alterusersql="update mysql.user set password=password('${rootpassword}') where user='root';flush privileges;"
else
	alterusersql="ALTER USER root@'localhost' IDENTIFIED BY '${rootpassword}';"
fi

cat>${temppath}dxc.sql<<EOF
use mysql;
delete from user where user='';
${alterusersql}
EOF

${basedir}/bin/mysql -uroot -S /tmp/${servicename}.sock <${temppath}dxc.sql
if test $? -eq 0;then echo "*****MySQL user add...[ok]"$'\n';fi

echo "*****Start deleting package..."$'\n'
rm -rf $temppath
if test $? -eq 0;then echo "*****Package delete...[ok]"$'\n';fi


echo "MySQL install Finished at $(date)"
${basedir}/bin/mysql -uroot -S /tmp/${servicename}.sock -p${rootpassword} -e"select @@basedir,@@datadir,@@port,@@socket;"
