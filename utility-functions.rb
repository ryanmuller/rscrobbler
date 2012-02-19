
# calculate SHA-2 hash for a given file
def hashsum(filename)
  p filename
  require 'digest/sha2'    
  hashfunc = Digest::SHA2.new
  File.open(filename, "r") do |io|
    counter = 0
    while (!io.eof)
      readBuf = io.readpartial(1024)
      #				putc '.' if ((counter+=1) % 3 == 0)
      hashfunc.update(readBuf)
    end
  end
  return hashfunc.hexdigest
end

