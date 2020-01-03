require 'pdf-reader'

def extractFiles(directory)
    hash = {}
    Dir.foreach(directory) do |file|
        begin
            if file.include? "pdf"
                reader = PDF::Reader.new(file)
                array = []
                reader.pages.each do |page|
                    if page.text.include? "Activities offered Identify those programs available at your institution."
                        array = page.text.split("Activities offered Identify those programs available at your institution.").last.split("ROTC (program offered in cooperation with Reserve Officers' Training Corps)").first.strip.gsub(/\s+/, " ").split("F2")
                    end
                end
                array.each do |item|
                    if !item.downcase.include? "x"
                        array.delete(item)
                    end
                end
                array.each do |item|
                    array2 = []
                    item.split(" ").each do |word|
                        word.downcase!
                        word = word.tr('x','').gsub("f3","").gsub("-"," ").capitalize()
                        array2 << word
                    end
                    array[array.index(item)] = array2.join(" ")
                end
                cleaned = file.gsub(".pdf","").gsub("_"," ").gsub(".","")
                hash[cleaned] = array
            end
        rescue
            puts "File broken! Moving on . . . "
        end
    end
    return hash
end


'C:\Users\willi\Documents\CDS'
