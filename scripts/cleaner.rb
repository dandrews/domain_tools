#!/usr/bin/env ruby

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
  outfile     = "zones/#{outfile}"
  zip_type    = zone_row[6]
  unzip_file  = outfile.gsub(".#{zip_type}","")

  # # step 1 cURL
  # puts("Begin FTP #{zone}") # com
  # ftp_path  = "ftp://#{ftp_host}/#{file_path}" # ftp://rz.verisign-grs.com/com.zone.gz
  # if system("curl -u #{username}:#{password} #{ftp_path} -o #{outfile}")
  #   puts("Finished FTP #{outfile}") # com.zone.gz
  # else
  #   puts("Failed FTP #{zone}")
  #   next
  # end

  # step 2 unzip
  puts("Begin gunzip #{outfile}")
  if system("gunzip #{outfile}") # gunzip zones/com.zone.gz
    puts("Finished gunzip #{unzip_file}") # zones/com.zone
  else
    puts("Failed gunzip #{outfile}")
    next
  end

  # step 3 clean
  puts("Begin clean #{zone}, #{unzip_file}")
  cleaner    = zone_row[7]
  clean_zone = "#{unzip_file}".gsub("zones/", "zones/clean.") # clean.com.zone
  cleaner    = cleaner.gsub("ORIG_FILE", unzip_file).gsub("CLEAN_FILE", clean_zone)
  puts cleaner
  if system(cleaner)
    puts("Finished clean #{zone}, #{clean_zone}")
    system("rm #{unzip_file}")
  else
    puts("Failed clean #{unzip_file}")
    next
  end

  # step 4 zip
  puts("Begin gzip #{zone}, #{clean_zone}")

  # clean out old gz file
  gz_file = %x{ls -S #{clean_zone}.gz}.split("\n")
  if not gz_file.empty?
    %x{rm #{clean_zone}.gz}
  end
  if system("gzip #{clean_zone}")
    puts("Finished gzip #{zone}, #{clean_zone}.gz") # zones/clean.com.zone.gz
  else
    puts("Failed gzip #{clean_zone}")
    next
  end

  # Finished
  puts("### Finished processing #{zone}, #{clean_zone}.gz ###")

end
