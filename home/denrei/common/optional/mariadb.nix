{pkgs, ...}: {
  services.mysql = {
    enable = true;
    package = pkgs.mariadb_110;
    configFile = ''
      [server]
      user = mysql
      pid-file = /run/mysqld/mysqld.pid
      socket = /run/mysqld/mysqld.sock
      basedir = /usr
      datadir = /var/lib/mysql
      tmpdir = /tmp
      lc-messages-dir = /usr/share/mysql
      bind-address = 127.0.0.1
      query_cache_size = 16M
      log_error = /var/log/mysql/error.log

      [mysqld]
      innodb-file-format=barracuda
      innodb-file-per-table=1
      innodb-large-prefix=1
      character-set-client-handshake = FALSE
      character-set-server = utf8mb4
      collation-server = utf8mb4_unicode_ci

      [mysql]
      default-character-set = utf8mb4
    '';
  };
}
