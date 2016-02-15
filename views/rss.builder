xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
	xml.channel do
		xml.title "Recall"
		xml.description "'cause you're too busy to remember"
		xml.link request.url.chomp request.path_info
	end
end
