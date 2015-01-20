task :load_com => :environment do |t|

  zone_file_path = 'zones/clean.com.zone'
  zone = 'com'
  # count = %x{wc -l ./zones/clean.com.zone}.split[0].to_i
  count = 115288817 
  progressbar = ProgressBar.create( :total => count )

  puts "Beginning @ #{Time.now}"

  inserts = []
  File.foreach(zone_file_path) do |x|
    name = x.downcase.strip
    inserts.push( "'#{name}', '{\"#{zone}\"}'" )
    if inserts.size == 1000
      sql = "INSERT INTO domains (name, tlds) VALUES (#{inserts.join("), (")})"
      ActiveRecord::Base.connection.execute sql
      inserts = []
    end
    progressbar.increment
  end

  unless inserts.size == 0
    sql = "INSERT INTO domains (name, tlds) VALUES (#{inserts.join("), (")})"
    ActiveRecord::Base.connection.execute sql
  end
  
  puts "Finished @ #{Time.now}"

end

task :load_tlds => :environment do |t|
  puts "Beginning @ #{Time.now}"
  zone_files = Dir["zones/*.zone"]
  zone_files.each do |zone_file|
    zone = zone_file.gsub("zones/clean.","").gsub(".zone","")
    puts zone
    puts "\tBeginning #{zone} @ #{Time.now}"
    count = %x{wc -l #{zone_file}}.split[0].to_i
    progressbar = ProgressBar.create( :total => count )
    inserts = []    
    File.foreach(zone_file) do |x|
      name = x.downcase.strip
      inserts.push( "'#{name}', '{\"#{zone}\"}'" )
      if inserts.size == 1000
        sql = "INSERT INTO domains (name, tlds) VALUES (#{inserts.join("), (")})"
        ActiveRecord::Base.connection.execute sql
        inserts = []
      end

      # unless inserts.size == 0
      #   sql = "INSERT INTO domains (name, tlds) VALUES (#{inserts.join("), (")})"
      #   ActiveRecord::Base.connection.execute sql
      # end
      
      insert_sql = "INSERT INTO domains (name, tlds) SELECT '#{name}', '{\"#{zone}\"}'"

      update_sql = "UPDATE domains SET tlds=tlds || ARRAY['#{zone}'] WHERE name = '#{name}'"

      upsert_sql = "WITH upsert AS (#{update_sql} RETURNING *) #{insert_sql} WHERE NOT EXISTS (SELECT * FROM upsert);"

      ActiveRecord::Base.connection.execute upsert_sql

      progressbar.increment

    end
    puts "\tFinished #{zone} @ #{Time.now}"
  end
  puts "Finished @ #{Time.now}"  
end

task :load_tlds_faster => :environment do |t|
  m_start_time = Time.now
  puts "Begin @ #{m_start_time}"  
  zone_files = %x{ls -S zones/*.zone}.split("\n")
  all_zones = []
  zone_files.each do |zone_file|
    # %x{cp #{zone_file} #{zone_file}.copy}
    zone = zone_file.gsub("zones/clean.","").gsub(".zone","")
    all_zones << zone
  end

  master_file = 'zones/master_tlds.csv'
  %x{echo "" > #{master_file}}

  zone_copy_files = %x{ls -S zones/*.zone}.split("\n")
  # zone_copy_files = %x{ls -S zones/*.zone.copy}.split("\n")
  zone_copy_files.each do |zone_file|
    
    # zone = zone_file.gsub("zones/clean.","").gsub(".zone.copy","")

    zone = zone_file.gsub("zones/clean.","").gsub(".zone","")

    other_zones = all_zones - [zone]
    name_counter = 0
    File.foreach(zone_file) do |x|
      name = x.downcase.strip
      tlds = [zone]

      # is this domain already present in the master file?
      result = %x{sgrep -- #{name}, #{master_file} | grep -m1 '^#{name},'}
      if result.present?
        next
      end

      other_zones.each do |other_zone|
        # puts "other_zone: #{other_zone}"
        start_time = Time.now
        # other_zone_file = "zones/clean.#{other_zone}.zone.copy"
        other_zone_file = "zones/clean.#{other_zone}.zone"
        result = %x{sgrep -- #{name} #{other_zone_file} | grep -m1 '^#{name}$'}
        # puts result
        if x == result
          tlds << other_zone
          puts "\t\tfound in #{other_zone}"
          # delete the line from the other zone file,
          # by replacing the zone file with it's inverse
          # %x{grep -v '^#{name}$' #{other_zone_file} > #{other_zone_file}_tmp}
          # %x{mv #{other_zone_file}_tmp #{other_zone_file}}
        end
        elapsed_time = Time.now - start_time
        puts "\t #{name},#{other_zone} @ #{elapsed_time}"
      end
      # name,{tld1\,tld2\,tld3}
      # TODO write line to master file
      # %x{ echo '#{name},{#{tlds.join('\\,')}}' >> #{master_file} }
      %x{ echo '#{name},{#{tlds.join('\\,')}}' | sort -t, -o #{master_file} -m - #{master_file} }
      name_counter += 1
      if name_counter > 10
        break
      end
      # in the end, delete the current clean zone file copy,
      # since all the domain names have been processed for the zone
      # %x{rm {zone_file}}
    end
  end
  end_time = Time.now
  puts "End @ #{end_time}"
  minutes = (end_time - m_start_time)/60
  puts "elapsed: #{minutes} minutes"
end

desc 'download the latest zone files and clean them for processing later'
task :clean_zones => :environment do

  require 'csv'

  CSV.foreach('zones_info.csv', {:col_sep => ';'}) do |zone_row|

    puts("### Begin processing #{zone_row[0]} ###")
  
    zone        = zone_row[0]

    next if "#" == zone[0] # comment zone row
    
    ftp_host    = zone_row[1]
    username    = zone_row[2]
    password    = zone_row[3]
    file_path   = zone_row[4]
    outfile     = zone_row[5]
    zip_type    = zone_row[6]
    unzip_file  = outfile.gsub(".#{zip_type}","")

    # step 1 download the latest published zone file, using cURL
    puts("Begin FTP #{zone}") # com
    ftp_path  = "ftp://#{ftp_host}/#{file_path}" # ftp://rz.verisign-grs.com/com.zone.gz
    if system("curl -u #{username}:#{password} #{ftp_path} -o #{outfile}")
      puts("Finished FTP #{outfile}") # com.zone.gz
    else
      puts("Failed FTP #{zone}")
      next
    end

    # step 2 unzip the file for processing
    puts("Begin gunzip #{outfile}")
    if system("gunzip #{outfile}") # com.zone.gz
      puts("Finished gunzip #{unzip_file}") # com.zone
    else
      puts("Failed gunzip #{outfile}")
      next
    end

    # step 3 run the one liner command to clean, sort, and de-dupe the file
    puts("Begin clean #{zone}, #{unzip_file}")
    cleaner    = zone_row[7]
    clean_zone = "clean.#{unzip_file}" # clean.com.zone
    cleaner    = cleaner.gsub("ORIG_FILE", unzip_file).gsub("CLEAN_FILE", clean_zone)
    puts cleaner
    if system(cleaner)
      puts("Finished clean #{zone}, #{clean_zone}")
      # system("rm #{unzip_file}")
    else
      puts("Failed clean #{unzip_file}")
      next
    end

    # step 4 zip the file back up for storage, until the next step
    puts("Begin gzip #{zone}, #{clean_zone}")  
    if system("gzip #{clean_zone}")
      puts("Finished gzip #{zone}, #{clean_zone}.gz") # clean.com.zone.gz
    else
      puts("Failed gzip #{clean_zone}")
      next
    end

    # Finished
    puts("### Finished processing #{zone}, #{clean_zone}.gz ###")

  end

end

desc 'unzip and merge all the domains into one file ( zones/master.zone ), for loading into the db'
task :load_tlds_even_faster => :environment do |t|

  m_start_time = Time.now
  puts "Begin @ #{m_start_time}"

  # TODO add a step to unzip all the files

  zone_files = %x{ls -S zones/*.zone}.split("\n")

  %x{rm zones/master.zone}
  %x{sort -m zones/*.zone | sort -u > zones/master.zone}

  end_time = Time.now
  minutes = (end_time - m_start_time)/60
  puts "elapsed: #{minutes} minutes"

  master_file = 'zones/master_tlds.csv'
  %x{rm #{master file}; touch #{master_file}}

  File.foreach(master_file) do |x|
    name = x.downcase.strip
    tlds = []
    zone_files.each do |zone_file|
      result = %x{sgrep -- #{name} #{zone_file} | grep -m1 '^#{name}$'}
      if x == result
        zone = zone_file.gsub("zones/clean.","").gsub(".zone","")
        tlds << zone
      end
    end
    %x{ echo '#{name},{#{tlds.join('\\,')}}' >> zones/master.zone }
  end

end

task :get_zone_files => :environment do
  %x{cx download -s "SD" Cheetah /home/contact16/*zone.gz}
end
