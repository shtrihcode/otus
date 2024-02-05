var dbPass = "Passw0rd"
var clusterName = "testCluster"

try {
  print('\nConfiguring the instances.');
  dba.configureInstance('icadmin@sqlnode1:3306',{password:dbPass,interactive:false,restart:true});
  dba.configureInstance('icadmin@sqlnode2:3306',{password:dbPass,interactive:false,restart:true});
  dba.configureInstance('icadmin@sqlnode3:3306',{password:dbPass,interactive:false,restart:true});
  print('\nConfiguring Instances completed.\n\n');
} catch(e) {
  print('\nConfiguring Instances failed.\n\nError: ' + e.message + '\n');
}
