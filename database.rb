require "yaml/store"
tomdata = YAML::Store.new("data.yml")														# Create data.yml

def integer_replace(string)																	# Integer Replace Object
 string = string.downcase.to_s																# Turn input to downcase string.
 ## Replace integers in string with .gsub, line break for formatting ##												
 string.gsub("1","one").gsub("2","two").gsub("3","three").gsub("4","four").gsub("5","five")\
 .gsub("6","six").gsub("7","seven").gsub("8","eight").gsub("9","nine").gsub("0","zero")
end																							# End Integer Replace Object

def space_replace(string)																	# Space Replace Object
  string.downcase.to_s.gsub(" ","_")														# Replace " " with "_" in string
end																							# End Space Replace Object

def desc_translate(name)																	# Desc Translate Object
  (name + "_desc").to_sym																	# Convert desc to a storable sym
end																							# End Desc Translate Object

def tags_translate(name)																	# Tags Translate Object
  (name + "_tags").to_sym																	# Convert tags to storable sym (not the hash, just the name).
end																							# End Tags Translate Object
	
def time_translate(name)																	# Time Translate Object
  (name + "_time").to_sym																	# Convert time to storable sym
end																							# End Time Translate Object

def last_update_translate(name)																# Last Update Translate Object
  (name + "_last_update").to_sym															# Convert last update to storably sym
end																							# End Last Update Translate Object

def delete_data(name)
  tomdata = YAML::Store.new("data.yml")														# Open data.yml
  tomdata.transaction {tomdata.delete(name.to_sym)}											# Delete name
  tomdata.transaction {tomdata.delete(desc_translate(name))}								# Delete description
  tomdata.transaction {tomdata.delete(tags_translate(name))}								# Delete tags
  tomdata.transaction {tomdata.delete(time_translate(name))}								# Delete time
  tomdata.transaction {tomdata.delete(last_update_translate(name))}							# Delete last update
end


def create_entry																			# Create Entry Object
  tomdata = YAML::Store.new("data.yml")										     		    # Open data.yml
  create_entry_control = 0																	# Make create_entry_control variable for until loop.
  until create_entry_control == 1															# create_entry_control until loop
    puts " "
    puts "Enter name for entry:"															# Prompt user for entry name.
    entry_name_input = gets.chomp															# Get entry_name_input
	entry_name_preserved = entry_name_input.to_s											# Keep unsymed string as entry_name_preserved
    entry_name_input = integer_replace(entry_name_input)									# Call integer_replace on entry_name_input
	entry_name_input = space_replace(entry_name_input)										# Call space_replace on entry_name_input
    if tomdata.transaction {tomdata.root?(entry_name_input.to_sym)}							# Check to see if entry already exists
      puts ""
      puts "An entry already exists with that name."										# Entry already exists. Alert user.
    else																					# Entry does not exist.
      puts ""
      puts "Enter description for entry:"													# Prompt for an entry description.
      entry_description_input = gets.chomp													# Get entry_description_input
      entry_description_input = entry_description_input.to_s								# Turn entry_description_input to string.
      puts ""
      puts "Enter tags for entry."															# Prompt user for tags.
      puts "Integers will be replaced with spelled out numbers."
      puts "Enter 'done' when finished:"
      entry_tags = Array.new																# Create entry_tags array
      tag_control = 0																		# Create tag_control variable for until loop
      until tag_control == 1																# tag_control until loop
        entry_tag_input = gets.chomp														# Get entry_tag_input 
        entry_tag_input = integer_replace(entry_tag_input)									# Call integer_replace on entry_tag_input
        entry_tag_input = space_replace(entry_tag_input)									# Call space_replace on entry_tag_input
        case entry_tag_input																# Case entry_tag_input.
        when 'done'																			# User is done entering tags.
          puts ""
          print "Tags saved for this entry: "												# Print tags saved for entry.
          print entry_tags																	# Print entry_tags array
          tag_control += 1																	# +1 to tag_control variable
        else																				# User wants to add tag
          entry_tags << entry_tag_input.to_sym												# Convert entry_tag_input to sym and add it to entry_tags array.
        end																					# End case of entry_tag_input
      tomdata.transaction do																# Open tomdata.transaction to add entry to data.yml
        tomdata[entry_name_input.to_sym]             = entry_name_preserved			        # Store entry_name_input
        tomdata[(entry_name_input + "_desc").to_sym] = entry_description_input				# Store entry_description_input
        tomdata[(entry_name_input + "_tags").to_sym] = entry_tags							# Store entry_tags array
        tomdata[(entry_name_input + "_time").to_sym] = Time.now								# Store time of creation.
      end																					# End tomdata.transaction
      end																					# End tag_control until loop
    puts ""
    puts "Would you like to add another entry? Y/N:"										# Ask user if they want to add another another entry.
    another_entry_input = gets.chomp														# Get another_entry_input
    another_entry_input = another_entry_input.downcase.to_s									# Turn another_entry_input to a downcase string.
    case another_entry_input																# Case another_entry_input
    when 'n'																				# When 'n'
      create_entry_control += 1																# create_entry_control + 1
    when 'no'																				# When 'no'
      create_entry_control += 1																# create_entry_control + 1
    end																						# End another_entry_input_case
    end																						# End entry_name_input if statement														
  end																						# End create_entry_control until loop
end																							# End Create Entry Object

def update_entry																					# Update Entry Object
  tomdata = YAML::Store.new("data.yml")																# Open data.yml
  update_control = 0																				# Define update_control variable for update menu until loop.
  until update_control == 1																			# update_control until loop
    puts ""
	puts "What entry would you like to update?"														# Prompt for update_name_input.
	update_name_input = gets.chomp																	# Get update_name_input.
	update_name_input = integer_replace(update_name_input)											# Call integer_replace on update_name_input.
	update_name_input = space_replace(update_name_input)											# Call space_replace on update_name_input.
	if tomdata.transaction {tomdata.root?(update_name_input.to_sym)}								# Check to see if entry exists.
	  category_control = 0																			# Entry exists. Define category_control_variable for category menu until loop.
	  until category_control == 1																	# category_control until loop.					
	    puts ""	
	    puts "Enter the field you wish to update:"
	    puts "-- name -- description -- tags"														# Prompt for update_category_input.
	    update_category_input = gets.chomp															# Get update_category_input.
		update_category_input = update_category_input.downcase.to_s									# Turn update_category_input into a downcase string.
		case update_category_input																	# Case update_category_input.
		when 'name'																					# User wants to update entry name.
		  puts ""
		  puts "Enter new name."																	# Prompt for new_name_input.
		  new_name_input = gets.chomp																# Get new_name_input.
		  new_name_preserved = new_name_input.to_s													# Turn new_name_input to downcase string.
		  new_name_input = integer_replace(new_name_input)											# Call integer_replace on new_name_input.
		  new_name_input = space_replace(new_name_input)											# Call space_replace on new_name_input.
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
			puts "Returning to update menu."														# Report to user returning to update menu.
			category_control += 1																	# Add to category_control to break category menu until loop.
		  when 'yes'																				# User wants to update another entry.
		    puts ""					
			puts "Returning to update menu."														# Report to user returning to update menu.
			category_control += 1																	# Add to category control to break category menu until loop.
		  else																						# User is done with the update menu.
		    puts ""
		    puts "Exiting update menu."																# Report to user exiting upate menu.
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
			puts "Returning to update menu."														# Report returning to update menu.
			category_control += 1																	# Add to category_control to break category menu until loop.
		  when 'yes'																				# User wants to update another entry.
		    puts ""
			puts "Returning to update menu."														# Report returning to update menu.
			category_control += 1																	# Add to category_control to break category menu until loop.
		  else																						# User is done with update menu.
		    puts ""
		    puts "Exiting update menu."																# Report exiting update menu.
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
            update_tag_input = integer_replace(update_tag_input)									# Call integer_replace on update_tag_input.								
            update_tag_input = space_replace(update_tag_input)										# Call space_replace on update_tag_input.
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
			puts "Returning to update menu."														# Report returning to update menu.
			category_control += 1																	# Add to category_control to break category menu until loop.
		  when 'yes'																				# User wants to update another entry.
		    puts ""	
			puts "Returning to update menu."														# Report returning to update menu.
			category_control += 1																	# Add to category_control to break category menu until loop.
		  else																						# User is done with the update menu.
		    puts ""
		    puts "Exiting update menu."																# Report exiting update menu.
		    category_control += 1 																	# Add to category_control to break category menu until loop.
			update_control += 1																		# Add to update_control to break update menu until loop.
		  end																						# End update_another_input case.
		else																						# Invalid category selection.
		  puts "Invalid field selection."															# Report invalid category selection.
		end																							# End update_category_input case.
      end																							# End update_category_input until loop.																						
	else																							# Entry does not exist to be updated.
	  puts "That entry does not exist."																# Report entry does not exist.
	end																								# End entry existence check if statement.
  end																								# End update_control until loop.
end																									# End Update Entry Object

## DEBUG AND TEST COMMANDS ##


create_entry
update_entry
gets.chomp

