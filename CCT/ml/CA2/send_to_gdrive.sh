rclone copyto --progress --drive-shared-with-me \
	--exclude "send_to_gdrive.sh"\
	./\
	berstearns-gdrive:/CCT-trabalhos/1-semestre/2-machine-learning/module-assessments/CA2/




# exclude list
#Copy
#file1.txt
#file2.txt
#*.log
#
#
#while read -r pattern; do
#  exclude_flags+="--exclude \"$pattern\" "
#done < exclude_list.txt
#
#
#eval "rclone copyto --progress --drive-shared-with-me $exclude_flags ./ berstearns-gdrive:/CCT-trabalhos/1-semestre/1-statistical-techniques-for-data/module-assessments/CA2/"

