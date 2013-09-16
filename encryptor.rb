puts "Enter Password: "
password = gets
if Digest::MD5.hexdigest(password.chomp) != File.open('settings/dc.log','r').read
	puts File.open('settings/dc.log').read
	abort("WRONG PASSWORD!")
end

class Encryptor

	def cipher(rotation)
    characters = (' '..'z').to_a
	  rotated_characters = characters.rotate(rotation)
	  Hash[characters.zip(rotated_characters)]
  end

	def rotate_letters(letter, rotation)
	  cipher_for_rotation = cipher(rotation)
	  cipher_for_rotation[letter]
	end

	def _crypt(string, rotation)
		letters = string.split("")
	  changed_letters = letters.collect{ |letter| 
	  	letter = rotate_letters(letter, rotation)}
	  changed_letters.join
	end

	def encrypt(string, rotation)
	  _crypt(string, rotation)
	end
	
	def decrypt(string, rotation)
		_crypt(string, -rotation)
	end

	def read_file(filename)
		input = File.open(filename, "r")
		input.read
	end

	def write_file(filename, content)
		output = File.open(filename, "w")
		output.write(content)
		output.close
	end

	def encrypt_file(filename, rotation)
		file = read_file(filename)
		new_content = file.split("\n").collect{ |line| encrypt(line, rotation) }
		write_file(filename+".encrypted",new_content.join("\n"))
	end

	def decrypt_file(filename, rotation)
		file = read_file(filename)
		new_content = file.split("\n").collect{ |line| decrypt(line, rotation) }
		write_file(filename.gsub("encrypted","decrypted"),new_content.join("\n"))
	end

	def supported_characters
    (' '..'z').to_a
  end

	def crack(message)
		supported_characters.count.times.collect do |attempt|
			decrypt(message,attempt)
		end
	end

	def prompt_for_input
		puts "Input: "
		gets.chomp
	end

	def rte_chat(rotation)
		puts "Begin Real-Time Encryption Chat\n"
		e_msg = ""
		while !decrypt(e_msg,rotation).eql? "Quit"
			e_msg = encrypt(prompt_for_input,rotation)
			puts "Encrypted Message: #{e_msg}\n\n" 
		end
	end

	def rtd_chat(rotation)
		puts "Begin Real-Time Decryption Chat\n"
		d_msg = ""
		while !encrypt(d_msg,rotation).eql? "Quit"
			d_msg = decrypt(prompt_for_input,rotation)
			puts "Decrypted Message: #{d_msg}\n\n"
		end 
	end
end