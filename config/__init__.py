# We use PyMySQL instead of mysqlclient because it installs easily on every OS.
# These lines make Django think PyMySQL is the normal MySQL driver.
import pymysql

pymysql.version_info = (2, 2, 1, "final", 0)
pymysql.install_as_MySQLdb()
