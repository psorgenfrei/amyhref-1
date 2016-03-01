class YouController < ApplicationController
  before_filter :require_user

  def index
    @imap = Net::IMAP.new('imap.gmail.com', 993, usessl = true, certs = nil, verify = false)
    @imap.authenticate('XOAUTH2', current_user.email, current_user.tokens.last.fresh_token)

    amyhref_folder_name = 'amyhref.com'

    # Setup the amyhref.com label
    if not @imap.list('', amyhref_folder_name)
      @imap.create(amyhref_folder_name)
    end

    #begin
    #  @imap.create(amyhref_folder_name)
    #rescue Net::IMAP::NoResponseError
    #  # folder exists
    #end

    @inbox_messages_count = 0 #@imap.status('INBOX', ['MESSAGES'])['MESSAGES']
    @all_messages_count = 0 #@imap.status("[Google Mail]/All Mail", ['MESSAGES'])['MESSAGES']

    #@imap.examine("[Google Mail]/All Mail") # read-only
    #@imap.uid_search(["NOT", "DELETED"]).each_with_index do |message_id, index|
    #  next if index >= 50
    #  envelope = @imap.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
    #  "#{envelope.from[0].name}: \t#{envelope.subject}"
    #end

    @messages = []
    @imap.select("[Google Mail]/All Mail")
    @imap.search(['SINCE', 2.weeks.ago]).each do |message_id|
      #envelope = @imap.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
      #@messages << "#{envelope.from[0].name}: \t#{envelope.subject}"

      email_header = @imap.fetch(message_id, 'RFC822.HEADER') # equiv to BODY.PEEK

      if email_header[0].attr['RFC822.HEADER'].downcase.include? 'list-unsubscribe'
        #puts email_header[0].attr['RFC822.HEADER'].inspect
        #puts "--"

        envelope = @imap.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
        @messages << "#{envelope.from[0].name}: \t#{envelope.subject}"

        @imap.copy(message_id, amyhref_folder_name)
        @imap.store(message_id, "+FLAGS", [:Deleted])
        @imap.store(message_id, "+FLAGS", [:Seen])
        @imap.expunge
      end
    end

    # using Mail to parse responses
    #body = @imap.fetch(message_id,'BODY[TEXT]')[0].attr['BODY[TEXT]']
    #msg = @imap.fetch(-1,'RFC822')[0].attr['RFC822']
    #mail = Mail.read_from_string msg

    @imap.logout
    @imap.disconnect
  end
end
