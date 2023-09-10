if ::ActiveRecord::Base.connection_config[:adapter] == 'sqlite3'
    if c = ::ActiveRecord::Base.connection
      # see http://www.sqlite.org/pragma.html for details
      # Setting of the "synchronous" flag, "NORMAL" means sync less often but still more than none
      c.execute 'PRAGMA main.synchronous=NORMAL;'
      # Journal mode for database, WAL=write-ahead log
      c.execute 'PRAGMA main.journal_mode=WAL;'
    end
end