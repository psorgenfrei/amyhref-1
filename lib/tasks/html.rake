namespace :html do
  desc "Generate a new homepage with links from the last 24 hours"
  task generate_homepage: :environment do
    require 'fileutils'

    # Backup the existing homepage
    FileUtils.cp(Rails.root + 'app/views/home/index.html.slim', Rails.root + "app/views/home/index-#{Date.yesterday}.html.slim")

    page = Rails.root + 'public/homepage-template.html.slim'
    doc = Nokogiri::HTML(open(page))
    doc.encoding = 'utf-8'

    h1 = doc.at_css('h1')
    h1.content = "Amy Href's links of the day for " + Time.now.strftime("%A, %b %d %Y").to_s + ' 😎'

    div = doc.css('div#links')[0]

    # get page title and create an embed.ly card for each href
    Href.where(['created_at > ?', 1.day.ago.at_beginning_of_day]).where(:good => true).order('RAND()').limit(24).each do |href|
      title = Mechanize.new.get(href.url).title rescue next
      card = "<a id='#{href.id}' class='embedly-card' data-card-via='amyhref.com' data-card-controls='0' href='#{href.url}'>#{title}</a><p id='break'></p>"
      div.add_child(card)
    end

    File.open(Rails.root + 'app/views/home/index.html.slim', 'w:utf-8') {|f| f.write(doc.to_html) }
    restart_cmd = 'touch ' + Rails.root.to_s + '/tmp/restart.txt'
    system(restart_cmd)
  end
end
