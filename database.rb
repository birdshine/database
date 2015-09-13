require "yaml/store"
tomdata = YAML::Store.new("data.yml")															# Create data.yml
Dir.mkdir("output") if !File.exists?("output")

def integer_replace(string)																		# Integer Replace Object
 string = string.downcase.to_s																	# Turn input to downcase string.
 ## Replace integers in string with .gsub, line break for formatting ##												
 string.gsub("1","one").gsub("2","two").gsub("3","three").gsub("4","four").gsub("5","five")\
 .gsub("6","six").gsub("7","seven").gsub("8","eight").gsub("9","nine").gsub("0","zero")
end																								# End Integer Replace Object
	
def space_replace(string)																		# Space Replace Object
  string.downcase.to_s.gsub(" ","_")															# Replace " " with "_" in string
end																								# End Space Replace Object

def desc_translate(name)																		# Desc Translate Object
  (name + "_desc").to_sym																		# Convert desc to a storable sym
end																								# End Desc Translate Object

def tags_translate(name)																		# Tags Translate Object
  (name + "_tags").to_sym																		# Convert tags to storable sym (not the hash, just the name).
end																								# End Tags Translate Object

def time_translate(name)																		# Time Translate Object
  (name + "_time").to_sym																		# Convert time to storable sym
end																								# End Time Translate Object

def last_update_translate(name)																	# Last Update Translate Object
  (name + "_last_update").to_sym																# Convert last update to storably sym
end																								# End Last Update Translate Object



def delete_data(name)
  tomdata = YAML::Store.new("data.yml")															# Open data.yml
  tomdata.transaction {tomdata.delete(name.to_sym)}												# Delete name
  tomdata.transaction {tomdata.delete(desc_translate(name))}									# Delete description
  tomdata.transaction {tomdata.delete(tags_translate(name))}									# Delete tags
  tomdata.transaction {tomdata.delete(time_translate(name))}									# Delete time
  tomdata.transaction {tomdata.delete(last_update_translate(name))}								# Delete last update
end

def read_data(entry)																			# Begin Read Data Object
  tomdata = YAML::Store.new("data.yml")															# Open data.yml.
  entry = entry.downcase.to_s																	# Turn entry to downcase string.
  print "Name: "																				# Print entry name.
  print tomdata.transaction{tomdata[entry.to_sym]}
  puts ""
  print "Description: "																			# Print entry description.
  print tomdata.transaction{tomdata[desc_translate(entry)]}
  puts ""
  print "Tags: "																				# Print entry tags.
  print tomdata.transaction{tomdata[tags_translate(entry)]}
  puts ""
  print "Created on "																			# Print entry creation time.
  print tomdata.transaction{tomdata[time_translate(entry)]}
  print "."
  if tomdata.transaction{tomdata.root?(last_update_translate(entry))}						
    puts ""	
	print "Last updated on "
	print tomdata.transaction{tomdata[last_update_translate(entry)]}							# If updated, print last update time.
	print "."
  else
  end
  puts ""
  puts ""
end																								# End Read Data Object

def read_entry																					# Begin Read Entry Object
  tomdata = YAML::Store.new("data.yml")															# Open data.yml.
  read_control = 0																				# Define read_control variable to control read menu until loop.
  until read_control == 1																		# Begin read_control until loop.
    puts "Which entry would you like to read?"													# Prompt for read_input.
    read_input = gets.chomp																		# Get read_input.
    read_input = space_replace(integer_replace(read_input))										# Call space&integer_replace on read_input.
	if tomdata.transaction{tomdata.root?(read_input.to_sym)}									# Check that entry exists.
	  puts ""
	  read_data(read_input)																		# Entry exists. Call read_data on entry.
	  puts "Would you like to read another entry? Y/N:"											# Read another entry or exit read menu.
	  read_another_input = gets.chomp
	  read_another_input = space_replace(integer_replace(read_another_input))
	  case read_another_input
	  when 'y'
	    puts ""
	  when 'yes'
	    puts ""
	  else
	    puts ""
		puts "Exiting read menu..."
		read_control += 1																		# Add to read_control variable to end read menu until loop.
	  end
	else
	  puts ""
	  puts "Entry does not exist. Would you like to read an entry? Y/N:"						# Entry does not exist. Read valid entry exit read menu.					
	  read_another_input = gets.chomp
	  read_another_input = space_replace(integer_replace(read_another_input))
	  case read_another_input
	  when 'y'
	    puts ""
	  when 'yes'
	    puts ""
	  else
	    puts ""
		puts "Exiting read menu..."
		read_control += 1																		# Add to read_control variable.
	  end
	end
  end																							# End read_control until loop.
end


def output_entry(entry)																			# Begin Output Entry Object
  tomdata = YAML::Store.new("data.yml")															# Open data.yml.
  entry = entry.downcase.to_s																	# Turn entry to downcase string.
  entry_output = File.new("output/#{entry}.txt", "a+")											# Create txt file in output/ for entry.
  entry_output.print("Name: ")												
  entry_output.print(tomdata.transaction{tomdata[entry.to_sym]})							# Add entry name to entry_output.txt
  entry_output.puts ""
  entry_output.print("Description: ")
  entry_output.print(tomdata.transaction{tomdata[desc_translate(entry)]})					# Add description to entry_output.txt
  entry_output.puts ""
  entry_output.print("Tags: ")
  entry_output.print(tomdata.transaction{tomdata[tags_translate(entry)]})					# Add tags to entry_output.txt
  entry_output.puts ""
  entry_output.print("Created on ")
  entry_output.print(tomdata.transaction{tomdata[time_translate(entry)]})					# Add creation time to entry_output.txt
  entry_output.print(".")
  if tomdata.transaction{tomdata.root?(last_update_translate(entry))}						# If statement checks if entry has been updated.
    entry_output.puts ""	
	entry_output.print("Last updated on ")
	entry_output.print(tomdata.transaction{tomdata[last_update_translate(entry)]})			# Add last update time to entry_output.txt
	entry_output.print(".")
	entry_output.puts()
	entry_output.puts()
  else
    entry_output.puts()
	entry_output.puts()
  end
  entry_output.close																		# Close entry_output.txt
end																							# End Output Entry Object

def export_entry																			# Begin Export Entry Object
  tomdata = YAML::Store.new("data.yml")														# Open data.yml
  menu_control = 0																			# Define menu_control variable to control menu until loop.
  until menu_control == 1																	# Begin menu_control until loop.
    puts "Which entry would you like to export to text file?"								# Prompt for export_input.
	export_input = gets.chomp																# Get export_input.
	export_input = space_replace(integer_replace(export_input))								# Call space&integer_replace on export_input.
	if tomdata.transaction {tomdata.root?(export_input.to_sym)}								# If check that entry exists.
	  output_entry(export_input)
	  puts ""
	  puts "'#{export_input} has been exported to output/#{export_input}.txt."				# Entry exists, export & report.
	  puts "Export another entry? Y/N:"														# Prompt for export_another_input.
	  export_another_input = gets.chomp														# Get export_input.
	  export_another_input = space_replace(integer_replace(export_another_input))			# Call space&integer_replace on export_input.
	  case export_another_input																# Begin export_another_input case.
	  when 'y'																				# User wants to export another entry.
	    puts ""
	    puts "Returning to export menu..."													# Report and return to update menu.
		puts ""
	  when 'yes'																			# User wants to export another entry.
	    puts ""
		puts "Returning to export menu..."													# Report and return to update menu.
		puts ""
	  else																					# User is done with export menu.
	    puts ""
		puts "Exiting export menu..."														# Report exiting export menu.
		puts ""
		menu_control +=1																	# Add to menu_control variable to break menu until loop.
	  end																					# End case.
	else																					# Entry does not exist.
	  puts ""										
	  puts "Entry does not exist."															# Report entry does not exist.
	  puts "Export an entry? Y/N:"															# Prompt for export_another_input.
	  export_another_input = gets.chomp														# Get export_another_input.
	  export_another_input = space_replace(integer_replace(export_another_input))			# Call space&integer_replace on export_another_input.
	  case export_another_input																# Begin export_another_input case.
	  when 'y'																				# User wants to export another entry.
	    puts ""
	    puts "Returning to export menu..."													# Report and return to export menu.
		puts ""
	  when 'yes'																			# User wants to export another entry.
	    puts ""
		puts "Returning to export menu..."													# Report and return to export menu.
		puts ""
	  else																					# User is done with the export menu.
	    puts ""
		puts "Exiting export menu..."														# Report and exit export menu.
		puts ""
		menu_control +=1																	# Add to menu_control variable to break menu until loop.
	  end																					# End export_another_input case.
	end																						# End if statement.
  end																						# End menu_control until loop.
end																							# End Export Entry Object

def search_tag(*tags)																		# Search Tags Object
  tomdata = YAML::Store.new("data.yml")														# Open data.yml.
  matching_entries = Array.new																# Make matching_entries array.
  tags_searching = Array.new																# Make tags_searching array.
  roots_searching = Array.new																# Make roots_searching array.
  entry_search = Hash.new																	# Make entry_search hash.
  key_values = Array.new																	# Make key_values array.
  keyArray = Array.new																		# Make keyArray array.
  tagArray = Array.new																		# Make tagArray array.
  tags.each do |tagarr|																		# Strip away parent array levels from tags, make sym.
   tagarr.each do |tag|
     tagRev = space_replace(integer_replace(tag))
     tagArray << tagRev.to_sym																	# Add stripped tags to tagArray.
   end
  end
  roots_searching << tomdata.transaction{tomdata.roots}										# Collect tomdata.roots into roots_searching.
  roots_searching.each do |entry|															# Begin roots_searching.each.
    entry.each do |x|																		# For each entry.
	  x = x.to_s																			# Get get string of entry name to find tags.
	  if x.include?("_tags")																# Find root instances of tags.
		entry_search[x[0...-5].to_sym] = tomdata.transaction{tomdata[x.to_sym]}				# Create entry_search hash entry = [tags,tags].
	  else																					# Else (nil).
	  end																					# End tags if.
	end																						# End entry.each.
  end																						# End roots_search.each.	
  entry_search.each_key do |key|															# Begin entry_search has each key value.
    key_values = entry_search.values_at(key)												# Collect keys in key_values.hash.
    key_values.each do |x|																	# Strip array parent level each.
      x.each do |t|
        keyArray << t																		# Strip key_values parent level into keyArray array.
      end																					# End parent level strip each.
    end																						# End parent level stripe each.
    matching_entries << key if (tagArray & keyArray) == tagArray							# Add key to matching_entries array if all tags are a match.
    keyArray = [nil]																		# Clear keyArray.
  end																						# End key_values each.
  matching_entries = matching_entries.uniq													# Clear duplicate entries in matching_entries.
  print "Entries that include the tag(s) "													# Report matching entries.
  print tagArray
  print ":"
  puts ""
  matching_entries.each {|x| print (x.to_s.capitalize + ", ")}
  puts ""
  puts ""
  puts "Read entry(s)? Y/N:"																# Prompt for read_input.							
  read_input = gets.chomp																	# Get read_input.
  read_input = space_replace(integer_replace(read_input))									# Call space&integer_replace on read_input.
  case read_input																			# Begin read_input case.
  when 'yes'																				# User wants to read all matching entries.
    puts ""
    matching_entries.each {|entry|read_data(entry)}											# Call read_data on all matching entries.
  when 'y'																					# User wants to read all matching entries.
    puts ""
    matching_entries.each {|entry|read_data(entry)}											# Call read_data on all matching entries.
  else
  end
  puts ""
  puts "Export entry(s)? Y/N: "																# Prompt for output_input.
  output_input = gets.chomp																	# Get output_input.
  output_input = space_replace(integer_replace(output_input))								# Call integer&space_replace on output_input.
  case output_input																			# Begin output_input case.
  when 'yes'																				# User wants to output entries.
    puts ""
	puts "Exporting entry(s)..."
	puts "File(s) created in /output."
	matching_entries.each {|entry| output_entry(entry)}										# Outport entries and report.
	puts ""
  when 'y'
    puts ""
	puts "Exporting entry(s)..."
	puts "File(s) created in /output."
	matching_entries.each {|entry| output_entry(entry)}										# Output entries and report.
	puts ""
  else
    puts ""
  end																						# End output_input case.
  puts "Exiting tag search menu..."
  puts ""
end																							# End Search Tags Object

def search_entry
  tomdata = YAML::Store.new("data.yml")
  tag_array = Array.new
  search_control = 0
  until search_control == 1
    puts "Would you like to search by name or by tag? NAME/TAG/EXIT:"
	search_input = gets.chomp
	search_input = space_replace(integer_replace(search_input))
	case search_input
	when 'name'
	  puts ""
	  puts "What is the name of the entry you would like to read?"
	  entry_name_input = gets.chomp
	  entry_name_input = space_replace(integer_replace(entry_name_input))
	  if tomdata.transaction {tomdata.root?(entry_name_input.to_sym)}
	    puts ""
		read_data(entry_name_input)
		puts "Would you like to search for another entry? Y/N:"
		read_another = gets.chomp
		read_another = space_replace(integer_replace(read_another))
		case read_another
		when 'y'
		  puts ""
		when 'yes'
		  puts ""
		else
		  puts ""
		  puts "Exiting search menu..."
		  search_ontrol += 1
		end
	  else
	    puts ""
	    puts "Entry does not exist. Search for another entry? Y/N"
		read_another = gets.chomp
		read_another = space_replace(integer_replace(read_another))
		case read_another
		when 'y'
		  puts ""
		when 'yes'
		  puts ""
		else
		  puts ""
		  puts "Exiting search menu..."
		  search_control += 1
		end
	  end
	when 'tag'
	puts ""
	puts "Enter tags to search. Enter 'done' when finished:"
	tag_control = 0 
	until tag_control == 1
	  tag_input = gets.chomp
	  tag_input = space_replace(integer_replace(tag_input))
	  if tag_input == 'done'
	    puts ""
		search_tag(tag_array)
		tag_control += 1
	  else
	    tag_array << tag_input.to_sym
	  end
	end
	when 'tags'
	puts ""
	puts "Enter tags to search. Enter 'done' when finished:"
	tag_control = 0 
	until tag_control == 1
	  tag_input = gets.chomp
	  tag_input = space_replace(integer_replace(tag_input))
	  if tag_input == 'done'
		puts ""
		search_tag(tag_array)
		tag_control += 1
	  else
	    tag_array << tag_input.to_sym
	  end
	end
	when 'exit'
	  puts ""
	  puts "Exiting search menu..."
	  search_control += 1
	else
	  puts ""
	  puts "Invalid selection."
	end
  end
end

def create_entry																				# Create Entry Object
  tomdata = YAML::Store.new("data.yml")										     		    	# Open data.yml
  create_entry_control = 0																		# Make create_entry_control variable for until loop.
  until create_entry_control == 1																# create_entry_control until loop
    puts " "
    puts "Enter name for entry:"																# Prompt user for entry name.
    entry_name_input = gets.chomp																# Get entry_name_input
	entry_name_preserved = entry_name_input.to_s												# Keep unsymed string as entry_name_preserved
    entry_name_input = integer_replace(entry_name_input)										# Call integer_replace on entry_name_input
	entry_name_input = space_replace(entry_name_input)											# Call space_replace on entry_name_input
    if tomdata.transaction {tomdata.root?(entry_name_input.to_sym)}								# Check to see if entry already exists
      puts ""
      puts "An entry already exists with that name."											# Entry already exists. Alert user.
    else																						# Entry does not exist.
      puts ""
      puts "Enter description for entry:"														# Prompt for an entry description.
      entry_description_input = gets.chomp														# Get entry_description_input
      entry_description_input = entry_description_input.to_s									# Turn entry_description_input to string.
      puts ""
      puts "Enter tags for entry."																# Prompt user for tags.
      puts "Integers will be replaced with spelled out numbers."
      puts "Enter 'done' when finished:"
      entry_tags = Array.new																	# Create entry_tags array
      tag_control = 0																			# Create tag_control variable for until loop
      until tag_control == 1																	# tag_control until loop
        entry_tag_input = gets.chomp															# Get entry_tag_input 
        entry_tag_input = integer_replace(entry_tag_input)										# Call integer_replace on entry_tag_input
        entry_tag_input = space_replace(entry_tag_input)										# Call space_replace on entry_tag_input
        case entry_tag_input																	# Case entry_tag_input.
        when 'done'																				# User is done entering tags.
          puts ""
          print "Tags saved for this entry: "													# Print tags saved for entry.
          print entry_tags																		# Print entry_tags array
          tag_control += 1																		# +1 to tag_control variable
        else																					# User wants to add tag
          entry_tags << entry_tag_input.to_sym													# Convert entry_tag_input to sym and add it to entry_tags array.
        end																						# End case of entry_tag_input
      tomdata.transaction do																	# Open tomdata.transaction to add entry to data.yml
        tomdata[entry_name_input.to_sym]             = entry_name_preserved			        	# Store entry_name_input
        tomdata[(entry_name_input + "_desc").to_sym] = entry_description_input					# Store entry_description_input
        tomdata[(entry_name_input + "_tags").to_sym] = entry_tags								# Store entry_tags array
        tomdata[(entry_name_input + "_time").to_sym] = Time.now									# Store time of creation.
      end																						# End tomdata.transaction
      end																						# End tag_control until loop
    puts ""
    puts "Would you like to add another entry? Y/N:"											# Ask user if they want to add another another entry.
    another_entry_input = gets.chomp															# Get another_entry_input
    another_entry_input = another_entry_input.downcase.to_s										# Turn another_entry_input to a downcase string.
    case another_entry_input																	# Case another_entry_input
    when 'n'																					# When 'n'
      create_entry_control += 1																	# create_entry_control + 1
    when 'no'																					# When 'no'
      create_entry_control += 1																	# create_entry_control + 1
    end																							# End another_entry_input_case
    end																							# End entry_name_input if statement														
  end																							# End create_entry_control until loop
end																								# End Create Entry Object

def update_entry																					# Update Entry Object
  tomdata = YAML::Store.new("data.yml")																# Open data.yml
  update_control = 0																				# Define update_control variable for update menu until loop.
  until update_control == 1																			# update_control until loop
    puts ""
	puts "What entry would you like to update?"														# Prompt for update_name_input.
	update_name_input = gets.chomp																	# Get update_name_input.
	update_name_input = integer_replace(space_replace(update_name_input))							# Call integer/space_replace on update_name_input.
	if tomdata.transaction {tomdata.root?(update_name_input.to_sym)}								# Check to see if entry exists.
	  category_control = 0																			# Entry exists. Define category_control_variable for category menu until loop.
	  until category_control == 1																	# category_control until loop.					
	    puts ""	
	    puts "Enter the field you wish to update: NAME/DESCRIPTION/TAGS/EXIT:"
	    update_category_input = gets.chomp															# Get update_category_input.
		update_category_input = update_category_input.downcase.to_s									# Turn update_category_input into a downcase string.
		case update_category_input																	# Case update_category_input.
		when 'name'																					# User wants to update entry name.
		  puts ""
		  puts "Enter new name."																	# Prompt for new_name_input.
		  new_name_input = gets.chomp																# Get new_name_input.
		  new_name_preserved = new_name_input.to_s													# Turn new_name_input to downcase string.
		  new_name_input = integer_replace(space_replace(new_name_input))							# Call integer/space_replace on new_name_input.
		  old_name = tomdata.transaction {tomdata[update_name_input.to_sym]}						# Define old_name as old entry :name value.
          old_description = tomdata.transaction {tomdata[desc_translate(update_name_input)]}	    # Define old_description as old entry :name_desc value.
		  old_tags = Array.new																		# Create old_tags array.
		  tomdata.transaction {old_tags = (tomdata[tags_translate(update_name_input)])}				# Push old entry :name_tags to old_tags.
		  old_time = tomdata.transaction {tomdata[time_translate(update_name_input)]}				# Define old_time as old entry :name_time.
		  delete_data(update_name_input)															# Delete old entry with delete_data.
		  tomdata.transaction do																	# Create new data entry w/ tomdata transaction.
            tomdata[new_name_input.to_sym]                    = new_name_preserved					# :name => new_name_preserved
            tomdata[desc_translate(new_name_input)]           = old_description						# :name_desc => old_description
            tomdata[tags_translate(new_name_input)]           = old_tags							# :name_tags => old_tags array
            tomdata[time_translate(new_name_input)]           = old_time							# :name_time => old_time
			tomdata[last_update_translate(new_name_input)]    = Time.now							# :name_last_update => Time.now
          end																						# End create new data entry tomdata transaction.
		  puts ""			
		  puts "Entry was updated. '#{old_name}' renamed '#{new_name_preserved}.'"					# Report to user that name was changed.
		  puts ""
		  puts "Would you like to update another entry?"											# Prompt for update_another_input.
		  puts "Y/N:"	
		  update_another_input = gets.chomp															# Get update_another_input.
		  update_another_input = update_another_input.downcase.to_s									# Turn update_another_input into downcase string.
		  case update_another_input																	# Case update_another_input									
		  when 'y'																					# User wants to update another entry.
		    puts ""
			puts "Returning to update menu..."														# Report to user returning to update menu.
			puts ""
			category_control += 1																	# Add to category_control to break category menu until loop.
		  when 'yes'																				# User wants to update another entry.
		    puts ""					
			puts "Returning to update menu..."														# Report to user returning to update menu.
			puts ""
			category_control += 1																	# Add to category control to break category menu until loop.
		  else																						# User is done with the update menu.
		    puts ""
		    puts "Exiting update menu..."															# Report to user exiting upate menu.
			puts ""
		    category_control += 1 																	# Add to category_control to break category menu until loop.
			update_control += 1																		# Add to update_control to break update menu until loop.
		  end
		when 'description'																			# User wants to update category.
		  puts ""
		  puts "Current description reads:"															# Report current description.			
		  puts tomdata.transaction {tomdata[desc_translate(update_name_input)]}						# Puts entry :name_desc value
		  puts ""
		  puts "Enter new description:"																# Prompt for new_description_input
		  new_description_input = gets.chomp														# Get new_description_input.
		  new_description_input = new_description_input.to_s										# Turn new_description_input to downcase string.
		  tomdata.transaction {tomdata[desc_translate(update_name_input)] = new_description_input}  # :name_desc => new_description_input
		  tomdata.transaction {tomdata[last_update_translate(update_name_input)] = Time.now}		# :name_last_update => Time.now
		  entry_name_value = tomdata.transaction {tomdata[update_name_input.to_sym]}				# Capture entry :name value as entry_name_value
		  puts ""
		  puts "Description for #{entry_name_value} changed to:" 									# Report to user description changed.
		  puts "#{new_description_input}"
		  puts ""
		  puts "Would you like to update another entry?"											# Prompt for update_another_input.
		  puts "Y/N:"
		  update_another_input = gets.chomp															# Get update_another_input.
		  update_another_input = update_another_input.downcase.to_s									# Turn update_another_input to a downcase string.
		  case update_another_input																	# Case update_another_input.
		  when 'y'																					# User wants to update another entry.
		    puts ""
			puts "Returning to update menu..."														# Report returning to update menu.
			puts ""
			category_control += 1																	# Add to category_control to break category menu until loop.
		  when 'yes'																				# User wants to update another entry.
		    puts ""
			puts "Returning to update menu..."														# Report returning to update menu.
			puts ""
			category_control += 1																	# Add to category_control to break category menu until loop.
		  else																						# User is done with update menu.
		    puts ""
		    puts "Exiting update menu..."															# Report exiting update menu.
			puts ""
		    category_control += 1 																	# Add to category_control to break category menu until loop.
			update_control += 1																		# Add to update_control to break update menu until loop.
		  end																						# End update_another_input case.
		when 'tags'																					# User wants to update tags.
		  puts ""
		  puts "Current tags:"																		# Report current tags.
		  old_tags = Array.new																		# Crate old_tags array.
		  update_tags = Array.new																	# Create new_tags array.
		  tomdata.transaction do																	# tomdata transaction to push entry tags to old_tags array.
		    old_tags = tomdata[tags_translate(update_name_input)]									# Push entry tags to old_tags
			old_tags.each {|x| puts x}																# Puts iterate through current tags.
		  end																						# End tomdata transaction.
		  puts ""
		  puts "Enter new tags:"																	# Prompt for update_tag_input.
          update_tag_control = 0																	# Create update_tag_control variable to control tag menu until loop.	
          until update_tag_control == 1																# update_tag_control until loop.
            update_tag_input = gets.chomp															# Get update_tag_input.
            update_tag_input = integer_replace(space_replace(update_tag_input))						# Call integer/space_replace on update_tag_input.			
            case update_tag_input																	# Case update_tag_input.
            when 'done'																				# User is done adding tags.
              puts ""
              print "Tags saved for this entry: "													# Report update_tags array.
              print update_tags																		
              update_tag_control += 1																# Add to update_tag_control to break tag menu until loop. 
			  tomdata.transaction {tomdata[tags_translate(update_name_input)] = update_tags}		# :name_tags => update_tags
			  tomdata.transaction {tomdata[last_update_translate(update_name_input)] = Time.now}    # :name_last_update => Time.now
            else																					# User wants to add a tag.
              update_tags << update_tag_input.to_sym												# Push tag to update_tags array.
            end																						# End update_tag_input case.
	      end																						# End update_tag_control until loop.
	      puts ""
		  puts "Would you like to update another entry?"											# Prompt for update_another_input.
		  puts "Y/N:"		
		  update_another_input = gets.chomp															# Get update_another_input.
		  update_another_input = update_another_input.downcase.to_s									# Turn update_another_input to downcase string.
		  case update_another_input																	# Case update_another_input.
		  when 'y'																					# User wants to update another entry.
		    puts ""	
			puts "Returning to update menu..."														# Report returning to update menu.
			puts ""
			category_control += 1																	# Add to category_control to break category menu until loop.
		  when 'yes'																				# User wants to update another entry.
		    puts ""	
			puts "Returning to update menu..."														# Report returning to update menu.
			puts ""
			category_control += 1																	# Add to category_control to break category menu until loop.
		  else																						# User is done with the update menu.
		    puts ""
		    puts "Exiting update menu..."															# Report exiting update menu.
			puts ""
		    category_control += 1 																	# Add to category_control to break category menu until loop.
			update_control += 1																		# Add to update_control to break update menu until loop.
		  end																						# End update_another_input case.
		when 'exit'
		  puts ""
		  puts "Exiting update menu..."																# Report exiting update menu.
		  puts ""
		  category_control += 1 																	# Add to category_control to break category menu until loop.
	      update_control += 1	
		else																						# Invalid category selection.
		  puts "Invalid field selection."															# Report invalid category selection.
		  puts ""
		end																							# End update_category_input case.
      end																							# End update_category_input until loop.																						
	else																							# Entry does not exist to be updated.
	  puts ""
	  puts "That entry does not exist."																# Report entry does not exist.
	  puts "Update an entry? Y/N:"
      update_another_input = gets.chomp																# Get update_another_input.
      update_another_input = update_another_input.downcase.to_s										# Turn update_another_input to downcase string.
      case update_another_input																		# Case update_another_input.
      when 'y'																						# User wants to update another entry.
        puts ""	
        puts "Returning to update menu..."															# Report returning to update menu.
		puts ""
	  when 'yes'																					# User wants to update another entry.
		puts ""	
	    puts "Returning to update menu..."															# Report returning to update menu.
		puts ""
	  else																							# User is done with the update menu.
		 puts ""
		 puts "Exiting update menu..."																# Report exiting update menu
		 puts ""
	     update_control += 1																		# Add to update_control to break update menu until loop.
	   end																						
	end																								# End entry existence check if statement.
  end																								# End update_control until loop.
end																									# End Update Entry Object

def delete_entry																					# Delete Entry Object
  tomdata = YAML::Store.new("data.yml")																# Open data.yml
  delete_control = 0																				# Define delete_control variable to control delete menu until loop.
  until delete_control == 1																			# delete_control until loop begin.
    puts ""
	puts "What entry would you like to delete?"														# Prompt for delete_input.
	delete_input = gets.chomp																		# Get delete_input.
	delete_input = integer_replace(space_replace(delete_input))										# Call integer&space_replace on delete_input.
	if tomdata.transaction {tomdata.root?(delete_input.to_sym)}										# If statement check to see delete_input entry exists.
	  puts ""
	  puts "Are you sure you'd like to delete the entry for '#{delete_input}'? Y/N:"				# Entry exists. Confirm delete. Prompt for delete_confirm_input.
	  delete_confirm_input = gets.chomp																# Get delete_confirm_input.
	  delete_confirm_input = space_replace(delete_confirm_input)									# Call space_replace on delete_confirm_input.
	  case delete_confirm_input																		# Case delete_confirm_input begin.
	  when 'y'																						# Delete confirmed.
	    delete_data(delete_input)																	# Call delete_data on delete_input.
		puts ""											
		puts "Entry for '#{delete_input}' was deleted."												# Report entry deleted.
		puts "Would you like to delete an entry? Y/N:"
		delete_another_input = gets.chomp															# Get delete_another_input.
	    delete_another_input = space_replace(delete_another_input)									# Call space_replce on delete_another_input.
	    case delete_another_input																	# Case delete_another_input begin.
	    when 'y'																					# User wants to delete an entry.
	      puts ""
		  puts "Returning to delete menu..."														# Report returning to delete menu.
		  puts ""
	    when 'yes'																					# User wants to delete an entry.
	      puts ""
	      puts "Returning to delete menu..."														# Report returning to delete menu.
		  puts ""
	    else
	      puts ""
		  puts "Exiting delete menu..."																# Report exiting delete menu.
		  puts ""
		  delete_control += 1																		# Add to delete_control to break delete menu until loop.
	    end																							# End delete_confirm_input case.
	  when 'yes'																					# Delete confirmed.
	    delete_data(delete_input)																	# Call delete_data on delete_input.
		puts ""	
		puts "Entry for '#{delete_input}' was deleted."												# Report entry deleted.
		puts "Would you like to delete another entry? Y/N:"
		delete_another_input = gets.chomp															# Get delete_another_input.
	    delete_another_input = space_replace(delete_another_input)									# Call space_replce on delete_another_input.
	    case delete_another_input																	# Case delete_another_input begin.
	    when 'y'																					# User wants to delete an entry.
	      puts ""
		  puts "Returning to delete menu..."														# Report returning to delete menu.
		  puts ""
	    when 'yes'																					# User wants to delete an entry.
	      puts ""
	      puts "Returning to delete menu..."														# Report returning to delete menu.
		  puts ""
	    else
	      puts ""
		  puts "Exiting delete menu..."																# Report exiting delete menu.
		  puts ""
		  delete_control += 1																		# Add to delete_control to break delete menu until loop.
	    end																							# End delete_confirm_input case.
	  else																							# Delete unconfirmed. 
	    puts ""
		puts "Entry for '#{delete_input}' was not deleted."											# Prompt for delete_another_input.
		puts "Would you like to delete an entry? Y/N:"
		delete_another_input = gets.chomp															# Get delete_another_input.
	    delete_another_input = space_replace(delete_another_input)									# Call space_replce on delete_another_input.
	    case delete_another_input																	# Case delete_another_input begin.
	    when 'y'																					# User wants to delete an entry.
	      puts ""
		  puts "Returning to delete menu..."														# Report returning to delete menu.
		  puts ""
	    when 'yes'																					# User wants to delete an entry.
	      puts ""
	      puts "Returning to delete menu..."														# Report returning to delete menu.
		  puts ""
	    else
	      puts ""
		  puts "Exiting delete menu..."																# Report exiting delete menu.
		  puts ""
		  delete_control += 1																		# Add to delete_control to break delete menu until loop.
	    end																							# End delete_confirm_input case.
	  end																							# End delete_confirm_input until loop.
	else																							# Entry does not exist.
	  puts ""
	  puts "Entry does not exist."																	# Report entry does not exist.
	  puts "Would you like to delete another entry? Y/N:"											# Prompt for delete_another_input.
	  delete_another_input = gets.chomp																# Get delete_another_input.
	  delete_another_input = space_replace(delete_another_input)									# Call space_replace on delete_another_input.
	  case delete_another_input																		# Begin case of delete_another_input.
	  when 'y'																						# User wants to delete an entry.
	    puts ""
		puts "Returning to delete menu..."															# Report returning to delete menu.
		puts ""
	  when 'yes'																					# User wants to delete an entry.
	    puts ""
	    puts "Returning to delete menu..."															# Report returning to delete menu.
		puts ""
	  else																							# User is done with delete menu.
	    puts ""
		puts "Exiting delete menu..."																# Report exiting delete menu.
		puts ""
		delete_control += 1																			# Add to delete_control to end until loop.
	  end																							# End delete_another_input case.
	end																								# End if statement.
  end																							    # End delete_control until loop.
end																									# End Delete Entry Object


def menu
  menu_control = 0
  until menu_control == 1
    puts "Welcome to the Virtual Database."
	puts "This project was made in the spirit of learning." 
	puts "You may share, edit, and redistribute."
	puts ""
	puts "Menu:"
    puts "READ/SEARCH/CREATE/UPDATE/DELETE/OUTPUT/EXIT:"
	menu_input = gets.chomp
	menu_input = space_replace(integer_replace(menu_input))
	case menu_input
	when 'read'
	  puts ""
	  read_entry
	when 'search'
	  puts ""
	  search_entry
	when 'create'
	  puts ""
	  create_entry
	when 'update'
	  puts ""
	  update_entry
    when 'delete'
	  puts ""
	  delete_entry
	when 'output'
	  puts ""
	  export_entry
	when 'exit'
	  puts ""
	  puts "Thank you for using Virtual Database." 
	  puts "I was developed by someone learning the Ruby language," 
	  puts "and I'm glad you find me useful." 
	  puts "Press RETURN or ENTER to exit."
	  exit = gets.chomp
	  menu_control += 1
	else
	  puts ""
	  puts "Invalid selection."
	  puts ""
	end
  end
end

menu
